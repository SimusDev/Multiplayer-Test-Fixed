class_name Ide extends Node

@onready var messages = $canvas/ui/messages_bg/ScrollContainer/messages
@onready var text_edit = $canvas/ui/code_text

enum TYPES {
	BOOLEAN = 0,
	INTEGER = 1,
	FLOAT = 2,
	ARRAY = 3
}


var base_folder_path:String = "C:/dev/gds"
var current_file_path:String = "test.txt"

func _ready() -> void:
	text_edit.text = read_file_text(base_folder_path+"/"+current_file_path)
	update_panel()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("save_file"): write_file_text(base_folder_path+"/"+current_file_path, text_edit.text)

func update_panel():
	var root_folder = preload("res://Games/vlados_ide/ui/folder.tscn").instantiate()
	add_child(root_folder)

func dir_contents(path):
	var dir = DirAccess.open(path)
	var content:Array = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			content.append(file_name)
			file_name = dir.get_next()
	return content

func read_file_text(path:String):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

func write_file_text(path:String, content):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		messages.send_message("Successfully saved file " + '"'+str(file)+'"')
		file.store_string(content)
	else:
		messages.send_message("Failed to save file " + '"'+str(file)+'"')
	
	file.close()
