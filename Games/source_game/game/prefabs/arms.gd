@tool
extends Node3D

@export var hands_ik:Array[SkeletonIK3D]

func _enter_tree() -> void:
	initialize()

func initialize() -> void:
	for hand in hands_ik:
		hand.start()
