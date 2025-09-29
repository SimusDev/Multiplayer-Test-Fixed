extends Node
class_name SourceEntityInput

@export var root: Node
var _base: SD_NodeInput

@export var allowed_actions: Array[StringName] = []

signal action_just_pressed(action: StringName)
signal action_just_released(action: StringName)

func _ready() -> void:
	if not root:
		root = get_parent()
	
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_just_pressed_net,
		_just_released_net,
	])
	
	if SD_Network.is_authority(self):
		_base = SD_NodeInput.new()
		_base.set_multiplayer_authority(get_multiplayer_authority())
		_base.multiplayer_authorative = true
		
		_base.on_action_just_pressed.connect(_base_on_action_just_pressed)
		_base.on_action_just_released.connect(_base_on_action_just_released)
		
		add_child(_base)
	
	SD_Components.append_to(root, self)
	


func _base_on_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	if !allowed_actions.is_empty() and !allowed_actions.has(action):
		return
	
	SD_Network.call_func(_just_pressed_net, [SD_Network.singleton.cache.serialize_input_map(action)])

func _base_on_action_just_released(action: String, bind: SD_Keybind) -> void:
	if !allowed_actions.is_empty() and !allowed_actions.has(action):
		return
	
	SD_Network.call_func(_just_released_net, [SD_Network.singleton.cache.serialize_input_map(action)])

func _just_pressed_net(serialized: int) -> void:
	var action: StringName = SD_Network.singleton.cache.deserialize_input_map(serialized)
	action_just_pressed.emit(action)
	

func _just_released_net(serialized: int) -> void:
	var action: StringName = SD_Network.singleton.cache.deserialize_input_map(serialized)
	action_just_released.emit(action)
