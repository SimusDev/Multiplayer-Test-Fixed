extends Control

signal current_recipe_changed()

@export var recipe_scene:PackedScene
@export var recipe_container:Container
@export var type_scene:PackedScene
@export var types_container:Container

@export var craft_btn:Button
@export var recipe_icon:TextureRect
@export var recipe_name:Label
@export var recipe_desc:Label
@export var craft_input:RichTextLabel

@onready var sd_ui_control_search: SD_UIControlSearch = $SD_UIControlSearch

var recipes:Array[R_SourceRecipe]
var current_type:StringName = &""
var current_recipe:R_SourceRecipe : set = set_current_recipe

var inventory:SourceInventory

func set_current_recipe(value:R_SourceRecipe) -> void:
	current_recipe = value
	current_recipe_changed.emit()
	
	if is_instance_valid(craft_btn):
		$list/current/content.visible = not (value == null)

func _ready() -> void:
	update_list(&"general")
	update_types()
	
	inventory = SD_Components.find_first(SourcePlayable.get_local().root, SourceInventory)
	inventory.item_added.connect(inv_changed)
	inventory.item_removed.connect(inv_changed)
	
	craft_btn.pressed.connect(craft)
	$list/current/content.visible = not (current_recipe == null)

func craft() -> void:
	if (not current_recipe) or (not inventory):
		return
	
	inventory.craft(current_recipe)

func inv_changed() -> void:
	update_craft_btn()
	update_recipe_input()

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
	
	for recipe in R_SourceRecipe.get_list():
		if recipe.is_visible():
			if recipe.get_type() == _type or recipe.get_type() == "general":
				var ui: Button = recipe_scene.instantiate() as Control
				ui.recipe = recipe
				ui.pressed.connect( func(): current_recipe = ui.recipe )
				ui.pressed.connect(recipe_full_upd)
				#sd_ui_control_search.bind(recipe.id, ui)
				recipe_container.add_child(ui)
	
	#sd_ui_control_search.update()

#RECIPE UPDATES
func recipe_full_upd() -> void:
	update_recipe_input()
	update_recipe_icon()
	update_recipe_desc()
	update_recipe_name()
	update_craft_btn()


#region UPD_INPUT
func add_craft_input(text:String="") -> void:
	if not is_instance_valid(inventory):
		return
	
	if current_recipe.can_craft(inventory):
		craft_input.append_text("[color=white]%s[/color]" % [text])
	else:
		craft_input.append_text("[color=gray]%s[/color]" % [text])

func update_recipe_input() -> void:
	if not current_recipe:
		return
	craft_input.text = ""
	for input in current_recipe.input:
		var format_text:String = "%s %s" % [input.quantity, input.source.name]
		add_craft_input(format_text)
#endregion

#region UPD_DESCRIPTION
func update_recipe_desc() -> void:
	if not current_recipe:
		return
	
	recipe_desc.text = current_recipe.output.source.description
#endregion

#region UPD_ICON
func update_recipe_icon() -> void:
	if not current_recipe:
		return
	
	recipe_icon.texture = current_recipe.output.source.icon
#endregion

#region UPD_NAME
func update_recipe_name() -> void:
	if not current_recipe:
		return
	
	recipe_name.text = current_recipe.output.source.name
#endregion

func update_craft_btn() -> void:
	if is_instance_valid(inventory):
		craft_btn.disabled = not (current_recipe.can_craft(inventory))
