@tool
extends WorldEnvironment
class_name SD_WorldEnvironment

static var _instance: SD_WorldEnvironment

static var instance: SD_WorldEnvironment :
	get:
		return _instance

func _init() -> void:
	_instance = self

@onready var sky: Sky = environment.sky

@export var cycle_speed: float = 0.1
var cycle_speed_multiplier: float = 0.1
@export var cycle_in_editor: bool = false

signal date_changed()

@export var start_time: float = 0.4
@export var time: float = 0.0 :
	set(value):
		time = value
		cycle(false)
		
		SD_WorldEnvironmentTime.time = time

@export var day: int = 1 :
	set(value):
		var max_days: int = SD_TimeParser.get_days_in_month(month)
		if value > max_days:
			value = 1
			month += 1
		
		day = value
		SD_WorldEnvironmentTime.day = day
		date_changed.emit()

@export var month: int = 1 :
	set(value):
		if value > 12:
			value = 1
			year += 1
		
		month = value
		SD_WorldEnvironmentTime.month = month
		date_changed.emit()

@export var year: int = 2025 :
	set(value):
		year = value
		
		SD_WorldEnvironmentTime.year = year
		date_changed.emit()

@export var sun: DirectionalLight3D
@export var moon: DirectionalLight3D

@export var animation_player: AnimationPlayer
@export var animation_seek_multiplier: float = 10.0

@onready var sky_material: ProceduralSkyMaterial = sky.sky_material

@export var lighting: bool = true: set = set_lighting

@export var sky_top_color: Color = Color("62748c"):
	set(value):
		sky_top_color = value
		if sky_material: sky_material.sky_top_color = value

@export var sky_horizon_color: Color = Color("a5a7ab"):
	set(value):
		sky_horizon_color = value
		if sky_material: sky_material.sky_horizon_color = value

@export var ground_bottom_color: Color = Color("332b22"):
	set(value):
		ground_bottom_color = value
		if sky_material: sky_material.ground_bottom_color = value

@export var ground_horizon_color: Color = Color("a5a7ab"):
	set(value):
		ground_horizon_color = value
		if sky_material: sky_material.ground_horizon_color = value



func _ready() -> void:
	if not Engine.is_editor_hint():
		time = start_time
	
	animation_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	SD_WorldEnvironmentTime.time = time
	SD_WorldEnvironmentTime.day = day
	SD_WorldEnvironmentTime.month = month
	SD_WorldEnvironmentTime.year = year
	
	
	if Engine.is_editor_hint():
		if cycle_in_editor:
			cycle()
	else:
		cycle()
	
	
	_on_sync_timer_timeout()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if cycle_in_editor:
			cycle()
	else:
		cycle()

func cycle(update_time: bool = true) -> void:
	var delta: float = get_process_delta_time()
	
	if update_time: time += (cycle_speed * cycle_speed_multiplier) * delta
	
	if time > 1.0:
		day += 1
		time = 0.0
	
	if animation_player and lighting:
		animation_player.play("cycle")
		animation_player.seek(animation_seek_multiplier * time, true)
		

func set_lighting(enabled: bool) -> void:
	lighting = enabled
	if animation_player:
		animation_player.stop()
	
	if moon: moon.visible = lighting
	if sun: sun.visible = lighting
	

func _on_sync_timer_timeout() -> void:
	if Engine.is_editor_hint():
		return
	
	SD_Multiplayer.request_and_sync_vars_from_server(self, [
		"time",
		"day",
		"month",
		"year",
	])
