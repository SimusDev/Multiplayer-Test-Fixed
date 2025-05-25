@icon("res://addons/simusdev/Game/icons/ui_icon_shop.png")
extends Node
class_name SD_GlobalShop

@onready var console := SimusDev.console

var _fullcode: String
var _nodes: Array[SD_ShopNode] = []

signal initialized()

var EVENT_PURCHASED := SD_ShopEventPurchased.new(self)
var EVENT_FAILED_TO_PURCHASE := SD_ShopEventFailedToPurchase.new(self)

var _ACTIVE_EVENT_LIST: Array[SD_ShopEvent] = [
	EVENT_PURCHASED,
	EVENT_FAILED_TO_PURCHASE,
]

signal on_event(event: SD_ShopEvent)

signal item_purchased(item: SD_ShopNodeItem, event: SD_ShopEventPurchased)
signal item_failed_purchase(item: SD_ShopNodeItem, event: SD_ShopEventFailedToPurchase)

func _ready() -> void:
	for e in _ACTIVE_EVENT_LIST:
		e.published.connect(_on_shop_event.bind(e))
	
	_initialize_full_code()
	
	initialized.emit()
	console.write_from_object(self, "shop initialized!", SD_ConsoleCategories.CATEGORY.SUCCESS)

func _on_shop_event(e: SD_ShopEvent) -> void:
	on_event.emit(e)

func _initialize_full_code() -> void:
	_fullcode = get_path()
	
	var splitted := _fullcode.split("/root/", false)
	_fullcode = "shop." + splitted[0]
	
	_fullcode = _fullcode.replacen("/", ".")

func add_shop_node(node: SD_ShopNode) -> void:
	if _nodes.has(node):
		return
	
	_nodes.append(node)

func remove_shop_node(node: SD_ShopNode) -> void:
	if not _nodes.has(node):
		return
	
	_nodes.erase(node)

func get_shop_nodes() -> Array[SD_ShopNode]:
	return _nodes

func get_shop_node_by_name(_name: String) -> SD_ShopNode:
	for node in _nodes:
		if node.name == _name:
			return node
	return null

func get_shop_node_by_data(data: SD_ShopItemData) -> SD_ShopNode:
	for node in _nodes:
		if node.data == data:
			return node
	return null

func get_full_code() -> String:
	return _fullcode

func get_full_code_from_node(node: SD_ShopNode) -> String:
	var node_code: String = node.get_path()
	
	var splitted := node_code.split(get_path(), false)
	node_code = splitted[0]
	
	var actual_code: String = get_full_code().path_join(node_code)
	actual_code = actual_code.replacen("/", ".")
	return actual_code

func write_data_as_command(key: String, data: Variant, custom_code := "") -> SD_ConsoleCommand:
	var code_path: String = custom_code + "." + key
	if code_path.is_empty():
		code_path = get_full_code() + "." + key
	
	var cmd := console.create_command(code_path, data)
	cmd.set_value(data)
	return cmd

func read_data_as_command(key: String, default_value := "", custom_code := "") -> SD_ConsoleCommand:
	var code_path: String = custom_code + "." + key
	if code_path.is_empty():
		code_path = get_full_code() + "." + key
	
	var cmd := console.get_command_by_code(code_path)
	return cmd 

func get_data_as_command(key: String, custom_code := "") -> SD_ConsoleCommand:
	var code_path: String = custom_code + "." + key
	if code_path.is_empty():
		code_path = get_full_code() + "." + key
	return console.get_command_by_code(code_path)

func get_or_write_data_as_command(key: String, data: Variant, custom_code := "") -> SD_ConsoleCommand:
	var code_path: String = custom_code + "." + key
	if code_path.is_empty():
		code_path = get_full_code() + "." + key
	
	var cmd := console.create_command(code_path, data)
	return cmd
