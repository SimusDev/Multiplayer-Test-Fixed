extends SourceItem

@export var ciga_world_resource:R_SourceWorldObject
@export var ciga_model_prefab:PackedScene
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
	SD_Network.register_function(take_cigu)
	cigi = stack.data_get_or_add("cigi_", 20)
	update_cigi_v_pa4ke()

func set_cigi(value:int) -> void:
	cigi = value
	stack.data_set_value("cigi_", value)

func take_cigu() -> void:
	cigi -= 1
	inventory.add_item(SourceItemStack.create_from_object(ciga_world_resource))
	update_cigi_v_pa4ke()

func take_cigu_sync() -> void:
	SD_Network.call_func_on_server(take_cigu)

func update_cigi_v_pa4ke() -> void:
	for child in cigi_node_parent.get_children():
		child.queue_free()
	if ciga_model_prefab:
		for x in range(0, cigi):
			var new_ciga:Node3D = ciga_model_prefab.instantiate()
			cigi_node_parent.add_child(new_ciga)
			if x < 10:
				new_ciga.position.x += 0.005 * x
			else:
				new_ciga.position.x += (0.005 * x) - 0.05
				new_ciga.position.z += 0.005

func is_open() -> bool:
	return open
func set_open(value:bool) -> void:
	open = value
	open_changed.emit()

func use() -> void:
	super()
	if not SD_Network.is_authority(self):
		return
	
	if not is_open():
		custom_animation_player.play(_open_anim)
		set_open(true)
	elif cigi > 0:
		animation_player.play(_take_anim)
