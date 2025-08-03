extends Control

@export var props_folder_path:String
@export var content_node:Control 
@export var tab_conteiner_node:Control 

var control_sections:Array[Control] = []
var resources:Array[R_SourceWorldObject] = []

func _ready() -> void:
	_readcreate_sections()

func _readcreate_sections():
	resources = R_SourceWorldObject.get_reference_list()
	
	var sections:Array[String] = []
	
	for resource in resources:
		if resource.get_section().is_empty() or resource.get_section() in sections:
			continue
		
		sections.append(resource.get_section())

	for section in sections:
		_create_section(section)
		_create_section_button(section)

func _create_section(section_name:String):
	var new_section:Control = Control.new()
	content_node.add_child(new_section)
	new_section.name = section_name
	control_sections.append(new_section)
	_create_section_grid(new_section)

#💕🤣

func _create_section_button(section_name:String):
	var new_section_button:SourceButton = load("res://sourcelike_interface/buttons/button_panel.tscn").instantiate()
	tab_conteiner_node.add_child(new_section_button)
	new_section_button.label_text = section_name
	new_section_button.custom_minimum_size.x = 14.167 * new_section_button.label_text.split().size()
	new_section_button.pressed.connect(section_button_pressed.bind(section_name))

func _create_section_grid(section:Control):
	var new_section_grid:UI_SourcePropList = UI_SourcePropList.new()
	section.add_child(new_section_grid)
	new_section_grid.prop_ui_prefab = load("res://Games/source_game/ui/prop_spawner/prop_preview.tscn")

	for resource:R_SourceWorldObject in resources:
		if resource.get_section() == section.name:
			var prop_ui_prefab = new_section_grid.prop_ui_prefab.instantiate()
			prop_ui_prefab.prop_res = resource
			new_section_grid.add_child(prop_ui_prefab)

func section_button_pressed(section:String):
	hide_all_sections()
	show_section_by_name(section)

func hide_all_sections():
	for section in control_sections:
		section.hide()
func show_section_by_name(section_name:String):
	for child in content_node.get_children():
		if child.name == section_name:
			child.show()
