extends SourceItem

signal ignite_change

@onready var progress_node:Node3D = $root/model/ciga/progress

@export var tickrate:float = 32.0
@export var durability_per_tick:float = 0.01

var ignite:bool = false : set = set_ignite, get = is_ignite
var durability_multiplier:float = 1.0

func _ready() -> void:
	super()
	
	update()
	stack.durability_changed.connect(update)
	ignite_change.connect(on_ignite_change)

	if SD_Network.is_server():
		var tick_timer:Timer = Timer.new()
		
		tick_timer.wait_time = 1.0 / tickrate
		tick_timer.timeout.connect(tick)
		add_child(tick_timer)
		
		tick_timer.start()

func use(event_name:StringName = "item_use", use_signal:Signal = on_use) -> void:
	super()
	
	

func set_ignite(value:bool) -> void:
	ignite = value
	ignite_change.emit()

func is_ignite() -> bool:
	return ignite

func on_ignite_change() -> void:
	$root/model/GPUParticles3D.emitting = is_ignite()

func update() -> void:
	var normalized_durability = stack.get_durability() / 100.0
	progress_node.position.y = 0.01 + normalized_durability * 0.045

func tick() -> void:
	if stack.get_durability() >= durability_per_tick:
		stack.set_durability( stack.get_durability() - (durability_per_tick * durability_multiplier) )
