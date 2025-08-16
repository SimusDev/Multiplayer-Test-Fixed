class_name SourceNodeIK extends Node

@export var ik_nodes:Array[SkeletonIK3D]

func _ready() -> void:
	activate_ik_nodes()

func activate_ik_nodes() -> void:
	for node in ik_nodes:
		node.start()
