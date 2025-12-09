extends SourceItem

@export var effect:R_SourceEffect

#func _ready() -> void:
	#super()
	#animation_player.play(_pick)
#
#func use() -> void:
	#if animation_player.is_playing():
		#return
	#
	#super()
	#animation_player.play(_fire)
	#apply_effect()
#
#func apply_effect() -> void:
	#inventory.effects.give(effect)
