extends Node3D

@onready var label_3d: Label3D = $Label3D

@onready var c_nabludator_health: C_NabludatorHealth = $C_NabludatorHealth

func _ready() -> void:
	c_nabludator_health.health_changed.connect(update)
	update()

func update() -> void:
	label_3d.text = str(round(c_nabludator_health.health))
