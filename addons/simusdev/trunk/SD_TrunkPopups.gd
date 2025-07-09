extends SD_Trunk
class_name SD_TrunkPopups

var _canvas: CanvasLayer

var settings: Dictionary

var base_path: String

var _active: Array[SD_UIPopupReference] = []

var _default_animation: SD_PopupAnimationResource
var _container_resource: SD_PopupContainerResource

var _s_class: SD_Popups

signal on_open(popup: SD_UIPopupReference)
signal on_close(popup: SD_UIPopupReference)

var _input: SD_NodeInput

var _input_key: String

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
	
	if not str(settings.get("input", "")).is_empty():
		_input = SD_NodeInput.new()
		_input.depends_on_interface = false
		_canvas.add_child(_input)
		_input.name = "input"
		
		_input.on_input.connect(_on_input)
		
	_s_class = SD_Popups.new(self)

func _on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(settings.get("input", "ui_cancel")):
		close_last_active()

func close_last_active() -> void:
	if _active.is_empty():
		return
	
	var last: SD_UIPopupReference = _active[_active.size() - 1]
	if last:
		last.close()

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
	
