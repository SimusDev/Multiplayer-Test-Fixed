extends SourceItem

signal ignite_change

@onready var progress_node:Node3D = $root/model/ciga/progress
var ignite:bool = false : set = set_ignite, get = is_ignite

func _ready() -> void:
	super()
	
	stack.durability_changed.connect(update)
	set_ignite(true)

func set_ignite(value:bool) -> void:
	ignite = value
	ignite_change.emit()

func is_ignite() -> bool:
	return ignite

func update() -> void:
	# min - 0.01; max - 0.055
	var normalized_durability = stack.get_durability() / 100.0
	progress_node.position.y = 0.01 + normalized_durability * 0.045
