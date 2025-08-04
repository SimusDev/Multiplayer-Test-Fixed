extends Control

@onready var inv: SourceInventory

@export var recipe: R_SourceRecipe

func _ready() -> void:
	inv = SD_Components.find_first(SourcePlayer.instance, SourceInventory)
	$TextureRect.texture = recipe.output.source.icon
	$SD_Label.localization_key = recipe.id
	

func _on_button_pressed() -> void:
	inv.craft(recipe)
