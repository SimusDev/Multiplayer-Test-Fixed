@icon("res://addons/simusdev/icons/EditPivot.svg")
extends SD_NodeBasedComponent
class_name W_InteractableArea3D

@export var area: Area3D

static var _interactable_areas: Array[Area3D] = []

signal interacted(by: W_Interactor3D)

func _enter_tree() -> void:
	super()
	
	SD_Array.append_to_array_no_repeat(_interactable_areas, area)

func _exit_tree() -> void:
	super()
	
	SD_Array.erase_from_array(_interactable_areas, area)

func interact(interactor: W_Interactor3D) -> void:
	if not is_active():
		return
	
	SD_Multiplayer.sync_call_function(self, _interact_synced, [str(interactor.get_path())])

func _interact_synced(interactor_path: String) -> void:
	var interactor: W_Interactor3D = get_node_or_null(interactor_path)
	if interactor:
		interacted.emit(interactor)
		interactor.interacted.emit(self)

func _ready() -> void:
	area.set_meta("W_InteractableArea3D", self)

func _on_enabled() -> void:
	area.monitorable = true
	area.monitoring = true
	area.input_ray_pickable = true

func _on_disabled() -> void:
	area.monitorable = false
	area.monitoring = false
	area.input_ray_pickable = false

static func can_interact_with_area(area: Area3D) -> bool:
	return _interactable_areas.has(area)

static func find(node: Node) -> W_InteractableArea3D:
	return node.get_meta("W_InteractableArea3D", null)
