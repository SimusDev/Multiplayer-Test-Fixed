extends Node
class_name EL_GameSingleton

@export var gamedata: EL_SModuleGameData
@export var commands: EL_SModuleCommands

@export var prefabs: ELR_Prefabs

static var instance: EL_GameSingleton

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	instance = null
