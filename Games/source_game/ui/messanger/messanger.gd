extends Control
class_name ui_SourceMessanger

static var _ref: ui_SourceMessanger

@export var icons: Array[Texture] = []
@export var sounds: Array[AudioStream] = []

@export var def_icon: Texture
@export var def_sound: AudioStream
@export var message_scene: PackedScene

@export var container: Control

func _enter_tree() -> void:
	_ref = self

static func as_node() -> ui_SourceMessanger:
	return _ref

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send,
	])

func get_icon(id: int) -> Texture:
	return SD_Array.get_value_from_array(icons, id, def_icon)

func get_icon_id(icon: Texture) -> int:
	return icons.find(icon)

func get_sound(id: int) -> AudioStream:
	return SD_Array.get_value_from_array(sounds, id, def_sound)

func get_sound_id(sound: AudioStream) -> int:
	return sounds.find(sound)

func _send(text: Variant, icon: int, sound: int) -> void:
	var r_icon: Texture = get_icon(icon)
	var r_sound: AudioStream = get_sound(sound)
	
	var msg: Control = message_scene.instantiate() as Control
	msg.text = str(text)
	msg.time = 5
	msg.icon = r_icon
	msg.sound = r_sound
	container.add_child(msg)

func _send_to(peer: int, text: Variant, icon: int, sound: int) -> void:
	SD_Network.call_func_on(peer, _send, [text, icon, sound])

func _send_to_all(text: Variant, icon: int, sound: int) -> void:
	SD_Network.call_func(_send, [text, icon, sound])

static func send(text: Variant, icon: Texture = null, sound: AudioStream = null) -> void:
	as_node()._send(text, as_node().get_icon_id(icon), as_node().get_sound_id(sound))

static func send_to(peer: int, text: Variant, icon: Texture = null, sound: AudioStream = null) -> void:
	as_node()._send_to(peer, text, as_node().get_icon_id(icon), as_node().get_sound_id(sound))

static func send_to_all(text: Variant, icon: Texture = null, sound: AudioStream = null) -> void:
	as_node()._send_to_all(text, as_node().get_icon_id(icon), as_node().get_sound_id(sound))

func _on_sd_node_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"send":
			_send_to_all(command.get_argument(0), command.get_argument(1).to_int(), command.get_argument(2).to_int())
