class_name SourceReverbZone extends Area3D

var reverb_effect: AudioEffectReverb = null

func _exit_tree() -> void:
	if reverb_effect != null:
		var bus_idx = AudioServer.get_bus_index("Master")
		for i in AudioServer.get_bus_effect_count(bus_idx):
			if AudioServer.get_bus_effect(bus_idx, i) == reverb_effect:
				AudioServer.remove_bus_effect(bus_idx, i)
				break
		reverb_effect = null

func _ready() -> void:
	body_entered.connect(turn_on) 
	body_exited.connect(turn_off)

func turn_on(body: Node):
	if !body is SourcePlayer or !body.is_multiplayer_authority():
		return
	
	if reverb_effect == null:
		reverb_effect = AudioEffectReverb.new()
		reverb_effect.room_size = 0.4
		reverb_effect.dry = 1.0 
		reverb_effect.wet = 0.5 

		var bus_idx = AudioServer.get_bus_index("Master")
		AudioServer.add_bus_effect(bus_idx, reverb_effect)
		AudioServer.set_bus_effect_enabled(bus_idx, AudioServer.get_bus_effect_count(bus_idx) - 1, true)

func turn_off(body: Node):
	if !body is SourcePlayer or !body.is_multiplayer_authority():
		return
	
	if reverb_effect != null:
		var bus_idx = AudioServer.get_bus_index("Master")
		for i in AudioServer.get_bus_effect_count(bus_idx):
			if AudioServer.get_bus_effect(bus_idx, i) == reverb_effect:
				var tween = create_tween()
				tween.tween_property(reverb_effect, "wet", 0.0, 0.5)
				await tween.finished
				AudioServer.remove_bus_effect(bus_idx, i)
				break
		reverb_effect = null
