extends Node
class_name FNAF_SourceLikeComponentSettings

@export var root: Node
@export var components: Array[W_FPCSourceLike]
@export var node_based_components: Array[SD_NodeBasedComponent]

func _ready() -> void:
	await root.ready
	if is_multiplayer_authority():
		UI.interface_opened.connect(_on_interface_opened)
		UI.interface_closed.connect(_on_interface_closed)
		
		if UI.has_active_interface():
			disable()
	else:
		disable()

func _on_interface_opened(node: Node) -> void:
	disable()

func _on_interface_closed(node: Node) -> void:
	enable()

func enable() -> void:
	for component in components:
		if component is W_FPCSourceLikeMovement:
			component.input_enabled = true
			if not is_multiplayer_authority():
				component.subtract_disable_priority()
		else:
			component.subtract_disable_priority()
	
		if is_multiplayer_authority():
			if component is W_FPCSourceLikeCamera:
				component.set_mouse_captured(true)
	
	for component in node_based_components:
		component.subtract_disable_priority()

func disable() -> void:
	for component in components:
		if component is W_FPCSourceLikeMovement:
			component.input_enabled = false
			if not is_multiplayer_authority():
				component.add_disable_priority()
		else:
			component.add_disable_priority()
		
		if is_multiplayer_authority():
			if component is W_FPCSourceLikeCamera:
				component.set_mouse_captured(false)
	
	for component in node_based_components:
		component.add_disable_priority()
