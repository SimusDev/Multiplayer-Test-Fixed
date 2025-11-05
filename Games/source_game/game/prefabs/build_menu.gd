extends Control

@export var build_scheme:BuildScheme

@export var section_prefab:PackedScene
@onready var container:VBoxContainer = $content/ScrollContainer/VBoxContainer

func _ready() -> void:
	update_list()

func clear_list() -> void:
	for child in container.get_children():
		child.queue_free()

func update_list() -> void:
	clear_list()
	
	for ref in R_SourceWorldObject.get_reference_list():
		if ref is R_SourceBuildings:
			
			var new_section = section_prefab.instantiate()
			new_section.resource = ref
			new_section.build_scheme = build_scheme
			container.add_child(new_section)
