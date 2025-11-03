@tool
class_name SourceProp extends SourceObject

signal key_pressed(key:String)
signal drag


@export var sync_transform: bool = false
@export var rigid_body:RigidBody3D
@export_group("Surface Settings")
@export var surface:String
@export var surface_type:String="smooth"
@export_group("Surface Sounds")
@export var soft_impact_sounds:Array[AudioStream]
@export var hard_impact_sounds:Array[AudioStream]
@export var scrape_sounds:Array[AudioStream]

const synced_property_scene:PackedScene = preload("res://Games/source_game/game/prefabs/mp_property_transform.tscn")
var is_drag:bool = false
var drag_target:Node3D = null

var scraping:bool = false

var scraping_audio_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint():
		return
	
	if !is_instance_valid(rigid_body):
		rigid_body = get_parent() as RigidBody3D
	drag.connect(_on_drag_syncronized)
	
	add_child(scraping_audio_player)
	SD_Network.register_object(scraping_audio_player)
	SD_Network.register_object(rigid_body)
	
	SD_Components.append_to(rigid_body, self)
	
	rigid_body.freeze = SD_Multiplayer.is_not_server()
	rigid_body.can_sleep = SD_Multiplayer.is_not_server()
	
	
	
	if not rigid_body.is_in_group("props"):
		rigid_body.add_to_group("props")
	
	if synced_property_scene and sync_transform:
		var synced_property:SD_MPPropertySynchronizer = synced_property_scene.instantiate()
		rigid_body.add_child.call_deferred(synced_property)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if SD_Multiplayer.is_server():
		if not scrape_sounds.is_empty():
			pass
			#handle_scrape_and_play_sound()
		
		if is_drag and drag_target:
				rigid_body.global_position = lerp(rigid_body.global_position, drag_target.global_position, 50 * delta)
				rigid_body.global_rotation_degrees = drag_target.global_rotation_degrees

func handle_scrape_and_play_sound() -> void:
	if is_instance_valid(rigid_body):
		if ( not rigid_body.get_colliding_bodies().is_empty() ) and rigid_body.linear_velocity:
			scraping = true
		else:
			scraping = false
	
	if scraping and (not scraping_audio_player.playing):
		SD_Network.call_func_on_server(func(): scraping_audio_player.stream = scrape_sounds.pick_random())
		SD_Network.var_sync_from_server(scraping_audio_player, ["stream"])
		SD_Network.call_func(scraping_audio_player.play)
	else:
		SD_Network.call_func(scraping_audio_player.stop)

func _on_drag_syncronized(value:bool, target:Node3D):
	SD_Multiplayer.sync_call_function(self, _on_drag, [value, target])

func _throw(player_position:Vector3, _strength):
	var direction = (rigid_body.global_position - player_position).normalized()
	rigid_body.apply_impulse(direction * _strength, rigid_body.global_position)

func _on_drag(value:bool, target:Node3D):
	is_drag = value
	drag_target = target
	rigid_body.gravity_scale = float(!value)
	
	if SD_Multiplayer.is_not_server(): return
	rigid_body.freeze = is_drag
	rigid_body.position = rigid_body.position * float(!is_drag)

static func find_in(node:Node) -> SourceProp:
	return SD_Components.find_first(node, SourceProp)
