class_name IdeFolder extends Button

@onready var container = $container

var folder_icon:Texture=preload("res://Games/vlados_ide/icons/folder.png")
var folder_empty_icon:Texture=preload("res://Games/vlados_ide/icons/folder_empty.png")

var path:String = "C:/dev/gds/test_folder"

var is_open:bool = false

func _ready() -> void:
	update()
	pressed.connect(on_pressed)

func on_pressed() -> void:
	is_open = not is_open
	print(is_open)
	update()

func update():
	var dir = DirAccess.open(path)
	var splitted = path.split("/")
	var folder_name = splitted[splitted.size()-1]
	container.visible = is_open
	if dir:
		var folder_size = dir.get_files().size() + dir.get_directories().size()
		if folder_size == 0:
			icon = folder_empty_icon
		else:
			icon = folder_icon
			if is_open: text = "< " + folder_name
			else:
				text = "> " + folder_name

func dir_files():
	var dir = DirAccess.open(path)
	var files:Array = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				files.append(file_name)
			file_name = dir.get_next()
	return files

func dir_folders():
	var dir = DirAccess.open(path)
	var folders:Array = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				folders.append(file_name)
			else:
				pass
			file_name = dir.get_next()
	return folders

func add_subdir(path:String):
	var folder = preload("res://Games/vlados_ide/ui/folder.tscn").instantiate()
	folder.path = path
	container.add_child(folder)
	update()
func add_subfile(path:String):
	var file = preload("res://Games/vlados_ide/ui/file.tscn").instantiate()
	file.path = path
	container.add_child(file)
	update()
