extends Node3D

var _hands: CS_EntityHands

var _item: CS_WeaponItem

@export var anim_idle: String = "idle"
@export var anim_shoot: String = "shoot"
@export var anim_reloading: String = "reloading"

func initialize(item: CS_WeaponItem) -> void:
	_item = item
	
