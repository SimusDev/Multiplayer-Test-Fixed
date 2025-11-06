extends Control

@export var tree: Tree

var _sections: Dictionary[String, Texture2D] = {}
var _objects: Dictionary[String, Array] = {}

@export var section_icon_max_width: int = 24
@export var object_preview: PackedScene
@export var container: Control
@export var inventory_checkbox: CheckBox
@export var quantity_line_edit: LineEdit

func is_inventory_checkbox() -> bool:
	return inventory_checkbox.button_pressed

func get_quantity_line_edit() -> int:
	var quantity: int = int(quantity_line_edit.text)
	if quantity < 1:
		quantity = 1
	return quantity

func _ready() -> void:
	clear_objects()
	
	var root: TreeItem = tree.create_item()
	root.set_text(0, "root")
	
	for ref in R_SourceWorldObject.get_reference_list():
		if !ref.is_visible():
			continue
		
		if !_sections.has(ref.get_section()):
			_sections[ref.get_section()] = ref.get_section_icon()
		
		if !_objects.has(ref.get_section()):
			_objects[ref.get_section()] = [] as Array[R_SourceWorldObject]
		
		var items: Array[R_SourceWorldObject] = _objects[ref.get_section()]
		items.append(ref)
	
	for section in _sections:
		var item: TreeItem = tree.create_item(root)
		item.set_text(0, section)
		item.set_icon(0, _sections[section])
		item.set_icon_max_width(0, section_icon_max_width)

func clear_objects() -> void:
	for i in container.get_children():
		i.queue_free()

func _on_tree_item_selected() -> void:
	clear_objects()
	var items: Array[R_SourceWorldObject] = _objects.get(tree.get_selected().get_text(0), [] as Array[R_SourceWorldObject])
	
	for item in items:
		var ui: Control = object_preview.instantiate()
		ui.resource = item
		ui.spawner = self
		container.add_child(ui)
	
