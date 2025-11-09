@icon("res://Games/source_game/components/icons/item.png")
class_name SourceItem extends Node3D

signal on_use
signal use_pressed
signal use_released
signal on_current_change

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
var current:bool = false : set = set_current, get = is_current

var stack: SourceItemStack

var animated_model: W_AnimatedModel3D
var inventory: SourceInventory

var playable: SourcePlayable

var caller: SD_NetFunctionCaller

func _ready() -> void:
	caller = SD_NetFunctionCaller.new()
	caller.name = "caller"
	caller.default_channel = "source_item"
	
	stack = SD_Components.find_first(self, SourceItemStack)
	if stack:
		stack.item = self
	
	current = true
	SD_Network.register_object(self)
	SD_Network.register_functions(
		[
			use,
		]
	)
	
	playable = SourcePlayable.find_above(self)
	if playable:
		player = playable.root
		interact_ray = SD_Components.find_first(player, SourceInteractRay)
		animated_model = W_AnimatedModel3D.find_in(playable.root)
		inventory = SD_Components.find_first(playable.root, SourceInventory)
		
	if is_instance_valid(animation_player):
		animation_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
	
	on_current_change.connect(_on_current_changed)
	_on_current_changed()

func _on_current_changed():
	if not is_instance_valid(animation_player):
		return

	self.visible = is_current()
	if is_current():
		self.hide()
		SoundPlayer.play_global_audio_3d(global_position, pick_sound, "game")
		if not _pick == "":
			animation_player.play(_pick)
		
		self.show()                    #                |
	#                                                       |
		#какие то баги бл* рука дергается !!""!№!;!;________|


func set_current(value:bool):
	current = value
	on_current_change.emit()
func is_current(): return current

func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority() and current:
		if SimusDev.ui.get_active_interfaces().is_empty() or always_can_use:
			if Input.is_action_just_pressed("fire"):
				caller.call_func(use, ["item_use_pressed", use_pressed])
			elif Input.is_action_just_released("fire"):
				caller.call_func(use, ["item_use_released", use_released])
			
			elif Input.is_action_pressed("fire"):
				if is_instance_valid(animation_player):
					if not animation_player.is_playing():
						caller.call_func(use)
				else:
					caller.call_func(use)
		

func use(event_name:StringName = "item_use", use_signal:Signal = on_use) -> void:
	var event := SourceEvents.get_by_script(S_EventItemUse) as S_EventItemUse
	event.item = self
	event.source = player
	
	var event_status: bool = event.publish()
	if event_status:
		if not is_inside_tree(): #v padlu
			return
		
		if animation_player and (not _fire == ""):
			animation_player.play(_fire)
		
		use_signal.emit()
		
		var inv_event: SD_Event = inventory.event_get_or_create(event_name)
		inv_event.publish([self])
