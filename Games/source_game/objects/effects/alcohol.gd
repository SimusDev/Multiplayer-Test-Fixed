extends R_SourceEffect

var scene: PackedScene

var ui: Control

func _registered() -> void:
	scene = load("res://Games/source_game/ui/effects/alcohol.tscn")

func _start(instance: SourceEffectInstance) -> void:
	instance.set_tickrate(5)

func _tickrate_tick(instance: SourceEffectInstance, delta: float) -> void:
	instance.effects.inventory.player.health.apply_damage(0.1)

func _start_local(player: SourcePlayable, instance: SourceEffectInstance) -> void:
	if is_instance_valid(ui):
		return
	
	ui = scene.instantiate()
	
	player.ui.add_child(ui)

func _end_local(player: SourcePlayable, instance: SourceEffectInstance) -> void:
	if is_instance_valid(ui):
		ui.queue_free()
