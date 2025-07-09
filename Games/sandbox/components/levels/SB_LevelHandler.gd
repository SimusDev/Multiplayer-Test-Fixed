extends Node
class_name SB_LevelHandler

@export var initial_level: SB_LevelResource

@export var singleton: SB_GameSingleton

func _ready() -> void:
	change_local(initial_level)

func _clear_levels() -> void:
	for i in get_children():
		if i is SB_Level3D:
			i.deinit()
			await i.deinitialized

func change_local(resource: SB_LevelResource) -> void:
	_clear_levels()
	SB_Level3D.instantiate(self, resource)
