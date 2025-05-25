@tool
extends SD_UIButton

@export var label_text: String = "" : set = set_label_text

@export_group("Localization")
@export var localization_enabled: bool = false : set = set_localization_enabled
@export var localization_key: String = "" : set = set_localization_key
@export_multiline var localization_placeholder: String = "" : set = set_localization_placeholder

@export_group("Modulate")
@export var MODULATE_SPEED: float = 10.0
@export var MODULATE_NORMAL := Color(1, 1, 1, 1)
@export var MODULATE_POINTED := Color(0.8, 0.8, 0.8, 1.0)
@export var MODULATE_PRESSED := Color(0.5, 0.5, 0.5, 1.0)

@export_group("references")
@export var _label: SD_Label

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var actual_speed: float = MODULATE_SPEED * delta
	var current_modulate: Color = MODULATE_NORMAL
	
	if is_mouse_pointed():
		current_modulate = MODULATE_POINTED
	
	if button_pressed:
		current_modulate = MODULATE_PRESSED
	
	modulate = lerp(modulate, current_modulate, actual_speed)

func set_label_text(value: String) -> void:
	label_text = value
	if _label: _label.text = value

func set_localization_enabled(value: bool) -> void:
	localization_enabled = value
	if _label: _label.localization_enabled = value

func set_localization_key(value: String) -> void:
	localization_key = value
	if _label: _label.localization_key = value

func set_localization_placeholder(value: String) -> void:
	localization_placeholder = value
	if _label: _label.localization_placeholder = value
