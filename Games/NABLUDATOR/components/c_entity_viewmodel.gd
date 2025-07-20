extends Node
class_name C_NabludatorEntityViewModel

@export var root: Node3D
@export var initial_items: Array[R_NabludatorItem] = []
var items: Array[R_NabludatorItem] = []
@export var attachment: Node3D

var selected: int = -1

var item_instance: Node

var actions: C_NabludatorItemActions

func _ready() -> void:
	if !root:
		root = get_parent()
	
	SD_Network.register_functions([
		_select_
	])
	
	SD_Network.register_variables(self, [
		"selected",
	])
	
	if !attachment.is_node_ready():
		await attachment.ready
	
	
	
	for i in initial_items:
		var duplicated: R_NabludatorItem = i.duplicate()
		
		var data: C_NabludatorItemData = C_NabludatorItemData.new()
		data.name = i.code.validate_node_name()
		add_child(data)
		
		duplicated.data = data
		items.append(duplicated)
	
	
	if items.is_empty():
		return
	
	var select_id: int = selected
	if select_id < 0:
		select_id = 0
	
	if SD_Network.is_server():
		select(select_id)
	else:
		SD_Network.var_sync_from_server(self, [
			"selected",
			]
			).synced.connect(_on_synced_var)

func _on_synced_var(property: String, value: Variant) -> void:
	match property:
		"selected":
			SimusDev.console.write_info("synced item: %s" % [str(value)])
			select(value)

func get_selected_item() -> R_NabludatorItem:
	return SD_Array.get_value_from_array(items, selected)

func select(id: int) -> void:
	SD_Network.call_func(_select_, [id])

func _select_(id: int) -> void:
	selected = id
	update()

func update() -> void:
	for i in attachment.get_children():
		i.queue_free.call_deferred()
		await i.tree_exited
	
	var item: R_NabludatorItem = get_selected_item()
	_update_actions(item)
	
	if item:
		var view: R_NabludatorViewModel = item.viewmodel
		if !view:
			return
		
		var prefab: PackedScene = view.prefab
		if !prefab:
			return
		
		var container: Node3D = Node3D.new()
		container.name = "container"
		
		item_instance = prefab.instantiate()
		item_instance.name = item.code.validate_node_name()
		item_instance.set_meta("C_NabludatorItemActions", actions)
		
		container.add_child(item_instance)
		
		if view.settings:
			item_instance.position = view.settings.position
			item_instance.scale = view.settings.scale
			item_instance.rotation = view.settings.rotation
		
		attachment.add_child(container)

func _update_actions(item: R_NabludatorItem) -> void:
	if !item:
		return
	
	if is_instance_valid(actions):
		actions.name = "0"
		actions.queue_free()
	
	if item.actions:
		
		var p: PackedScene = item.actions.get_prefab()
		if p:
			actions = p.instantiate()
		else:
			actions = C_NabludatorItemActions.new()
		
		actions.entity_viewmodel = self
		actions.item = item
		actions.name = "actions"
		add_child(actions)
