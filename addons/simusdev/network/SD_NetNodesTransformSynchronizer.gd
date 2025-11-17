@icon("res://addons/simusdev/icons/Network.png")
extends Node
class_name SD_NetNodesTransformSynchronizer

@export var properties: Array[String] = ["transform"]
@export var callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.UNRELIABLE
@export var channels: Array[String] = [SD_NetTrunkCallables.CHANNEL_DEFAULT]
@export var tickrate: float = SD_NetSync.DEFAULT_TICKRATE
@export var tickrate_mode: SD_NetSyncedBase.TICKRATE_MODE
@export var interpolate_speed: float = SD_NetSync.DEFAULT_TICKRATE
@export var _roots: Array[Node] = []

var _initialized_roots: Array[Node] = []

var _data: Dictionary = {}

signal on_tick()

var _timer: Timer

var _changed: bool = false

var _initialized: bool = false

var _queue: Dictionary = {}

var _channel_id: int = 0

func get_data() -> Dictionary:
	return _data

func _ready() -> void:
	if SD_Network.singleton.is_active():
		initialize()
		return
	
	SD_Network.singleton.on_connected_to_server.connect(initialize, ConnectFlags.CONNECT_ONE_SHOT)

func initialize() -> void:
	if _initialized:
		return
	
	SD_Network.register_object(self)
	
	SD_Network.register_function(_recieve_data)
	SD_Network.register_function(_send_data_to_client)
	
	for channel in channels:
		SD_Network.register_channel(channel)
	
	set_process(not SD_Network.is_server())
	
	for i in _roots:
		add_root(i)
	
	if SD_Network.is_server():
		
		_timer = Timer.new()
		_timer.autostart = tickrate_mode != SD_NetSyncedBase.TICKRATE_MODE.DISABLED
		_timer.wait_time = 1.0 / tickrate
		_timer.timeout.connect(_on_timer_timeout)
		if tickrate_mode == SD_NetSyncedBase.TICKRATE_MODE.PHYSICS:
			_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
		if tickrate_mode == SD_NetSyncedBase.TICKRATE_MODE.IDLE:
			_timer.process_callback = Timer.TIMER_PROCESS_IDLE
		
		add_child(_timer)
	else:
		SD_Network.call_func_on_server(_send_data_to_client, [], SD_Network.CALLMODE.RELIABLE, channels.pick_random())
	
	_initialized = true

func add_root(node: Node) -> void:
	if _initialized_roots.has(node):
		return
	
	
	if SD_Network.is_server():
		node.child_entered_tree.connect(_on_root_child_entered_tree)
		
		for child in node.get_children():
			_on_root_child_entered_tree(child)
	
	_initialized_roots.append(node)

func remove_root(node: Node) -> void:
	if not _initialized_roots.has(node):
		return
	
	
	if SD_Network.is_server():
		node.child_entered_tree.disconnect(_on_root_child_entered_tree)
	
	_initialized_roots.erase(node)

func _process(delta: float) -> void:
	for root in _initialized_roots:
		for node_name: String in _data:
			var node: Node = root.get_node_or_null(node_name)
			if !node:
				continue
			
			
			
			var synced: Dictionary = _data[node_name]
			for p in synced:
				if p == null:
					continue
				
				var value: Variant = synced[p]
				var node_value: Variant = node.get(p)
				node_value = lerp(node_value, value, interpolate_speed * delta)
				node.set(p, node_value)

func _on_root_child_entered_tree(child: Node) -> void:
	if child is SD_NetNodesTransformSynchronizer:
		return
	
	var hook := SD_NetNodeSyncTransformHook.get_or_create(child, self)

func _on_timer_timeout() -> void:
	on_tick.emit()
	
	if _changed:
		_channel_id += 1
		if _channel_id > channels.size() - 1:
			_channel_id = 0
		
		SD_Network.call_func(_recieve_data, [_queue], callmode, channels[_channel_id])
		_changed = false
		_queue.clear()

func _send_data_to_client() -> void:
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_data, [_data], SD_Network.CALLMODE.RELIABLE, channels.pick_random())

func _recieve_data(new: Dictionary) -> void:
	_data.merge(new, true)
