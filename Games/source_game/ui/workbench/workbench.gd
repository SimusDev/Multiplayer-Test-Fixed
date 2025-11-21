extends Control

@export var recipe_scene:PackedScene
@export var type_scene:PackedScene
@export var types_container:Container
@export var recipe_container:Container

@onready var sd_ui_control_search: SD_UIControlSearch = $SD_UIControlSearch

var recipes:Array[R_SourceRecipe]
var current_type:StringName = &""

func _ready() -> void:
	update_list(&"general")
	update_types()

func clear(sex:Control) -> void:
	for node in sex.get_children():
		node.queue_free()


func add_type(_name:StringName, _icon:Texture) -> void:
	var new_scene = type_scene.instantiate()
	new_scene.type = _name
	new_scene.icon = _icon
	new_scene.pressed.connect(update_list)
	types_container.add_child(new_scene)

func update_types() -> void:
	clear(types_container)
	if not recipe_scene:
		return
	
	var types:Array[String]
	recipes = R_SourceRecipe.get_list()
	for recipe in recipes:
		if (recipe.get_type() in types) or recipe.get_type() == "general":
			continue
		
		types.append(recipe.get_type())
		add_type(recipe.get_type(), recipe.get_type_icon()) 

func update_list(_type:StringName="general") -> void:
	if current_type == _type:
		return
	
	current_type = _type
	clear(recipe_container)
	if _type == "general":
		for recipe in R_SourceRecipe.get_list():
			if recipe.is_visible():
				var ui: Control = recipe_scene.instantiate() as Control
				ui.recipe = recipe
				#sd_ui_control_search.bind(recipe.id, ui)
				recipe_container.add_child(ui)
	else:
		for recipe in R_SourceRecipe.get_list():
			if recipe.get_type() == _type and recipe.is_visible():
				var ui: Control = recipe_scene.instantiate() as Control
				ui.recipe = recipe
				#sd_ui_control_search.bind(recipe.id, ui)
				recipe_container.add_child(ui)
	
	#sd_ui_control_search.update()
