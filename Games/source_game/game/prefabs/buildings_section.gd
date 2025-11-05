extends Control

@export var building_preview:PackedScene
@export var resource:R_SourceBuildings

@onready var title:Label = $title
@onready var container:GridContainer = $ScrollContainer/GridContainer

var build_scheme:BuildScheme

func _ready() -> void:
	title.text = resource.name
	update_list()

func clear_list() -> void:
	for child in container.get_children():
		child.queue_free()

func update_list() -> void:
	clear_list()
	
	for building in resource.list:
		var preview = building_preview.instantiate()
		preview.resource = building
		preview.build_scheme = build_scheme
		container.add_child(preview)
