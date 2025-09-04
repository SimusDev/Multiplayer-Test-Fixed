extends Node
class_name SourceEmotions

@export var root: Node
@export var input: StringName = "source.emotions"
@export var resource: R_SourceEmotions

var _input_node: SD_NodeInput

var _ui: PackedScene

func _ready() -> void:
	if not root:
		root = get_parent()
	
	_ui = load("res://Games/source_game/ui/emotions/emotions.tscn")
	
	if SD_Network.is_authority(self):
		_input_node = SD_NodeInput.new()
		_input_node.on_action_just_pressed.connect(_on_action_just_pressed)
		add_child(_input_node)

func _on_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	if action == input:
		var interface: SD_UIInterfaceMenu = SourceUIHandler.player_create_from_scene(_ui)
		interface.target.set_emotions(self)
