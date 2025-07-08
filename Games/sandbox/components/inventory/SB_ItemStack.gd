extends WG_ItemStack
class_name SB_ItemStack

@export var object: SB_WorldObject

@onready var _level: SB_Level3D = SB_Level3D.find_above(self)
@onready var _section: SB_LevelSection3D

var _world_reference: Node

func _ready() -> void:
	if object:
		_section = _level.get_section(object.get_level_section())
	else:
		_section = _level.get_section("")
	
	if SD_Multiplayer.is_server():
		dropped.connect(_on_dropped)
		picked_up.connect(_on_picked_up)
	

func _on_dropped() -> void:
	#server logic
	
	var source: Node = get_inventory().get_source()
	if source is Node3D:
		var drop: Node = _section.spawn_local(object, true)
		if drop is Node3D:
			drop.global_position = source.global_position
		
		var inv: WG_Inventory = WG_Inventory.find_in(drop)
		get_inventory().transfer_item(self, inv)
		

func _on_picked_up(by: Node) -> void:
	#server logic
	
	if _world_reference:
		var inv: WG_Inventory = WG_Inventory.find_in(by)
		if not inv:
			return
		
		get_inventory().transfer_item(self, inv)
		_section.despawn_local(_world_reference)
		_world_reference = null
		
