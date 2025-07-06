@tool
extends Node
class_name SD_UIDynamicControlSizeSource

var _cmd: SD_ConsoleCommand

@export var sources: Array[Control] = []

@export_range(0.0, 1.0, 0.0001) var pivot_x_range: float = 0.0 : set = set_pivot_x_range
@export_range(0.0, 1.0, 0.0001) var pivot_y_range: float = 0.0 : set = set_pivot_y_range

func set_pivot_x_range(val: float) -> void:
	pivot_x_range = val
	
	for source in sources:
		if source:
			source.pivot_offset.x = source.size.x * pivot_x_range

func set_pivot_y_range(val: float) -> void:
	pivot_y_range = val
	
	for source in sources:
		if source:
			source.pivot_offset.y = source.size.y * pivot_y_range

func _ready() -> void:
	if sources.is_empty():
		if get_parent() is Control:
			sources.append(get_parent())
	
	if not Engine.is_editor_hint():
		_cmd = SimusDev.ui.command_dynamic_size
		_cmd.number_set_min_max_value(0.5, 1.0)
		_cmd.updated.connect(_on_cmd_updated)
		_on_cmd_updated()
	
	
	update_pivot()

func update_pivot() -> void:
	set_pivot_x_range(pivot_x_range)
	set_pivot_y_range(pivot_y_range)

func _process(delta: float) -> void:
	update_pivot()

func _on_cmd_updated() -> void:
	for source in sources:
		source.scale.x = _cmd.get_value_as_float()
		source.scale.y = _cmd.get_value_as_float()
