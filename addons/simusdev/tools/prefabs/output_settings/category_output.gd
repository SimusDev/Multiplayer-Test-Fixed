extends Control

var id: int = -1

@onready var check_button: CheckButton = $CheckButton

var _fonts_properties: PackedStringArray = [
	"theme_override_colors/font_color",
	"theme_override_colors/font_focus_color",
	"theme_override_colors/font_pressed_color",
	"theme_override_colors/font_hover_color",
	"theme_override_colors/font_hover_pressed_color",
	"theme_override_colors/font_disabled_color",
	
]

func _ready() -> void:
	check_button.text = SD_ConsoleCategories.get_category_as_string(id)
	check_button.button_pressed = SD_ConsoleCategories.is_output_enabled_for(id)
	
	for property in _fonts_properties:
		check_button.set(property, SD_ConsoleCategories.get_category_color(id))
	
func _on_check_button_toggled(toggled_on: bool) -> void:
	SD_ConsoleCategories.set_output_enabled(id, toggled_on)
