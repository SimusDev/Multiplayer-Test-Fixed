extends R_WeaponObject
class_name R_WeaponProjectileObject

@export var max_ammo: int = 30
@export var damage_multiplier: float = 1.0
@export var ammo: Array[R_SourceAmmoObject] = []

func get_node_script() -> GDScript:
	return SourceProp

func _get_section() -> String:
	return "weapon"

func _registered() -> void:
	get_itemstack().durability_max = max_ammo
	get_itemstack().durability = 0

func _itemstack_instantiated(stack: SourceItemStack) -> void:
	pass

func _try_reload(gun_item: SourceItemStack) -> void:
	if not SD_Network.is_server():
		return
	
	var loaded: Array = gun_item._data.get_or_add("ammo", []) as Array
	if loaded.size() < 2 and !ammo.is_empty():
		loaded[0] = 0
		loaded[1] = ammo[0]
	
	if loaded.size() < 2:
		return
	
	var gun_object: R_WeaponProjectileObject = gun_item.object as R_WeaponProjectileObject
	for ammo_type in gun_object.ammo:
		for ammostack in gun_item.get_inventory().get_items_by_object(ammo_type):
			print(ammostack)
	
	
