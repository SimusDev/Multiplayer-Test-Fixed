class_name SourceItem extends Node3D

signal on_use
signal on_current_change

@export var resource:R_SourceItem
@export var model:Node3D
@export var always_can_use:bool = false

@export_group("Node References")
@export var animation_player:AnimationPlayer  

@export_group("Animations Names")
@export var _fire:String = "fire"
@export var _reload:String = "reload"
@export var _pick:String = "pick"

var current:bool = false : set = set_current, get = is_current


func _ready() -> void:
	on_current_change.connect(_on_current_changed)

func _on_current_changed():
	animation_player.play("RESET")
	if is_current(): animation_player.play(_pick) 
	else: animation_player.play_backwards(_pick) 


func set_current(value:bool):
	current = value
	on_current_change.emit()
func is_current(): return current

func _process(_delta: float) -> void:
	self.visible = current
	if is_multiplayer_authority() and current:
		if Input.is_action_pressed("fire"):
			if SimusDev.ui.get_active_interfaces().is_empty() or always_can_use:
				SD_Multiplayer.sync_call_function(self, use)
#ZV EZ
func use():
	if not is_inside_tree():
		return
	if is_instance_valid(animation_player):
		if not animation_player.is_playing():
			animation_player.play(_fire)
			on_use.emit()
