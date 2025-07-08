@tool
class_name SourceItem extends Node3D

signal on_use

@export var resource:R_SourceItem

@export_group("References")
@export var model:Node3D

func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	if is_multiplayer_authority():
		if Input.is_action_pressed("fire"):
			SD_Multiplayer.sync_call_function(self, use)

func use():
	if not is_inside_tree():
		return
	
	on_use.emit()
