extends RefCounted
class_name slike_popups

const BASE_PATH: String = "res://sourcelike_interface/popups/%s.tscn"

static func open_base_path(path: String, parent: Node) -> Node:
	var scene: PackedScene = load(BASE_PATH % path)
	return open(scene, parent)

static func open(popup_scene: PackedScene, parent: Node) -> Node:
	if slike_popups_observer.get_or_create(parent).has_path(popup_scene.resource_path):
		return null
	
	var popup: Node = popup_scene.instantiate()
	slike_popups_observer.get_or_create(parent).init_path(popup_scene.resource_path, popup)
	parent.add_child(popup)
	
	return popup
