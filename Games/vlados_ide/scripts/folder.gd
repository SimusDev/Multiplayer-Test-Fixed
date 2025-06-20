class_name IdeFolder extends Button

@onready var container = $container

@onready var folder_icon:Texture=preload("res://Games/vlados_ide/icons/folder.png")
@onready var folder_empty_icon:Texture=preload("res://Games/vlados_ide/icons/folder_empty.png")

var path:String = "C:/dev/gds/test_folder"
var is_open:bool = false

var folders_count:int = 0

func _ready() -> void:
	update()
	pressed.connect(on_pressed)

func on_pressed() -> void:
	is_open = not is_open
	update()

func update():
	for child in container.get_children():
		child.queue_free()
	
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
			if is_open: 
				text = "< " + folder_name
			else:
				text = "> " + folder_name

	if is_open:
		for folder in dir_folders():
			var new_folder = preload("res://Games/vlados_ide/ui/folder.tscn").instantiate()
			new_folder.path = path+"/"+folder
			container.add_child(new_folder)

		for file in dir_files():
			var new_file = preload("res://Games/vlados_ide/ui/file.tscn").instantiate()
			new_file.path = path+"/"+file
			container.add_child(new_file)


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

func calculate_folder_count():
	folders_count = container.get_child_count()
	return folders_count

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

func add_subfile(path:String):
	var file = preload("res://Games/vlados_ide/ui/file.tscn").instantiate()
	file.path = path
	container.add_child(file)
