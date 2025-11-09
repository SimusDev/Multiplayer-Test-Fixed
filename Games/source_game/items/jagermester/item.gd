extends SourceItem

@export var effect_prefab:PackedScene

func use(event_name:StringName = "item_use", use_signal:Signal = on_use) -> void:
	super()
	
	#ItemStack durability -= - 100.0


func apply_effect() -> void:
	
	pass



func start_effect_timer(base_duration:float = 60.0) -> void:
	pass
	
	
