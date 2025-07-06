@tool
extends Control
class_name SD_UIDynamicControlSize

@export_range(0.0, 1.0, 0.0001) var pivot_x_range: float = 0.0 : set = set_pivot_x_range
@export_range(0.0, 1.0, 0.0001) var pivot_y_range: float = 0.0 : set = set_pivot_y_range

func set_pivot_x_range(val: float) -> void:
	pivot_x_range = val
	pivot_offset.x = size.x * pivot_x_range

func set_pivot_y_range(val: float) -> void:
	pivot_y_range = val
	pivot_offset.y = size.y * pivot_y_range
 

var _cmd: SD_ConsoleCommand

func _ready() -> void:
	if not Engine.is_editor_hint():
		_cmd = SimusDev.ui.command_dynamic_size
		_cmd.updated.connect(_on_cmd_updated)
		_on_cmd_updated()
	
	update_pivot_offset()
	

func _on_cmd_updated() -> void:
	scale.x = _cmd.get_value_as_float()
	scale.y = _cmd.get_value_as_float()

func _process(delta: float) -> void:
	update_pivot_offset()

func update_pivot_offset() -> void:
	set_pivot_x_range(pivot_x_range)
	set_pivot_y_range(pivot_y_range)
