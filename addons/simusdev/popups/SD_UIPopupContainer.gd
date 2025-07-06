extends Control
class_name SD_UIPopupContainer

var resource: SD_PopupContainerResource
var reference: SD_UIPopupReference

var popups_holder: SD_UIPopupsHolder

static func create(resource: SD_PopupContainerResource, reference: SD_UIPopupReference) -> SD_UIPopupContainer:
	var _container := SD_UIPopupContainer.new()
	
	var popups_holder: SD_UIPopupsHolder =  SD_UIPopupsHolder.new()
	
	popups_holder.anchor_bottom = 1
	popups_holder.anchor_left = 1
	popups_holder.anchor_right = 1
	popups_holder.anchor_top = 1
	popups_holder.set_anchors_preset(Control.PRESET_FULL_RECT)
	popups_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_container.popups_holder = popups_holder
	_container.add_child(popups_holder)
	
	
	_container.resource = resource
	_container.reference = reference
	
	_container.anchor_bottom = 1
	_container.anchor_left = 1
	_container.anchor_right = 1
	_container.anchor_top = 1
	
	_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	_container.instantiate_content(resource.content_behind, true)
	_container.instantiate_content(resource.content_front, false)
	

	return _container

func instantiate_content(content: Array[PackedScene], behind: bool) -> Array[Node]:
	var result: Array[Node] = []
	for scene in content:
		if scene:
			var content_instance: Node = scene.instantiate()
			content_instance.set_meta("SD_UIPopupReference", reference)
			add_child(content_instance)
			result.append(content_instance)
			
			if behind:
				move_child(content_instance, 0)
	
	return result
