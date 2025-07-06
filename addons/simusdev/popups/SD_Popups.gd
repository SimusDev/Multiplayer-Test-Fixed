@static_unload
extends SD_Object
class_name SD_Popups

static var _base: SD_TrunkPopups

func _init(trunk: SD_TrunkPopups) -> void:
	_base = trunk

static func get_active() -> Array[SD_UIPopupReference]:
	return _base.get_active()

static func get_default_animation_resource() -> SD_PopupAnimationResource:
	return _base.get_default_animation_resource()

static func get_container_resource() -> SD_PopupContainerResource:
	return _base.get_container_resource()

static func create(scene: PackedScene, canvas: Node = _base.get_canvas()) -> SD_UIPopupReference:
	return _base.create(scene, canvas)

static func create_with_base_path(path: String, canvas: Node = _base.get_canvas()) -> SD_UIPopupReference:
	return _base.create_with_base_path(path, canvas)
