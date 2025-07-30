extends Control

@onready var info_container:VBoxContainer = $refrect/info

@onready var name_label: Label = $name_label
@onready var icon: TextureRect = $icon

func remove_info(text:String):
	for child in info_container.get_children():
		if child is Label:
			if child.text == text:
				child.queue_free()

func add_info(text:String):
	var new_label:Label = Label.new()
	new_label.text = text
	
	info_container.add_child(new_label)

func set_object(object: R_SourceWorldObject) -> void:
	if object:
		name_label.text = object.name
		icon.texture = object.icon
