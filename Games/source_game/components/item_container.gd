class_name SourceItemContainer extends Node3D

@export var model_item_container:Node3D

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

func hide_all_items(exception:Node):
	for child in get_children():
		if child is SourceItem and child != exception:
			child.set_current(false)

func hide_all_model_items(exception:Node):
	for child in model_item_container.get_children():
		if child != exception:
			child.queue_free()


func pick_item(at_position:int):
	var item = get_child(at_position)
	if not is_instance_valid(get_child(at_position)):
		return
	
	if item is SourceItem:
		if is_multiplayer_authority():
			hide_all_items(item)
			item.set_current( not item.is_current())
		
		
		#hide_all_model_items(item)
		#
		#var new_item_model = item.model.duplicate()
		#new_item_model.name = new_item_model.name.validate_node_name()
		#model_item_container.add_child(new_item_model)
