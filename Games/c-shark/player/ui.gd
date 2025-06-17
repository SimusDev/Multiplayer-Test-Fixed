extends Control

var weapon_holder:CSharkWeaponHolder

@onready var ammo_label = $status/rect/ammo
@onready var health_label = $status/rect/health
@onready var reloading_label = $reloading_label

@onready var taverna = $taverna
@onready var taverna_label = $taverna/label
@export var taverna_timer:Timer

var taverna_time:float

func _ready() -> void:
	update()

func update():
	var ammo = str(weapon_holder.current_weapon.current_ammo)
	var inv_ammo = str(weapon_holder.current_weapon.current_inventory_ammo)
	var health = str(weapon_holder.root.health.get_health())
	
	
	ammo_label.text = "[color=ffffff]" + ammo + "[color=7f7f7f]" + "/" + inv_ammo
	health_label.text = health

func _process(_delta: float) -> void:
	taverna_label.text = "ТЫ В ТАВЕРНЕ !!! \n" + str(taverna_timer.wait_time)

func show_taverna():
	taverna_timer.wait_time = taverna_time
	taverna_timer.start()
	
	taverna.show()
func hide_taverna():
	taverna.hide()
