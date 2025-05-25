@icon("res://addons/simusdev/Game/icons/ui_icon_currency.png")
extends SD_ShopNode
class_name SD_ShopNodeCurrency

@export var _value: int = 0 
@export var symbol: String = ""

signal value_changed()

func set_value(cost: int) -> void:
	_value = cost
	value_changed.emit()
	write_data_as_command("value", cost)

func get_value() -> int:
	return _value

func get_value_string() -> String:
	return str(get_value())

func get_value_string_with_commas() -> String:
	return SD_StringStuff.format_with_commas(get_value())

func add_value(cost: int) -> void:
	set_value(get_value() + cost)

func subtract_value(cost: int) -> void:
	set_value(get_value() - cost)

func _on_initialized_() -> void:
	_value = get_or_write_data_as_command("value", _value).get_value_as_int()

func _on_command_data_updated(command: SD_ConsoleCommand, key: String) -> void:
	match key:
		"value":
			_value = command.get_value_as_int()
			value_changed.emit()
