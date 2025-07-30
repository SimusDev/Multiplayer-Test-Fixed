@icon("res://addons/simusdev/icons/ToolSelect.svg")
extends SD_NodeBasedComponent
class_name W_Interactor3D

@export var root: Node
@export var raycast: RayCast3D
@export var input_action: String = "ui_accept"

var _selected: W_InteractableArea3D = null

signal selected(interactable: W_InteractableArea3D)
signal interacted(with: W_InteractableArea3D)

@onready var console: SD_TrunkConsole = SimusDev.console

func _ready() -> void:
	await root.ready
	if not is_multiplayer_authority():
		add_disable_priority()
		return
	
	console.visibility_changed.connect(_on_console_visibility_changed)

func _on_console_visibility_changed() -> void:
	if console.is_visible():
		add_disable_priority()
	else:
		subtract_disable_priority()

func _on_enabled() -> void:
	if raycast:
		#raycast.collide_with_areas = true
		#raycast.collide_with_bodies = false
		raycast.enabled = true

func _on_disabled() -> void:
	if raycast:
		#raycast.collide_with_areas = false
		#raycast.collide_with_bodies = false
		raycast.enabled = false
	
	if _selected == null:
		return
	
	_selected = null
	selected.emit(null)

func get_selected() -> W_InteractableArea3D:
	return _selected

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(input_action):
		try_interact()

func try_interact() -> void:
	if not is_active():
		return
	
	if _selected:
		_selected.interact(self)

func _physics_process(delta: float) -> void:
	var collider: Node = raycast.get_collider()
	if collider:
		if collider is Area3D:
			var can_interact: bool = W_InteractableArea3D.can_interact_with_area(collider)
			if can_interact:
				var interactable: W_InteractableArea3D = W_InteractableArea3D.find(collider)
				
				if _selected != interactable:
					_selected = interactable
					selected.emit(_selected)
			
	if not collider:
		if _selected != null:
			_selected = null
			selected.emit(null)
