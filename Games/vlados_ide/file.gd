class_name IdeFile extends Button

var file_icon:Texture=preload("res://Games/vlados_ide/icons/file.png")
var path:String

func _ready() -> void:
	pressed.connect(open_file)
	update()

func update():
	var splitted = path.split("/")
	var file_name = splitted[splitted.size()-1]
	text = file_name

func open_file():
	Ide.instance.on_file_open.emit(path)
