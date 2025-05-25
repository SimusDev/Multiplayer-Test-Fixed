@tool
extends TextureRect
class_name SD_UIGodotLogo

const path_to_texture: String = "res://addons/simusdev/textures/godot.png"
const initial_size: Vector2 = Vector2(500, 250)

@export_tool_button("Resize and center")
var _resize_and_center_button: Callable = resize_and_center_button.bind()

func resize_and_center_button() -> void:
	load_texture()
	load_settings()
	set_global_position(SD_WindowStuff.get_project_viewport_size() / 2)
	global_position -= size / 2
	set_anchors_preset(Control.PRESET_CENTER)

func _ready() -> void:
	if texture == null:
		load_texture()
		load_settings()

func load_texture() -> void:
	texture = load(path_to_texture)

func load_settings() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	set_size(initial_size)
