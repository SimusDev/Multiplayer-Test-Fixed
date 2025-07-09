extends Control

var object: SB_WorldObject

signal pressed()

func init(object: SB_WorldObject, tool: Control) -> void:
	self.object = object
	$icon.texture = object.icon
	$SD_Label.localization_key = object.id
	
	tool.selected.connect(_on_selected)

func _on_selected(obj: SB_WorldObject) -> void:
	set_selected(obj == object)

func set_selected(status: bool) -> void:
	$ReferenceRect.visible = status

func _on_button_pressed() -> void:
	pressed.emit()
