class_name SourceItemContainer extends Node3D

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_1: pick_item(0)
			KEY_2: pick_item(1)
			KEY_3: pick_item(2)
			KEY_4: pick_item(3)
			KEY_5: pick_item(4)
			KEY_6: pick_item(5)
			KEY_7: pick_item(6)
			KEY_8: pick_item(7)
			KEY_9: pick_item(8)
			KEY_0: pick_item(9)

func hide_all_items():
	for child in get_children():
		if child is SourceItem:
			child.set_current(false)

func pick_item(at_position:int):
	var item = get_child(at_position)
	if not is_instance_valid(get_child(at_position)):
		return
	
	if item is SourceItem:
		if item.is_current():
			item.set_current(false)
			return
		
		hide_all_items()
		item.set_current(true)
		
