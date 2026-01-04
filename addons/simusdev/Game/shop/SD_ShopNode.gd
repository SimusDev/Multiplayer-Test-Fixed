@icon("res://addons/simusdev/Game/icons/ui_icon_shop.png")
extends Node
class_name SD_ShopNode

@export_group("Base Data")
var initialize_at_start := true
@export var resource: Resource = null 
@export var data: SD_ShopItemData
@export var unique_code: String = ""

@export var unique_data: Dictionary[String, Variant] = {}
@export var group: String = ""

@onready var console: SD_TrunkConsole = SimusDev.console

var _shop: SD_GlobalShop
var _fullcode: String

var _command_data_list: Dictionary[SD_ConsoleCommand, String] = {}

var override_name: String = ""

signal initialized()

static func find_shop(from: Node) -> SD_GlobalShop:
	if from == SimusDev.get_tree().root:
		return null
	
	if from is SD_GlobalShop:
		return from
	return find_shop(from.get_parent())

func _ready() -> void:
	name = override_name
	
	var founded_shop := find_shop(self)
	if founded_shop:
		if founded_shop is SD_GlobalShop:
			founded_shop.initialized.connect(_on_shop_initialized.bind(founded_shop))

func try_initialize(shop: SD_GlobalShop) -> bool:
	if _shop != null:
		console.write_from_object(self, "node already initialized!", SD_ConsoleCategories.CATEGORY.ERROR)
		return false
	
	var founded_shop: SD_GlobalShop = shop
	if founded_shop == null:
		if founded_shop.debug: console.write_from_object(self, "cant find shop! place this node under shop node!", SD_ConsoleCategories.CATEGORY.ERROR)
		return false
	
	if founded_shop != null:
		if founded_shop is SD_GlobalShop:
			_shop = founded_shop
			_fullcode = _shop.get_full_code_from_node(self)
			_shop.add_shop_node(self)
			_on_initialized_()
			initialized.emit()
			if founded_shop.debug: console.write_from_object(self, "node initialized!", SD_ConsoleCategories.CATEGORY.SUCCESS)
			return true
	return false

func try_initialize_command_data(command: SD_ConsoleCommand, key: String) -> void:
	if not command:
		return
	
	if _command_data_list.has(command):
		return
	
	command.updated.connect(_on_command_data_updated.bind(command, key))
	_command_data_list[command] = key

func _on_shop_initialized(shop: SD_GlobalShop) -> void:
	if initialize_at_start:
		try_initialize(shop)

func get_shop() -> SD_GlobalShop:
	return _shop

func get_full_code() -> String:
	return _fullcode

func write_data_as_command(key: String, data: Variant) -> SD_ConsoleCommand:
	if !_shop:
		return null
	var cmd := _shop.write_data_as_command(key, data, get_full_code())
	try_initialize_command_data(cmd, key)
	return cmd

func read_data_as_command(key: String, default_value := "") -> SD_ConsoleCommand:
	if !_shop:
		return null
	
	return _shop.read_data_as_command(key, default_value, get_full_code())

func get_data_as_command(key: String) -> SD_ConsoleCommand:
	return _shop.get_data_as_command(key, get_full_code())

func get_or_write_data_as_command(key: String, data: Variant) -> SD_ConsoleCommand:
	if !_shop:
		return null
	
	var cmd := _shop.get_or_write_data_as_command(key, data, get_full_code())
	try_initialize_command_data(cmd, key)
	return cmd

func _on_initialized_() -> void:
	pass

func _on_command_data_updated(command: SD_ConsoleCommand, key: String) -> void:
	pass
