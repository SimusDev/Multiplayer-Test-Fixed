extends R_WeaponObject
class_name R_WeaponProjectileObject

@export var automatic:bool = true

@export var max_ammo: int = 30
@export var damage_multiplier: float = 1.0
@export var ammo: Array[R_SourceAmmoObject] = []

@export var sound:R_SourceSound

func get_node_script() -> GDScript:
	return SourceProp

func _get_section() -> String:
	return "weapon"

func _registered() -> void:
	super()
	get_itemstack().durability_max = max_ammo
	get_itemstack().durability = max_ammo

func _itemstack_instantiated(stack: SourceItemStack) -> void:
	var current_ammo_type := get_ammo_type(stack)

func _try_reload(gun_item: SourceItemStack) -> void:
	if not SD_Network.is_server():
		return
	
	var current_ammo_type := get_ammo_type(gun_item)
	
	var loaded: Array = gun_item._data.get_or_add("ammo", []) as Array
	if loaded.size() < 2:
		return
	
	var picked_ammo: SourceItemStack
	var picked_ammo_type: R_SourceAmmoObject
	
	var gun_object: R_WeaponProjectileObject = gun_item.object as R_WeaponProjectileObject
	for ammo_type in gun_object.ammo:
		for ammostack in gun_item.get_inventory().get_items_by_object(ammo_type):
			if ammostack.object in ammo:
				picked_ammo = ammostack
				picked_ammo_type = ammostack.object
	
	if not picked_ammo or not picked_ammo_type:
		return
	
	var need_bullets: int = gun_item.get_max_durability() - gun_item.get_durability()
	var ammo_quantity: int = picked_ammo.get_quantity()
	var gun_durability: int = gun_item.get_durability()
	
	while need_bullets > 0:
		ammo_quantity -= 1
		gun_durability += 1
		need_bullets -= 1
		if ammo_quantity <= 0:
			break
	
	loaded.set(0, ammo_quantity)
	loaded.set(1, picked_ammo_type.serialize_cached())
	picked_ammo.set_quantity(ammo_quantity)
	gun_item.set_durability(gun_durability)

func get_ammo_type(gun: SourceItemStack) -> R_SourceAmmoObject:
	var loaded: Array = gun._data.get_or_add("ammo", []) as Array
	if loaded.size() < 2 and !ammo.is_empty():
		loaded.append(max_ammo)
		loaded.append(ammo[0].serialize_cached())
	return R_SourceWorldObject.deserialize_cached(loaded[1])
