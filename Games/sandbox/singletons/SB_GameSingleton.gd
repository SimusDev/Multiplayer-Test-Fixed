extends Node
class_name SB_GameSingleton

@export_dir var gamepath: String

@export var gamedata: SB_SModuleGameData
@export var commands: SB_SModuleCommands

@export var tools: Array[PackedScene] = []
@export var prefabs: SBR_Prefabs

static var instance: SB_GameSingleton

func _enter_tree() -> void:
	instance = self
	
	for tool in tools:
		SimusDev.tools.register_tool_from_scene(tool)

func _exit_tree() -> void:
	instance = null
	
	for tool in tools:
		SimusDev.tools.unregister_tool_from_scene(tool)
