extends RigidBody3D

@export var ui: PackedScene

func _source_interacted(interactor: SourceInteractRay) -> void:
	if interactor.root == SourcePlayer.instance:
		SourceUIHandler.player_create_from_scene(ui)
