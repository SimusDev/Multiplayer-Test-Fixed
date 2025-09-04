extends W_FPCSourceLikeCamera
class_name SourceCamera

const PATH: String = "res://Games/source_game/components/emotions/camera.tscn"

var target: Node3D

static func create(target: Node3D = null) -> SourceCamera:
	var scene: PackedScene = load(PATH) as PackedScene
	var camera: SourceCamera = scene.instantiate() as SourceCamera
	camera.target = target
	return camera
