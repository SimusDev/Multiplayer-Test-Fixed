@icon("res://addons/simusdev/components/inventory/icon_slot.png")
extends Node
class_name W_InventorySlot

signal removed()

signal item_added(item: W_InventoryItem)
signal item_removed(item: W_InventoryItem)

@export var name_at_start: String

func is_multiplayer_active() -> bool:
	return multiplayer.has_multiplayer_peer()

func has_multiplayer_authority() -> bool:
	return is_multiplayer_active() and is_multiplayer_authority()

func has_multiplayer_authority_or_not_active() -> bool:
	if not is_multiplayer_active():
		return true
	return has_multiplayer_authority()

func _enter_tree() -> void:
	if (get_parent() is W_Inventory):
		if not name_at_start.is_empty():
			name = name_at_start
		
		name = name.validate_node_name()
		return
	
	print(name, "entered to not inventory node!")
	queue_free()

func _exit_tree() -> void:
	removed.emit()
	get_inventory().slot_removed.emit(self)

func _ready() -> void:
	
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)
	
	get_inventory().slot_created.emit(self)
	
	synchronize_all_items()

func _on_child_entered_tree(child: Node) -> void:
	if child is W_InventoryItem:
		item_added.emit(child)
		get_inventory().item_added.emit(child)

func _on_child_exiting_tree(child: Node) -> void:
	if child is W_InventoryItem:
		item_removed.emit(child)
		get_inventory().item_removed.emit(child)

func synchronize_all_items() -> void:
	if W_Inventory.is_multiplayer_active_and_client():
		for i in get_children():
			if i is W_InventoryItem:
				i.queue_free()
				await i.tree_exited
		_synchronize_all_items_rpc_server.rpc_id(SD_MultiplayerSingleton.HOST_ID)

@rpc("any_peer", "reliable")
func _synchronize_all_items_rpc_server() -> void:
	var data: Array = []
	
	var items: Array[W_InventoryItem] = get_items()
	if items.is_empty():
		return
	
	for server_item in items:
		var serialized: String = var_to_str(server_item)
		data.append(serialized)
	
	
	
	var serialized: Variant = SD_MPDataCompressor.serialize_data(data)
	_synchronize_all_items_rpc_client.rpc_id(multiplayer.get_remote_sender_id(), serialized)
	

@rpc("any_peer", "reliable")
func _synchronize_all_items_rpc_client(data: Variant) -> void:
	var deserialized: Variant = SD_MPDataCompressor.deserialize_data(data)
	for item_data in deserialized:
		var item: W_InventoryItem = str_to_var(item_data)
		add_child(item)
		

func remove() -> void:
	_remove_rpc.rpc()

@rpc("any_peer", "call_local", "reliable")
func _remove_rpc() -> void:
	queue_free()

func get_items() -> Array[W_InventoryItem]:
	var result: Array[W_InventoryItem] = []
	for i in get_children():
		if i is W_InventoryItem:
			result.append(i)
	return result

func get_item() -> W_InventoryItem:
	if get_child_count() == 0:
		return null
	return get_child(0) as W_InventoryItem

func get_inventory() -> W_Inventory:
	return get_parent()

func get_id() -> int:
	return get_index()

func _append_item_local(item: W_InventoryItem) -> void:
	if item:
		if not item.is_inside_tree():
			add_child(item)
		var current_slot: W_InventorySlot = item.get_slot()
		item.reparent(self)
		item.slot_changed.emit(self)
		get_inventory().item_changed_slot.emit(item, current_slot, self)
		
func append_item(item: W_InventoryItem) -> void:
	if not item:
		return
	
	if not is_multiplayer_active():
		_append_item_local(item)
		return
	
	_append_item_server_client.rpc(str(item.get_path()))

@rpc("any_peer", "call_local", "reliable")
func _append_item_server_client(item_path: String) -> void:
	var item: W_InventoryItem = get_node_or_null(item_path)
	if item:
		_append_item_local(item)
	else:
		if !multiplayer.is_server():
			_server_send_item_to_client_from_path.rpc_id(SD_MultiplayerSingleton.HOST_ID, item_path)
	

@rpc("any_peer", "reliable")
func _server_send_item_to_client_from_path(item_path: String) -> void:
	var item: W_InventoryItem = get_node_or_null(item_path)
	if item:
		var data: Variant = SD_MPDataCompressor.serialize_data(item)
		_append_item_rpc_client_recieve_item.rpc_id(data, multiplayer.get_remote_sender_id())

@rpc("any_peer", "reliable")
func _append_item_rpc_client_recieve_item(data: Variant) -> void:
	if multiplayer.is_server():
		return
	
	var item: W_InventoryItem = SD_MPDataCompressor.deserialize_data(data)
	_append_item_local(item)
	

func select() -> void:
	get_inventory().select_slot(self)
