extends CanvasLayer
class_name SourceUIHandler

static var _ref: SourceUIHandler

func _enter_tree() -> void:
	_ref = self

static func as_node() -> SourceUIHandler:
	return _ref

static func create_from_scene(scene: PackedScene, parent: Node = _ref) -> SD_UIInterfaceMenu:
	if !is_instance_valid(parent):
		return null
	var ui: Node = scene.instantiate()
	parent.add_child(ui)
	var interface: SD_UIInterfaceMenu = SD_UIInterfaceMenu.find_in(ui)
	if !interface:
		interface = SD_UIInterfaceMenu.new()
		ui.add_child(interface)
	
	interface.closed.connect(ui.queue_free)
	return interface

static func player_create_from_scene(scene: PackedScene) -> SD_UIInterfaceMenu:
	return create_from_scene(scene, SourcePlayerUI.instance)
