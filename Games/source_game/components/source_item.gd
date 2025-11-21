@icon("res://Games/source_game/components/icons/item.png")
class_name SourceItem extends Node3D


signal use_just_pressed
signal use_just_released

@export var resource:R_SourceItem
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
			release
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
	
	if use_hold:
		using()
	

func using() -> void:
	pass

func can_use() -> bool:
	if is_instance_valid(animation_player):
		return not animation_player.is_playing()
	return true

func play_animation(anim_name:StringName, ignore_playing:bool = true) -> void:
	if is_instance_valid(animation_player) and animation_player.has_animation(anim_name):
		if not animation_player.is_playing() or ignore_playing:
			animation_player.play(anim_name)

func publish_event(event_name:StringName) -> S_EventItemUse:
	var event:S_Event = SourceEvents.get_by_script(S_EventItemUse) as S_EventItemUse
	event.item = self
	event.source = player
	
	var event_status: bool = event.publish()
	if event_status:
		if not is_inside_tree():
			return event
		
		use_just_pressed.emit()
		
		var inv_event: SD_Event = inventory.event_get_or_create(event_name)
		inv_event.publish([self])
	return event

func use() -> void:
	use_hold = true
	publish_event("item_use")
	use_just_pressed.emit()

func release() -> void:
	use_hold = false
	publish_event("item_release")
	use_just_released.emit()
