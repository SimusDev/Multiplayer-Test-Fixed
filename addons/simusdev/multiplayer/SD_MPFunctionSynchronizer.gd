@tool
extends SD_MPSynchronizer
class_name SD_MPFunctionSynchronizer

@export var initial_sources: Array[Node] = []
@export var signal_hook_prefix: String = "net_"
@export var _custom: SD_MPFunctionSynchronizerProperties

var _initialized: Array[SD_MPFSyncedFunction] = []

var _tweens: Array[Tween] = []

var _first_sync: bool = true

func get_id(property: SD_MPFSyncedFunction) -> int:
	return _custom.list.find(property)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
	if Engine.is_editor_hint():
		return
	
	init_custom(_custom)
	
	for src in initial_sources:
		var signals: Array[String] = []
		_parse_signals(signals, src.get_script())
		
		for s_name in signals:
			var property: SD_MPFSyncedFunction = SD_MPFSyncedFunction.new()
			property.node_path = get_path_to(src)
			property.method = s_name.replacen(signal_hook_prefix, "")
			property.signal_hook = s_name
			add_property(property)
		

func _parse_signals(data: Array[String], script: Script) -> void:
	if not script:
		return
	
	for dict in script.get_script_signal_list():
		if dict.name.begins_with(signal_hook_prefix):
			data.append(dict.name)
	
	_parse_signals(data, script.get_base_script())

func init_custom(properties: SD_MPFunctionSynchronizerProperties) -> void:
	if not _custom:
		_custom = SD_MPFunctionSynchronizerProperties.new()
	
	for p in _custom.list:
		add_property(p)

func add_property(property: SD_MPFSyncedFunction) -> void:
	if _initialized.has(property):
		return
	
	_initialized.append(property)
	
	if not property.node_path:
		return
	
	var node: Node = get_node_or_null(property.node_path)
	if !node:
		return
	
	var p_callable: Variant = node.get(property.method)
	var p_signal: Variant = null
	
	if !property.signal_hook.is_empty():
		for sig in node.get_signal_list():
			if sig.name == property.signal_hook:
				p_signal = Signal(node, sig.name)
	
	if p_callable is Callable:
		if p_signal is Signal:
			p_signal.connect(_p_signal_emit.bind(node, property.method))

func _p_signal_emit(args: Variant, node: Node, method: String) -> void:
	if not args is Array or !node:
		return
	
	SD_Multiplayer.sync_call_function_except_self(self, _recieve_function, [args, node, method, SD_Multiplayer.get_unique_id()])

func _recieve_function(args: Array, node: Node, method: String, peer: int) -> void:
	if node:
		if node.has_method(method):
			node.callv(method, args)
		
	print("recieved %s, %s" % [node, method])

func remove_property(property: SD_MPFSyncedFunction) -> void:
	if _initialized.has(property):
		_initialized.erase(property)
		
		var node: Node = get_node_or_null(property.node_path)
		if !node:
			return
		
		var callable: Variant = node.get(property.method)
		if callable is Callable:
			callable
