extends RigidBody3D
class_name SourceEntityDoor

signal interacted(ray: SourceInteractRay)
signal interacted_on_server(ray: SourceInteractRay)
signal status_changed()

@export var status: bool = false

@export var animation_player: AnimationPlayer
@export var audio_player: AudioStreamPlayer3D
@export var audio_close: AudioStream
@export var audio_open: AudioStream
@export var shape: CollisionShape3D

@export var animation_open: String = ""
@export var animation_close: String = ""
@export var play_animation_open_backwards: bool = false
@export var play_animation_close_backwards: bool = false

func play_animation(anim: String, backwards: bool = false) -> void:
	if animation_player:
		if backwards:
			animation_player.play_backwards(anim)
		else:
			animation_player.play(anim)

func play_sound(sound: AudioStream) -> void:
	if audio_player:
		audio_player.stream = sound
		audio_player.play()

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send,
		_recieve,
	])
	
	SD_Network.call_func_on_server(_send, [], SD_Network.CALLMODE.RELIABLE, SourceNetwork.CHANNEL_INTERACTABLES)

func _send() -> void:
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [status], SD_Network.CALLMODE.RELIABLE, SourceNetwork.CHANNEL_INTERACTABLES)

func _recieve(_status: bool) -> void:
	_set_status_net(status, false)

func _do_action_server(ray: SourceInteractRay) -> void:
	set_status(!status)

func set_status(new: bool) -> void:
	if !SD_Network.is_server():
		return
	
	
	
	_set_status_net(new)
	SD_Network.call_func_except_self(_set_status_net, [new])
	

func _set_status_net(new: bool, sound: bool = true) -> void:
	status = new
	shape.disabled = new
	status_changed.emit(sound)
	
	if sound:
		if new:
			play_sound(audio_open)
		else:
			play_sound(audio_close)
	
	if new:
		play_animation(animation_open, play_animation_open_backwards)
	else:
		play_animation(animation_close, play_animation_close_backwards)

func _source_interacted(ray: SourceInteractRay) -> void:
	interacted.emit(ray)
	if SD_Network.is_server():
		_do_action_server(ray)
		interacted_on_server.emit(ray)

func _on_source_interactable_on_interacted(ray: SourceInteractRay) -> void:
	_source_interacted(ray)
