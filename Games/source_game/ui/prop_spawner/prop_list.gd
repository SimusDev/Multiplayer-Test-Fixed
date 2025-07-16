class_name UI_SourcePropList extends GridContainer

@export var prop_ui_prefab:PackedScene

func _ready() -> void:
	set("theme_override_constants/h_separation", 5)
	set("theme_override_constants/v_separation", 5)
