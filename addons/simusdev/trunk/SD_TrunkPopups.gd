extends SD_Trunk
class_name SD_TrunkPopups

var _canvas: CanvasLayer

var settings: Dictionary

var base_path: String

var _active: Array[SD_UIPopupReference] = []

var _default_animation: SD_PopupAnimationResource
var _container_resource: SD_PopupContainerResource

var _s_class: SD_Popups

func get_active() -> Array[SD_UIPopupReference]:
	return _active

func get_canvas() -> CanvasLayer:
	return _canvas

func _ready() -> void:
	var sd_settings: SD_EngineSettings = SimusDev.get_settings()
	settings = sd_settings.popups
	
	if not settings.enabled:
		return
	
	_default_animation = load("res://addons/simusdev/popups/default_animation.tres")
	_container_resource = sd_settings.popups_container
	
	if not _container_resource:
		_container_resource = load("res://addons/simusdev/popups/default_container.tres")
	
	base_path = settings.base_path
	
	_canvas = CanvasLayer.new()
	_canvas.layer = settings.canvas_layer
	SimusDev.add_child(_canvas)
	_canvas.name = "Popups"
	
	_s_class = SD_Popups.new(self)

func get_default_animation_resource() -> SD_PopupAnimationResource:
	return _default_animation

func get_container_resource() -> SD_PopupContainerResource:
	return _container_resource

func create(scene: PackedScene, canvas: Node = _canvas) -> SD_UIPopupReference:
	if not scene:
		SimusDev.console.write_from_object(self, "cant create, the packed scene is null! ", SD_ConsoleCategories.CATEGORY.ERROR)
		return null
	
	var p_instance: Node = scene.instantiate()
	
	if not p_instance is Control:
		p_instance.queue_free()
		SimusDev.console.write_from_object(self, "cant create, the root node is not Control! %s" % scene.resource_path, SD_ConsoleCategories.CATEGORY.ERROR)
		return null
	
	var reference: SD_UIPopupReference = SD_UIPopupReference.create(canvas, p_instance, null)
	return reference

func create_with_base_path(path: String, canvas: Node = _canvas) -> SD_UIPopupReference:
	return create(load(base_path % path), canvas)
	
