extends Node
class_name SourceEmotions

@export var root: Node
@export var input: StringName = "source.emotions"
@export var resource: R_SourceEmotions

var _input_node: SD_NodeInput

var _ui: PackedScene

var _current_animation: StringName = ""

var _animated_model: W_AnimatedModel3D

func _ready() -> void:
	SD_Network.register_object(self)
	
	if not root:
		root = get_parent()
	
	_animated_model = W_AnimatedModel3D.find_above(self)
	
	_ui = load("res://Games/source_game/ui/emotions/emotions.tscn")
	
	if SD_Network.is_authority(self):
		_input_node = SD_NodeInput.new()
		_input_node.on_action_just_pressed.connect(_on_action_just_pressed)
		add_child(_input_node)
	
	SD_Network.register_functions([
		_send_animation_to_client,
		_play_animation_synced,
		_recieve_animation,
		_stop_current_animation_sync,
	])
	
	SD_Network.call_func_on_server(_send_animation_to_client)

func _send_animation_to_client() -> void:
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_animation, [_current_animation])

func _recieve_animation(animation: StringName) -> void:
	_play_animation_synced(animation)

func _on_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	if action == input:
		stop_current_animation()
		var interface: SD_UIInterfaceMenu = SourceUIHandler.player_create_from_scene(_ui)
		interface.target.set_emotions(self)

func play_animation(animation: StringName) -> void:
	SD_Network.call_func(_play_animation_synced, [animation])

func stop_current_animation() -> void:
	if _current_animation.is_empty():
		return
	
	SD_Network.call_func(_stop_current_animation_sync)

func _stop_current_animation_sync() -> void:
	if _current_animation.is_empty():
		return
	
	_animated_model.get_animation_player().stop()
	_animated_model.tree.active = true
	_current_animation = ""
	_animated_model.remove_meta("source_emotions_active")

func _play_animation_synced(animation: StringName) -> void:
	if animation.is_empty():
		return
	
	if not _animated_model:
		return
	
	_animated_model.tree.active = false
	_animated_model.get_animation_player().play(animation)
	_current_animation = animation
	_animated_model.set_meta("source_emotions_active", true)

static func is_emotion_active(node: Node) -> bool:
	return node.has_meta("source_emotions_active")
