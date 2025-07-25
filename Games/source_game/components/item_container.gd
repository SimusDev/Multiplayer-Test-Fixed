class_name SourceItemContainer extends Node3D

@export var model_item_container:Node3D
@export var player_ui:CanvasLayer

@export var items_ui:PackedScene

func _ready() -> void:
	SD_Network.register_function(add_model_item)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and SimusDev.ui.get_active_interfaces().is_empty():
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

func hide_all_items(exception:Node=null):
	for child in get_children():
		if child is SourceItem and child != exception:
			child.set_current(false)

func hide_all_model_items(exception:Node=null):
	for child in model_item_container.get_children():
		if child != exception:
			child.queue_free()


func pick_item(at_position:int):
	if not is_instance_valid(get_child(at_position)):
		return
	var item = get_child(at_position)
	
	if item is SourceItem:
		if is_multiplayer_authority():
			hide_all_items(item)
			item.set_current( not item.is_current())
			SD_Multiplayer.call_func(hide_all_model_items, [item])
	
			sync_add_model_item(item.model)
	
		

func sync_add_model_item(model:Node):
	SD_Multiplayer.call_func(add_model_item, [model])
func add_model_item(model:Node):
	var new_item_model = model.duplicate()
	new_item_model.name = new_item_model.name.validate_node_name()
	model_item_container.add_child(new_item_model)
