class_name SourceInteractRaycast extends RayCast3D

signal collider_changed

@export var player:SourcePlayer
var collider:Node3D = null : set = set_collider
@onready var object_info = preload("res://Games/source_game/game/object_info/object_info.tscn").instantiate()

func _ready() -> void:
	add_child(object_info)

func set_collider(_collider:Node3D):
	collider = _collider
	collider_changed.emit(collider)
	
	if !_collider: return


func _process(_delta: float) -> void:
	set_collider(get_collider())
