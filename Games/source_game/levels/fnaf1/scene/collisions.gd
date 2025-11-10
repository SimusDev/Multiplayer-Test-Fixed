@tool
extends Node3D


@export_tool_button("Optimize") var button: Callable = optimize

func optimize() -> void:
	_optimize(self)

func _optimize(parent: Node) -> void:
	for i in parent.get_children():
		i.name = str(i.get_index())
		_optimize(i)

func _ready() -> void:
	pass
