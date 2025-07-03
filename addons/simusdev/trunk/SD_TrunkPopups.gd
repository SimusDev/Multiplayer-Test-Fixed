extends SD_Trunk
class_name SD_TrunkPopups

var _canvas: CanvasLayer

var settings: Dictionary

var base_path: String

var _active: Array[SD_UIPopupReference] = []

func get_active() -> Array[SD_UIPopupReference]:
	return _active

func _ready() -> void:
	settings = SimusDev.get_settings().popups
	base_path = settings.base_path
	
	_canvas = CanvasLayer.new()
	_canvas.layer = settings.canvas_layer
	SimusDev.add_child(_canvas)
	_canvas.name = "Popups"

func create(scene: PackedScene, animation: SD_PopupAnimationResource = null, parent: Node = _canvas) -> SD_UIPopupReference:
	if not scene:
		SimusDev.console.write_from_object(self, "cant create, the packed scene is null! ", SD_ConsoleCategories.CATEGORY.ERROR)
		return null
	
	var p_instance: Node = scene.instantiate()
	
	if not p_instance is Control:
		p_instance.queue_free()
		SimusDev.console.write_from_object(self, "cant create, the root node is not Control! %s" % scene.resource_path, SD_ConsoleCategories.CATEGORY.ERROR)
		return null
	
	if not animation:
		var default: Array[SD_PopupAnimationResource] = SimusDev.get_settings().popups_default_animations
		if not default.is_empty():
			animation = default.pick_random()
		
	
	
	var reference: SD_UIPopupReference = SD_UIPopupReference.create(parent, p_instance, animation)
	return reference
