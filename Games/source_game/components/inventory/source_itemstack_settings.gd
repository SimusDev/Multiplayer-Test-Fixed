extends Resource
class_name SourceItemStackSettings

@export var stackable: bool = true
@export var stack_size: int = 64
@export var pickable: bool = true
@export var durability: float = 0.0
@export var durability_max: float = 0.0
@export var custom_script: GDScript : get = get_custom_script
@export var actions: Array[SourceItemAction] = [] : get = get_actions

signal on_action_local(action: SourceItemAction)

func get_custom_script() -> GDScript:
	if custom_script:
		return custom_script
	return SourceItemStack

func get_actions() -> Array[SourceItemAction]:
	return actions

func register() -> void:
	actions.append(SourceItemActionDrop.new())
	
