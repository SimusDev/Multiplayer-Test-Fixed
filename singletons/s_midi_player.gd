extends Node

@export var players:Node
var midi_base_path:String = "res://midi/" : set = set_midi_base_path
var sf_base_path:String = "res://soundfonts/" : set = set_sf_base_path

func _ready() -> void:
	pass

func set_midi_base_path(path:String) -> void:
	midi_base_path = path

func set_sf_base_path(path:String) -> void:
	sf_base_path = path

func clear_tracks() -> void:
	for c in players.get_children():
		c.queue_free() 

func add_track(midi_file_path:String, soundfont_path:String, play:bool = true, loop:bool = true) -> void:
	var midi_player:MidiPlayer = MidiPlayer.new()
	midi_player.file = "%s%s" % [midi_base_path, midi_file_path]
	midi_player.soundfont = "%s%s" % [sf_base_path, soundfont_path]
	midi_player.bus = "midi"
	midi_player.loop = loop
	midi_player.name = midi_file_path
	players.add_child(midi_player)
	if play:
		midi_player.play()
	SimusDev.console.write_success("Created track at idx %s\nmidi: %s\nsf:%s" % [midi_player.get_index(), midi_file_path, soundfont_path])

func remove_track(idx:int = 0) -> void:
	players.get_child(idx).queue_free()

func play_track(idx:int = 0) -> void:
	players.get_child(idx).play()

func stop_track(idx:int = 0) -> void:
	players.get_child(idx).stop()

func _on_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"midi.tracks":
			var result_text:String = "\n"
			if players.get_children().is_empty():
				SimusDev.console.write_info("have not midi tracks")
				return
			for c in players.get_children():
				if c is MidiPlayer:
					result_text += "=> %s: %s\n" % [c.get_index(), c.name]
					result_text += "|=> Midi File: %s\n" % [c.file]
					result_text += "|=> Soundfont: %s\n" % [c.soundfont]
					result_text += "|=> Playing: %s\n" % [c.playing]
					result_text += "|=> Loop: %s\n" % [c.loop]
			SimusDev.console.write_success(result_text)
			return
		
		"midi.dir_midi":
			if not command.get_arguments().size() == 0:
				return
			var files:Array = SD_FileSystem.get_all_files_with_extension_from_directory(
				midi_base_path,
				SD_FileExtensions.EC_MIDI
				)
			var result_text = ""
			for file in files:
				result_text += "%s, " % [file]
				
			SimusDev.console.write_success(result_text)
			return

		"midi.dir_soundfont":
			if not command.get_arguments().size() == 0:
				return
			var files:Array = SD_FileSystem.get_all_files_with_extension_from_directory(
				sf_base_path,
				SD_FileExtensions.EC_SOUNDFONT
				)
			var result_text = ""
			for file in files:
				result_text += "%s, " % [file]
				
			SimusDev.console.write_success(result_text)
			return

		"midi.base_path":
			if command.get_arguments().size() < 1:
				SimusDev.console.write_success("=> %s" % [midi_base_path])
				return
			set_midi_base_path( command.get_value_as_string() )
			return

		"midi.sf_base_path":
			if command.get_arguments().size() < 1:
				SimusDev.console.write_success("=> %s" % [sf_base_path])
				return
			set_sf_base_path( command.get_value_as_string() )
			return

		"midi.add_track":
			if command.get_arguments().size() < 2:
				return
			var args = command.get_arguments() as Array[String]
			add_track( args.get(0), args.get(1) )
			return

		"midi.remove_track":
			if command.get_arguments().size() < 1:
				return
			remove_track( command.get_value_as_int() )
			SimusDev.console.write_success("midi track removed: %s" % [command.get_value_as_int()])
			return

		"midi.play_track":
			if command.get_arguments().size() < 1:
				return
			play_track(command.get_value_as_int())
			return

		"midi.stop_track":
			if command.get_arguments().size() < 1:
				return
			stop_track(command.get_value_as_int())
			return
