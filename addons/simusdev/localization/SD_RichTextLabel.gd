@tool
extends RichTextLabel
class_name SD_RichTextLabel

@export_group("Localization")
@export var localization_enabled: bool = false : set = set_localization_enabled, get = get_localization_enabled
@export var localization_key: String = "" : set = set_localization_key, get = get_localization_key
@export_multiline var localization_placeholder: String = "" : set = set_localization_placeholder, get = get_localization_placeholder

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	get_localization().updated.connect(_on_localization_updated)
	
	update_localization()

func _on_localization_updated() -> void:
	update_localization()

func get_localization() -> SD_TrunkLocalization:
	return SimusDev.localization as SD_TrunkLocalization

func set_localization_enabled(enabled: bool) -> void:
	localization_enabled = enabled
	update_localization()

func set_localization_key(key: String) -> void:
	localization_key = key
	update_localization()

func set_localization_placeholder(placeholder: String) -> void:
	localization_placeholder = placeholder
	update_localization()

func get_localization_key() -> String:
	return localization_key
 
func get_localization_enabled() -> bool:
	return localization_enabled

func get_localization_placeholder() -> String:
	return localization_placeholder

func update_localization() -> void:
	if localization_enabled:
		if Engine.is_editor_hint():
			text = localization_placeholder
			return
		
		text = get_localization().get_text_from_key(localization_key)
