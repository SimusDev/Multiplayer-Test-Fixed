extends Node
class_name FNAF_SourceLikeComponentSettings

@export var component: W_FPCSourceLike
@export var movement: W_FPCSourceLikeMovement
@export var node_based_component: SD_NodeBasedComponent

func _ready() -> void:
	if is_multiplayer_authority():
		UI.interface_opened.connect(_on_interface_opened)
		UI.interface_closed.connect(_on_interface_closed)
		
		if UI.has_active_interface():
			if component: component.add_disable_priority()
	else:
		if component: component.add_disable_priority()

func _on_interface_opened(node: Node) -> void:
	if movement:
		movement.input_enabled = false
	
	if component:
		component.add_disable_priority()
	
	if node_based_component:
		node_based_component.add_disable_priority()

func _on_interface_closed(node: Node) -> void:
	if movement:
		movement.input_enabled = true
	
	if component:
		component.subtract_disable_priority()
	
	if node_based_component:
		node_based_component.subtract_disable_priority()
