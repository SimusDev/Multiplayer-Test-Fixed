@icon("res://Games/source_game/components/icons/item.png")
class_name SourceItem extends Node3D


signal use_just_pressed
signal use_just_released

@export var resource:R_SourceWorldObject
@export var model:Node3D
@export var always_can_use:bool = false

@export_group("Node References")
@export var animation_player:AnimationPlayer
@export var pick_sound:AudioStream

@export_group("Animations Names")
@export var _idle:String = "idle"
@export var _fire:String = "fire"
@export var _reload:String = "reload"
@export var _pick:String = "pick"

var player:SourceEntity
var interact_ray:SourceInteractRay

var stack: SourceItemStack

var animated_model: W_AnimatedModel3D
var inventory: SourceInventory

var playable: SourcePlayable

var caller: SD_NetFunctionCaller

var use_hold:bool = false
var alt_use_hold:bool = false

func _ready() -> void:
	caller = SD_NetFunctionCaller.new()
	caller.name = "caller"
	caller.default_channel = "source_item"
	
	stack = SD_Components.find_first(self, SourceItemStack)
	if stack:
		stack.item = self
	
	SD_Network.register_object(self)
	SD_Network.register_functions(
		[
			use,
			release,
			alt_use,
			alt_release
		]
	)
	
	playable = SourcePlayable.find_above(self)
	if playable:
		player = playable.root
		interact_ray = SD_Components.find_first(player, SourceInteractRay)
		animated_model = W_AnimatedModel3D.find_in(playable.root)
		inventory = SD_Components.find_first(playable.root, SourceInventory)
	
	SoundPlayer.play_global_audio_3d(global_position, pick_sound, "game")
	if is_instance_valid(animation_player):
		animation_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
		animation_player.play(_pick)
	
func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		if SimusDev.ui.get_active_interfaces().is_empty() or always_can_use:
			if Input.is_action_just_pressed("fire"):
				caller.call_func(use)
			elif Input.is_action_just_released("fire"):
				caller.call_func(release)
			elif Input.is_action_just_pressed("alt_fire"):
				caller.call_func(alt_use)
			elif Input.is_action_just_released("alt_fire"):
				caller.call_func(alt_release)
	
	if use_hold:
		using()
	if alt_use_hold:
		alt_using()

func using() -> void:
	pass

func alt_using() -> void:
	pass

func can_use() -> bool:
	if is_instance_valid(animation_player):
		return not animation_player.is_playing()
	return true

func create_animation_player(free_on_finish:bool = true) -> AnimationPlayer:
	if not is_instance_valid(animation_player):
		return null
	
	var _player:AnimationPlayer = AnimationPlayer.new()
	_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
	var lib_name:StringName = animation_player.get_animation_library_list()[0]
	_player.add_animation_library("lib",
		animation_player.get_animation_library(lib_name)
		)
	if free_on_finish:
		_player.animation_finished.connect(_player.queue_free)
	add_child(_player)
	
	return _player

func play_animation(anim_name:StringName, backwards:bool = false, ignore_playing:bool = true) -> void:
	if is_instance_valid(animation_player) and animation_player.has_animation(anim_name):
		if not animation_player.is_playing() or ignore_playing:
			if backwards:
				animation_player.play_backwards(anim_name)
			else:
				animation_player.play(anim_name)

func publish_event(event_name:StringName) -> S_EventItemUse:
	var event:S_Event = SourceEvents.get_by_script(S_EventItemUse) as S_EventItemUse
	event.item = self
	event.source = player
	
	var event_status: bool = event.publish()
	if event_status:
		if not is_inside_tree():
			return event
		
		var inv_event: SD_Event = inventory.event_get_or_create(event_name)
		inv_event.publish([self])
	return event

func use() -> void:
	use_hold = true
	publish_event("item_use")
	use_just_pressed.emit()

func alt_use() -> void:
	alt_use_hold = true
	publish_event("alt_item_use")

func release() -> void:
	use_hold = false
	publish_event("item_release")
	use_just_released.emit()

func alt_release() -> void:
	alt_use_hold = false
	publish_event("alt_item_release")
