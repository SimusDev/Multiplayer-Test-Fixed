@icon("res://Games/all-stars/components/icons/Unit.png")
extends CharacterBody3D
class_name Unit

signal lvl_changed(value)
signal experience_changed(value)

@export var unit_properties:R_UnitProperties
@export var debug_point:Node3D

@onready var player:SD_MultiplayerPlayer = SD_Multiplayer.get_authority_player()


func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			AllstarsPlayer.instance.current_unit = self
