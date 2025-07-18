extends Node
class_name C_NabludatorEntityViewModel

@export var items: Array[R_NabludatorItem] = []
@export var attachment: BoneAttachment3D

@export var selected: int = -1

var item_instance: Node

func _ready() -> void:
	SD_Network.register_function(_select_)
	
	if !attachment.is_node_ready():
		await attachment.ready
	
	
	if items.is_empty():
		return
	
	if SD_Network.is_server():
		select(0) 
	else:
		SD_Multiplayer.request_and_sync_var_from_server(self, "selected", _selected_synced)

func _selected_synced() -> void:
	update()

func get_selected_item() -> R_NabludatorItem:
	return SD_Array.get_value_from_array(items, selected)

func select(id: int) -> void:
	SD_Network.call_func(_select_, [id])

func _select_(id: int) -> void:
	selected = id
	update()

func update() -> void:
	for i in attachment.get_children():
		i.queue_free()
	
	item_instance = null
	
	await get_tree().process_frame
	
	var item: R_NabludatorItem = get_selected_item()
	if item:
		var view: R_NabludatorViewModel = item.viewmodel
		if !view:
			return
		
		var prefab: PackedScene = view.prefab 
		if !prefab:
			return
		
		item_instance = prefab.instantiate()
		item_instance.name = item.code.validate_node_name()
		
		if view.settings:
			item_instance.position = view.settings.position
			item_instance.scale = view.settings.scale
			item_instance.rotation = view.settings.rotation
		
		attachment.add_child(item_instance)
		
