@tool
extends Label
class_name SD_Label

var _LOCALIZATION_UPDATE_SCRIPT_TEMPLATE: String = "extends RefCounted\n\nfunc _localization_updated(label):\n	pass"

@export_group("Settings")
@export var custom_settings_enabled: bool = true : set = set_custom_settings_enabled
@export var font: Font : set = set_font
@export var font_size: int = 16 : set = set_font_size
@export var font_size_minumum: int = 1 : set = set_font_size_minimum
@export var font_color: Color = Color(1, 1, 1, 1) : set = set_font_color
@export var line_spacing: float = 3.0 : set = set_line_spacing
@export var paragraph_spacing: float = 0.0 : set = set_paragraph_spacing
@export var outline_size: int = 0 : set = set_outline_size
@export var outline_color: Color = Color(1, 1, 1, 1) : set = set_outline_color
@export var shadow_size: int = 1 : set = set_shadow_size
@export var shadow_color: Color = Color(0, 0, 0, 0) : set = set_shadow_color
@export var shadow_offset: Vector2 = Vector2(1, 1) : set = set_shadow_offset

@export_group("AutoSize")
@export var autosize_font_base_size: int = 16 : set = set_autosize_font_base_size
@export var autosize_snap := Vector2(0, 0)
@export var autosize_rect: bool = false : set = set_autosize_rect
@export var autosize_rect_scale: float = 1.0 : set = set_autosize_rect_scale
@export var autosize_characters: bool = false : set = set_autosize_characters
@export var autosize_characters_scale: float  = 1.0 : set = set_autosize_characters_scale

@export_group("Localization")
@export var localization_enabled: bool = false : set = set_localization_enabled, get = get_localization_enabled
@export var localization_key: String = "" : set = set_localization_key, get = get_localization_key
@export_multiline var localization_placeholder: String = "" : set = set_localization_placeholder, get = get_localization_placeholder
#@export_multiline var localization_script_code: String = _LOCALIZATION_UPDATE_SCRIPT_TEMPLATE : set = set_localization_script_code
#@export var localization_script: GDScript

var _localization_script_node: RefCounted = RefCounted.new()
var _last_text: String = ""

signal text_changed()
signal localization_updated()

func _update_text_change() -> void:
	if text != _last_text:
		text_changed.emit()
		update_autosize()
		_last_text = text

func update_autosize() -> void:
	if autosize_rect or autosize_characters:
		var actual_size: int = autosize_font_base_size
		var _prepared_rect_size: Vector2 = (get_rect().size * 0.05)
		var _prepared_font_size_rect: int = (_prepared_rect_size.x + _prepared_rect_size.y) * autosize_rect_scale
		actual_size += _prepared_font_size_rect
		
		var _prepared_char_size: float = ((text.length()) * 0.5) * autosize_characters_scale
		if _prepared_char_size < 0 or autosize_characters == false:
			_prepared_char_size = 0
		actual_size -= round(_prepared_char_size)
		
		set_font_size(actual_size)

func _try_to_update_custom_label_settings() -> void:
	if not custom_settings_enabled:
		return
		
	_try_to_create_custom_label_settings()
	label_settings.font = font
	label_settings.font_size = font_size
	label_settings.font_color = font_color
	label_settings.paragraph_spacing = paragraph_spacing
	label_settings.line_spacing = line_spacing
	label_settings.outline_color = outline_color
	label_settings.outline_size = outline_size
	label_settings.shadow_size = shadow_size
	label_settings.shadow_color = shadow_color
	label_settings.shadow_offset = shadow_offset


func update_localization_script() -> void:
	return


func set_autosize_font_base_size(value: int) -> void:
	autosize_font_base_size = value
	update_autosize()

func set_autosize_characters(value: bool) -> void:
	autosize_characters = value
	update_autosize()

func set_autosize_characters_scale(value: float) -> void:
	autosize_characters_scale = value
	update_autosize()

func set_autosize_rect(value: bool) -> void:
	autosize_rect = value
	update_autosize()

func set_autosize_rect_scale(value: float) -> void:
	autosize_rect_scale = value
	update_autosize()
	

func set_shadow_size(value: int) -> void:
	shadow_size = value
	_try_to_update_custom_label_settings()

func set_shadow_color(value: Color) -> void:
	shadow_color = value
	_try_to_update_custom_label_settings()

func set_shadow_offset(value: Vector2) -> void:
	shadow_offset = value
	_try_to_update_custom_label_settings()

func set_outline_size(value: int) -> void:
	outline_size = value
	_try_to_update_custom_label_settings()

func set_outline_color(value: Color) -> void:
	outline_color = value
	_try_to_update_custom_label_settings()

func set_line_spacing(value: float) -> void:
	line_spacing = value
	_try_to_update_custom_label_settings()

func set_paragraph_spacing(value: float) -> void:
	paragraph_spacing = value
	_try_to_update_custom_label_settings()

func set_custom_settings_enabled(enabled: bool) -> void:
	custom_settings_enabled = enabled
	
	_try_to_update_custom_label_settings()
	
	if is_inside_tree():
		if enabled:
			if label_settings:
				label_settings = label_settings.duplicate()
		

func _try_to_create_custom_label_settings() -> void:
	if not custom_settings_enabled:
		return
	
	if not label_settings:
		label_settings = LabelSettings.new()
	

func set_font_color(value: Color) -> void:
	font_color = value
	_try_to_update_custom_label_settings()

func set_font(value: Font) -> void:
	font = value
	_try_to_update_custom_label_settings()
	

func set_font_size(value: int) -> void:
	font_size = value
	if font_size < font_size_minumum:
		font_size = font_size_minumum
	_try_to_update_custom_label_settings()

func set_font_size_minimum(value: int) -> void:
	font_size_minumum = value
	if font_size_minumum > font_size:
		set_font_size(font_size_minumum)

func _on_resized() -> void:
	update_autosize()

func _ready() -> void:
	_update_text_change()
	clip_text = true
	resized.connect(_on_resized)
	_try_to_create_custom_label_settings()
	
	if custom_settings_enabled:
		label_settings = label_settings.duplicate()
	
	if Engine.is_editor_hint():
		return
	
	get_localization().updated.connect(_on_localization_updated)
	
	update_localization()

func _process(delta: float) -> void:
	_update_text_change()

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
		_update_text_change()
	
	
	update_localization_script()
	_on_localization_update()
	localization_updated.emit()

func _on_localization_update() -> void:
	pass
