class_name CSharkZombieAttack extends Area3D

@export var zombie:CSharkZombie
@export var audio_stream:AudioStream
var damage_targets:Array[W_ComponentHealth]

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area:Area3D):
	if !SD_Multiplayer.is_server():
		return
	
	if area == zombie.hitbox:
		return
	
	for x in area.get_parent().get_children():
		if x is W_ComponentHealth:
			damage_targets.append(x)

func _on_area_exited(area:Area3D):
	if !SD_Multiplayer.is_server():
		return
	
	if area == zombie.hitbox:
		return

	for x in area.get_parent().get_children():
		if x is W_ComponentHealth:
			damage_targets.erase(area)

func smash():
	#play audio
	var audio = SD_MPSyncedAudioStreamPlayer3D.new()
	CSharkGame.instance.add_child(audio)
	
	audio.global_position = global_position
	audio.finished.connect(audio.queue_free)
	
	audio.stream = audio_stream
	audio.play_synced()
	
	if !damage_targets:
		return
	
	for target in damage_targets:
		if !target:
			return
		
		if !target == zombie.health:
			target.target.apply_damage_synced(zombie.damage)
	








#
