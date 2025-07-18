extends Node
class_name C_NabludatorItemUsage

@export var source: Node3D

@export var viewmodel: C_NabludatorEntityViewModel

var _player_input: SD_NodeInput

func _ready() -> void:
	if !source:
		source = get_parent()
	
	if !viewmodel:
		return
	
	if !viewmodel.is_node_ready():
		await viewmodel.ready
	
	if source is Nabludator:
		_player_input = SD_NodeInput.new()
		_player_input.name = "input"
		_player_input.multiplayer_authorative = true
		_player_input.set_multiplayer_authority(get_multiplayer_authority())
		add_child(_player_input)
		_player_input.on_input.connect(_on_player_input)

func _on_player_input(event: InputEvent) -> void:
	if not viewmodel.actions:
		return
	
	if event is InputEventKey:
		if event.is_pressed():
			viewmodel.actions.set_use(true, event.as_text_key_label().to_lower())
		else:
			viewmodel.actions.set_use(false, event.as_text_key_label().to_lower())
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			viewmodel.actions.set_use(true, "mouse" + str(event.button_index))
		else:
			viewmodel.actions.set_use(false, "mouse" + str(event.button_index))
