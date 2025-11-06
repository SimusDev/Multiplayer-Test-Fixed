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
	])
	
	if SD_Network.is_authority(self):
		_base = SD_NodeInput.new()
		_base.set_multiplayer_authority(get_multiplayer_authority())
		_base.multiplayer_authorative = true
		
		add_child(_base)
	
	SD_Components.append_to(root, self)
	
