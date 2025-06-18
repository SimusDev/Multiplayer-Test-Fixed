class_name IdeFileTab extends Button

var path:String

func update(_text):
	text = _text

func _pressed() -> void:
	print()
	Ide.instance.on_file_open.emit(path)
