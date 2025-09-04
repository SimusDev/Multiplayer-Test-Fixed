extends Node3D

@export var hands_ik:Array[SkeletonIK3D]

func _ready() -> void:
	initialize()

func initialize() -> void:
	for hand in hands_ik:
		hand.stop()
		hand.start()
