extends Control

var weapon_holder:CSharkWeaponHolder

@onready var inventory_ammo_label = $inventory_ammo_label
@onready var ammo_label = $ammo_label
@onready var taverna = $taverna
@onready var taverna_label = $taverna/label
@export var taverna_timer:Timer

var taverna_time:float

func _ready() -> void:
	update()

func update():
	inventory_ammo_label.text = "Inventory ammo: " + str(weapon_holder.current_weapon.current_inventory_ammmo)
	ammo_label.text = "Magazine: " + str(weapon_holder.current_weapon.current_ammo)

func _process(_delta: float) -> void:
	if taverna_timer.wait_time < 1.0:
		return
	
	taverna_label.text = "ТЫ В ТАВЕРНЕ !!! \n" + str(taverna_time)

func show_taverna():
	
	
	taverna_timer.wait_time = taverna_time
	taverna_timer.start()
	
	taverna.show()
func hide_taverna():
	taverna.hide()
