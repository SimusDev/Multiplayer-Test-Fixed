extends Control

var weapon_holder:CSharkWeaponHolder

@onready var inventory_ammo_label = $inventory_ammo_label
@onready var ammo_label = $ammo_label

func update():
	inventory_ammo_label.text = "Inventory ammo: " + str(weapon_holder.current_weapon.current_inventory_ammmo)
	ammo_label.text = "Magazine: " + str(weapon_holder.current_weapon.current_ammo)
