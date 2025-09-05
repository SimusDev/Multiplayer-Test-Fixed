extends SourceItem

@export_group("Custom Animations Names")
@export var _open_anim:String = "open"
@export var _close_anim:String = "close"
@export var _take_anim:String = "take"
@export_group("Custom Node References", "custom_")
@export var cigi_node_parent:Node3D
@export var custom_animation_player:AnimationPlayer

signal open_changed

var cigi:int = 0 : set = set_cigi
var open:bool = false : set = set_open, get = is_open

func _ready() -> void:
	super()
	cigi = stack.data_get_or_add("cigi_", 14)
	update_cigi_v_pa4ke()

func set_cigi(value:int) -> void:
	cigi = value
	stack.data_set_value("cigi_", value)

func remove_cigu() -> void:
	cigi -= 1
	update_cigi_v_pa4ke()

func update_cigi_v_pa4ke() -> void:
	for x in cigi_node_parent.get_children().size():
		cigi_node_parent.get_child(x).visible = x < cigi

func is_open() -> bool:
	return open
func set_open(value:bool) -> void:
	open = value
	open_changed.emit()

func use() -> void:
	super()
	if not SD_Network.is_authority(self):
		return
	
	if cigi > 0:
		if not is_open():
			custom_animation_player.play(_open_anim)
			set_open(true)
		else:
			animation_player.play(_take_anim)

		update_cigi_v_pa4ke()
