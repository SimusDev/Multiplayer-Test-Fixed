extends Area3D

@export var _door: SourceEntityDoor

func _source_interacted(ray: SourceInteractRay) -> void:
	_door._source_interacted(ray)
