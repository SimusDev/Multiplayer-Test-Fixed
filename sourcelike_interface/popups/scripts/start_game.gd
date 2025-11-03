extends Control

@onready var cmd_nickname: SD_ConsoleCommand = $nickname.get_command()
@onready var cmd_ip: SD_ConsoleCommand = $last_ip.get_command()
@onready var cmd_port: SD_ConsoleCommand = $last_port.get_command()

@export var start_btn:Button

func _ready() -> void:
	$%le_nickname.text = cmd_nickname.get_value_as_string()
	$%le_ip.text = cmd_ip.get_value_as_string()
	$%le_port.text = cmd_port.get_value_as_string()
	start_btn.pressed.emit()

func save_cmds() -> void:
	cmd_nickname.set_value(%le_nickname.text)
	cmd_ip.set_value(%le_ip.text)
	cmd_port.set_value(%le_port.text)
	
	SD_Multiplayer.set_username(cmd_nickname.get_value_as_string())

func _on_host_pressed() -> void:
	save_cmds()
	SD_Multiplayer.create_server(cmd_port.get_value_as_int())
	slike_main_menu.find_above(self).switcher.switch_by_name("lobby")
	#get_tree().change_scene_to_file(SourceGame.SCENE_PATH)
	
	queue_free()

func _on_dedicated_pressed() -> void:
	save_cmds()
	SD_Multiplayer.create_server(cmd_port.get_value_as_int(), true)
	slike_main_menu.find_above(self).switcher.switch_by_name("lobby")
	
	queue_free()


func _on_connect_pressed() -> void:
	save_cmds()
	slike_main_menu.find_above(self).switcher.switch_by_name("connecting")
	
	queue_free()

func _on_host_btn_pressed() -> void:
	$content/border/vBoxContainer/connect.hide()
	$content/border/vBoxContainer/host.show()
	$content/border/vBoxContainer/dedicated.show()
	
	%le_ip.hide()

func _on_connect_btn_pressed() -> void:
	$content/border/vBoxContainer/connect.show()
	$content/border/vBoxContainer/host.hide()
	$content/border/vBoxContainer/dedicated.hide()
	
	%le_ip.show()
