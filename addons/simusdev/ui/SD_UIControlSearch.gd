extends Node
class_name SD_UIControlSearch

@export var update_at_start: bool = true
@export var line_edit: LineEdit
@export var binds: Dictionary[String, Control] = {}

@export var submit: bool = false

signal updated(key: String)

func _ready() -> void:
	if line_edit:
		line_edit.text_changed.connect(_on_text_changed)
		line_edit.text_submitted.connect(_on_text_submitted)
		if update_at_start:
			update(line_edit.text)

func _on_text_changed(new_text: String) -> void:
	if submit:
		return
	update(new_text)

func _on_text_submitted(new_text: String) -> void:
	if submit:
		update(new_text)

func bind(key: String, control: Control) -> void:
	binds[key] = control

func bind_remove(key: String) -> void:
	binds.erase(key)

func update(from_text: String = "") -> void:
	for bind in binds:
			var control: Control = binds.get(bind, null) as Control
			if is_instance_valid(control):
				if from_text.is_empty():
					control.visible = true
				else:
					control.visible = bind.findn(from_text) > -1
		
	updated.emit(from_text)
