class_name MessageManager extends VBoxContainer

@export var clear_button:Button

func _ready() -> void:
	clear_button.pressed.connect(clear)
	
	for i in range(0, 10):
		await get_tree().create_timer(.01).timeout
		send_message("test"+str(i), LabelSettings.new())
	pass

func clear():
	for child in get_children():
		child.queue_free()

func send_message(text:String, label_settings:LabelSettings = LabelSettings.new(), lifetime:float = 1.0):
	var new_label:Label = Label.new()
	add_child(new_label)
	
	new_label.text = text
	new_label.label_settings = label_settings
	
	await get_tree().create_timer(lifetime).timeout
	if new_label:
		new_label.queue_free()
