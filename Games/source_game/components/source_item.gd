@icon("res://Games/source_game/components/icons/source_item.png")
class_name SourceItem extends Node3D

signal on_use
signal on_current_change

@export var resource:R_SourceItem
@export var model:Node3D
@export var always_can_use:bool = false

@export_group("Node References")
@export var animation_player:AnimationPlayer
@export var pick_sound:AudioStream

@export_group("Animations Names")
@export var _fire:String = "fire"
@export var _reload:String = "reload"
@export var _pick:String = "pick"

var player:SourcePlayer
var current:bool = false : set = set_current, get = is_current

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions(
		[
			use,
		]
	)
	
	player = (get_parent() as SourceItemContainer).player
	on_current_change.connect(_on_current_changed)

func _on_current_changed():
	if not is_instance_valid(animation_player): return
	
	animation_player.play("RESET")
	if is_current():
		animation_player.play(_pick) 
		SoundPlayer.play_global_audio_3d(global_position, pick_sound, "game")

	self.visible = is_current()
	#какие то баги бл* рука дергается !!""!№!;!;


func set_current(value:bool):
	current = value
	on_current_change.emit()
func is_current(): return current

func _process(_delta: float) -> void:
	if is_multiplayer_authority() and current:
		if Input.is_action_pressed("fire"):
			if SimusDev.ui.get_active_interfaces().is_empty() or always_can_use:
				if is_instance_valid(animation_player):
					if not animation_player.is_playing():
						SD_Network.call_func(use)
#ZV EZ
func use(local: bool = false):
	var event := SourceEvents.get_by_script(S_EventItemUse) as S_EventItemUse
	event.item = self
	event.container = get_parent()
	event.source = player
	event.player = player
	
	var event_status: bool = event.publish()
	if event_status:
		if not is_inside_tree(): #v padlu
			return
		
		animation_player.play(_fire)
		
		on_use.emit()
		
