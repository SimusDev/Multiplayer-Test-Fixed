@tool
extends SD_RichTextLabel
class_name SD_RichTextLabelSimple

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint():
		if scroll_active:
			scroll_active = false
			shortcut_keys_enabled = false
			mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			
