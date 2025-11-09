extends R_SourceWorldObject
class_name R_SourceEffect

@export var overlap: bool = true
@export var ui_visible: bool = true
@export var timeout: float = 1.0

func _itemstack_instantiated(stack: SourceItemStack) -> void:
	if SD_Network.is_server():
		stack.get_inventory().effects.give(stack.object as R_SourceEffect)
		stack.queue_free()

func _get_section() -> String:
	return "effects"

func _start(instance: SourceEffectInstance) -> void:
	pass

func _tick(instance: SourceEffectInstance, delta: float) -> void:
	pass

func _physics_tick(instance: SourceEffectInstance, delta: float) -> void:
	pass

func _end(instance: SourceEffectInstance) -> void:
	pass
