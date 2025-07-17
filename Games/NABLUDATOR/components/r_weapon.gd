class_name R_NabludatorWeapon extends Resource

@export var name:String = ""
@export var code:String = ""

@export_category("Ammo Settings")
@export var magazine_ammo:int = 30
@export_category("Damage Settings")
@export var base_damage:float = 30.0
@export var head_damage_multiplier:float = 2.0
@export var chest_damage_multiplier:float = 1.0
@export var legs_damage_multiplier:float = 0.5
@export_category("Visual Settings")
@export var model:PackedScene
