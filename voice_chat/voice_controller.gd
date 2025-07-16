extends Node

var effect
var recording = false

func _ready():
	# Создаем аудиоэффект для записи
	effect = AudioEffectCapture.new()
	var idx = AudioServer.get_bus_index("Record")
	AudioServer.add_bus_effect(idx, effect)
	AudioServer.set_bus_effect_enabled(idx, 0, true)

func _input(event: InputEvent) -> void:
	pass

func start_recording():
	var idx = AudioServer.get_bus_index("Record")
	AudioServer.set_bus_mute(idx, false)
	recording = true
	
func stop_recording():
	var idx = AudioServer.get_bus_index("Record")
	AudioServer.set_bus_mute(idx, true)
	recording = false

func _process(delta):
	if recording and effect.can_get_buffer(1024):
		var stereo_buffer = effect.get_buffer(1024)
		# Здесь можно обработать буфер перед отправкой
		# Например, сжать аудио или применить эффекты
		play_voice_data(stereo_buffer)

#@rpc("any_peer", "unreliable")
#func send_voice_data(buffer):
	## Отправка данных всем, кроме отправителя
	#var sender_id = multiplayer.get_remote_sender_id()
	#for peer_id in peer.get_peers():
		#if peer_id != sender_id:
			#rpc_id(peer_id, "receive_voice_data", buffer)
#
#@rpc("authority", "unreliable")
#func receive_voice_data(buffer):
	## Воспроизведение полученных аудиоданных
	#play_voice_data(buffer)

func play_voice_data(buffer):
	var stream_player = AudioStreamPlayer.new()
	add_child(stream_player)
	
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = 44100 # или другая частота, совпадающая с записью
	
	stream_player.stream = stream
	stream_player.play()
	
	var playback = stream_player.get_stream_playback()
	playback.push_buffer(buffer)
	
	# Автоматическое удаление после воспроизведения
	await stream_player.finished
	stream_player.queue_free()
