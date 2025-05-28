extends Resource
class_name R_UnitProperties

@export var unit_name:String = "Name"

#region LVL
@export_group("Lvl")
@export var lvl:int = 1
@export var experience:float = 0.0
#endregion

#region STATS
@export_group("Stats")
@export var health:float = 1.0
@export var mana:float = 1.0
@export var armor:float = 1.0

@export var max_health:float = 1.0
@export var max_mana:float = 1.0
@export var max_armor:float = 1.0

@export var health_regen:float = 1.0
@export var mana_regen:float = 1.0

@export var move_speed:float = 5.0

@export_group("Attributes")

@export var strength:float = 1.0
@export var agility:float = 1.0
@export var intelligence:float = 1.0

@export_subgroup("Lvl Gain")
@export var strength_per_lvl:float = 1.0
@export var agility_per_lvl:float = 1.0
@export var intelligence_per_lvl:float = 1.0

#endregion
