extends Control

@onready var info_container:VBoxContainer = $refrect/info

func remove_info(text:String):
	for child in info_container.get_children():
		if child is Label:
			if child.text == text:
				child.queue_free()

func add_info(text:String):
	var new_label:Label = Label.new()
	new_label.text = text
	
	info_container.add_child(new_label)
