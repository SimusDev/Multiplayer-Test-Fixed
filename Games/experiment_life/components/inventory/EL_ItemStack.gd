extends Resource
class_name EL_ItemStack

@export var icon: Texture
@export var name: String



@export_group("Private Fields")
@export var p_source_node_path: String
@export var p_inventory_node_path: String

var _source: Node
var _inventory: EL_Inventory

func get_source() -> Node:
	return _source

func get_inventory() -> EL_Inventory:
	return _inventory

func _init() -> void:
	_source = SimusDev.get_node_or_null(p_source_node_path)
	_inventory = SimusDev.get_node_or_null(p_inventory_node_path)
