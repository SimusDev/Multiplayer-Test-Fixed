extends Node3D

@export var door: FW_DoorComponent

func _ready() -> void:
	door.status_changed.connect(_on_status_changed)
	door.updated.connect(update)
	
	update()

func _on_status_changed() -> void:
	update()
	
	if door.get_status():
		$AnimationPlayer.play_backwards("door")
	else:
		$AnimationPlayer.play("door")
	
	$AudioStreamPlayer3D.play()
	

func update() -> void:
	%collision.disabled = not door.get_status()
