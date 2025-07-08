extends Node
class_name GameWorld

static var _instance: GameWorld

func _enter_tree() -> void:
	_instance = self

func _exit_tree() -> void:
	_instance = null

func _ready() -> void:
	SD_Multiplayer.get_singleton().server_disconnected.connect(_on_server_disconnected)

func _on_server_disconnected() -> void:
	slike_scenechanger.change_to_menu()

static func get_instance() -> GameWorld:
	return _instance

func _on_mm_cmd_on_executed(command: SD_ConsoleCommand) -> void:
	%main_menu.change_visibile_status()
