class_name Ide extends Node

static var instance
signal on_file_open(file)

@onready var messages = $canvas/ui/messages_bg/ScrollContainer/messages
@onready var file_system = $canvas/ui/panel/ScrollContainer/file_system
@onready var text_edit = $canvas/ui/code_text
@onready var recent_files = $canvas/ui/files/HBoxContainer
@onready var current_file_label = $canvas/ui/current_file_name

enum TYPES {
	BOOLEAN = 0,
	INTEGER = 1,
	FLOAT = 2,
	ARRAY = 3
}


var base_folder_path:String = "C:/dev/gds"
var current_file_path:String = "C:/dev/gds/test.txt"

func _ready() -> void:
	instance = self
	
	on_file_open.connect(open_current_file)
	
	text_edit.text = read_file_text(current_file_path)
	update_panel()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("save_file"):
		write_file_text(current_file_path, text_edit.text)

func update_panel():
	var root_folder = preload("res://Games/vlados_ide/ui/folder.tscn").instantiate()
	root_folder.path = base_folder_path
	file_system.add_child(root_folder)

func open_current_file(path:String):
	current_file_path = path
	var text = read_file_text(path)
	text_edit.text = text
	
	var splitted = path.split("/")
	var file_name = splitted[splitted.size()-1]
	current_file_label.text = file_name
	add_to_recent_files(path)
	

func add_to_recent_files(path):
	var new_file_tab = preload("res://Games/vlados_ide/ui/file_tab.tscn").instantiate()
	new_file_tab.path = path
	for x in recent_files.get_children():
		if x.path == new_file_tab.path:
			return
	recent_files.add_child(new_file_tab)
	
	var splitted = path.split("/")
	var file_name = splitted[splitted.size()-1]
	new_file_tab.update(file_name)

func dir_contents(path:String):
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
	print(path)
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
	
	#file.close()
