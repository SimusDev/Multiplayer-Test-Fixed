@icon("res://addons/simusdev/icons/Animation.svg")
extends Node
class_name SD_UIPopupAnimation

var reference: SD_UIPopupReference
var animation: SD_PopupAnimationResource

var _player: AnimationPlayer

var container_resource: SD_PopupContainerResource

var _trunk: SD_TrunkPopups

var _audio_player: SD_NodeAudioPlayer

var _stream_open: AudioStream
var _stream_close: AudioStream

func pick_random_audio(streams: Array[AudioStream]) -> AudioStream:
	if streams.is_empty():
		return null
	return streams.pick_random() as AudioStream

func play_audio(stream: AudioStream) -> void:
	if stream:
		_audio_player.create(stream).play()

func play_open_audio() -> void:
	if animation:
		play_audio(pick_random_audio(animation.audio_open))

func play_close_audio() -> void:
	if animation:
		play_audio(pick_random_audio(animation.audio_close))


func _ready() -> void:
	_trunk = SimusDev.popups
	
	_audio_player = SD_NodeAudioPlayer.new()
	add_child(_audio_player)
	
	if reference.get_container():
		container_resource = reference.get_container().resource
		var default_animations: Array[SD_PopupAnimationResource] = SimusDev.get_settings().popups_default_animations
		if default_animations.is_empty():
			animation = SimusDev.popups.get_default_animation_resource()
		else:
			animation = default_animations.pick_random()
	
	
	reference.state_transitioned.connect(_on_state_transitioned)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if animation:
		_audio_player.default_bus = animation.audio_bus
		_audio_player.default_volume_db = animation.audio_volume_db
	
	if animation and animation.open and animation.close:
		var library: AnimationLibrary = AnimationLibrary.new()
		if animation.open:
			library.add_animation("open", animation.open)
		if animation.close:
			library.add_animation("close", animation.close)
			
		
		_player = AnimationPlayer.new()
		_player.process_mode = Node.PROCESS_MODE_ALWAYS
		_player.add_animation_library("", library)
		
		_player.ready.connect(_on_player_ready)
		reference.get_container().popups_holder.add_child.call_deferred(_player)
		return
	
	
	reference.switch_state(SD_UIPopupReference.STATE.OPEN)

func _player_play_animation(anim_name: String) -> void:
	if not _player:
		return
	
	_player.stop()
	if _player.has_animation(anim_name):
		_player.play(anim_name)
	
func _on_player_ready() -> void:
	_player.animation_finished.connect(_on_player_animation_finished)
	reference.switch_state(SD_UIPopupReference.STATE.OPEN)

func _on_player_animation_finished(animation: String) -> void:
	match animation:
		"open":
			reference.switch_state(SD_UIPopupReference.STATE.OPENED)
		"close":
			reference.switch_state(SD_UIPopupReference.STATE.CLOSED)

func _on_state_transitioned(state: SD_UIPopupReference.STATE) -> void:
	match state:
		SD_UIPopupReference.STATE.OPEN:
			_trunk._active.append(reference)
			_trunk.on_open.emit(reference)
			
			if container_resource:
				if container_resource.manage_popup_process_mode:
					reference.get_source().process_mode = Node.PROCESS_MODE_DISABLED
			
			_player_play_animation("open")
			play_open_audio()
			reference.switch_state(SD_UIPopupReference.STATE.OPENING)
			reference.on_open.emit()
			
			
		SD_UIPopupReference.STATE.OPENING:
			if not _player:
				reference.switch_state(SD_UIPopupReference.STATE.OPENED)
			
		SD_UIPopupReference.STATE.OPENED:
			reference.switch_state(SD_UIPopupReference.STATE.IDLE)
			reference.on_opened.emit()
			
		SD_UIPopupReference.STATE.IDLE:
			if container_resource:
				if container_resource.manage_popup_process_mode:
					reference.get_source().process_mode = Node.PROCESS_MODE_INHERIT
					
		SD_UIPopupReference.STATE.CLOSE:
			_trunk._active.erase(reference)
			_trunk.on_close.emit(reference)
			
			if container_resource:
				if container_resource.manage_popup_process_mode:
					reference.get_source().process_mode = Node.PROCESS_MODE_DISABLED
			
			_player_play_animation("close")
			play_close_audio()
			reference.switch_state(SD_UIPopupReference.STATE.CLOSING)
			reference.on_close.emit()
			
			if not _player:
				if reference.get_container():
					reference.get_container().queue_free()
				else:
					if reference.root:
						reference.root.queue_free()
				
				
		SD_UIPopupReference.STATE.CLOSING:
			if not _player:
				reference.switch_state(SD_UIPopupReference.STATE.CLOSED)
			
			
		SD_UIPopupReference.STATE.CLOSED:
			reference.on_closed.emit()
			if is_instance_valid(reference.get_container()):
				reference.get_container().queue_free()
			
