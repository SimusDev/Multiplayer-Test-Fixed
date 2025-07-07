extends Node
class_name EL_LevelHandler

@export var initial_level: EL_LevelResource

@export var singleton: EL_GameSingleton

func _ready() -> void:
	await singleton.gamedata.load_finished
	
	change_local(initial_level)

func _clear_levels() -> void:
	for i in get_children():
		if i is EL_Level3D:
			i.deinit()
			await i.deinitialized

func change_local(resource: EL_LevelResource) -> void:
	_clear_levels()
	EL_Level3D.instantiate(self, resource)
