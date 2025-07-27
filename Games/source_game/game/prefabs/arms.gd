extends Node3D

@export var hands_ik:Array[SkeletonIK3D] = [$root/Skeleton3D/left_hand_ik, $root/Skeleton3D/right_hand_ik]

func _ready() -> void:
	initialize()

func initialize() -> void:
	for hand in hands_ik:
		hand.start()
