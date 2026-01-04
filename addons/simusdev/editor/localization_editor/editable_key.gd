class_name SD_EditorUIEditableKey extends HBoxContainer

signal value_changed(new_value: String)

@onready var key_name: Label = $key_name
@onready var btn_edit: Button = $btn_edit
@onready var line_edit: LineEdit = $line_edit

func setup(name: String, value: String) -> void:
	key_name.text = name
	line_edit.text = value.strip_edges().trim_prefix("\"").trim_suffix("\"")
	
	line_edit.text_submitted.connect(_on_text_submitted)
	line_edit.focus_exited.connect(func(): _on_text_submitted(line_edit.text))

func _on_text_submitted(new_text: String) -> void:
	value_changed.emit(new_text)
