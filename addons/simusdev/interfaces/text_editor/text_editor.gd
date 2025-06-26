extends Control

@export var _editor: TextEdit
@export var _file_dialog: FileDialog
@export var _label_current_file: Label

var file_mode: FileDialog.FileMode = FileDialog.FileMode.FILE_MODE_OPEN_FILE
var access: FileDialog.Access = FileDialog.Access.ACCESS_FILESYSTEM

var _loaded_file: String = ""

func open_file_dialog() -> void:
	_file_dialog.file_mode = file_mode
	_file_dialog.access = access
	
	var ok_button_text: String = "OK"
	if file_mode == FileDialog.FILE_MODE_OPEN_FILE:
		ok_button_text = "Open"
	elif file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		ok_button_text = "Save"
	
	_file_dialog.ok_button_text = ok_button_text
	
	_file_dialog.show()

func _on_file_dialog_dir_selected(dir: String) -> void:
	pass # Replace with function body.

func _on_file_dialog_file_selected(path: String) -> void:
	if file_mode == FileDialog.FILE_MODE_OPEN_FILE:
		load_file(path)
	elif file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		save_file(path)
	

func _on_file_dialog_filename_filter_changed(filter: String) -> void:
	pass # Replace with function body.

func _on_file_dialog_files_selected(paths: PackedStringArray) -> void:
	pass # Replace with function body.

func load_file(path: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_editor.text = file.get_as_text()
	file.close()
	set_loaded_file(path)

func save_file(path: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(_editor.text)
	file.close()
	set_loaded_file(path)

func set_loaded_file(path: String) -> void:
	_loaded_file = path
	_label_current_file.text = path

func get_loaded_file() -> String:
	return _loaded_file

#///////BUTTONS///////

func _on_open_file_pressed() -> void:
	access = FileDialog.Access.ACCESS_FILESYSTEM
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_file_dialog()

func _on_open_user_pressed() -> void:
	access = FileDialog.Access.ACCESS_USERDATA
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_file_dialog()

func _on_save_pressed() -> void:
	save_file(_loaded_file)

func _on_save_as_pressed() -> void:
	access = FileDialog.Access.ACCESS_FILESYSTEM
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	open_file_dialog()

func _on_save_as_user_pressed() -> void:
	access = FileDialog.Access.ACCESS_USERDATA
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	open_file_dialog()


func _on_close_pressed() -> void:
	get_parent().queue_free()
