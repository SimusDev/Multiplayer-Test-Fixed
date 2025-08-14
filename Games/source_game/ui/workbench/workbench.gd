extends Control

@export var scene: PackedScene
@export var container: Control

@onready var sd_ui_control_search: SD_UIControlSearch = $SD_UIControlSearch

func _ready() -> void:
	for recipe in R_SourceRecipe.get_list():
		if recipe.is_visible():
			var ui: Control = scene.instantiate() as Control
			ui.recipe = recipe
			sd_ui_control_search.bind(recipe.id, ui)
			container.add_child(ui)
	sd_ui_control_search.update()
