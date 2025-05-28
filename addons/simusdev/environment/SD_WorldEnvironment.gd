@tool
extends WorldEnvironment
class_name SD_WorldEnvironment

static var _instance: SD_WorldEnvironment

static var instance: SD_WorldEnvironment :
	get:
		return _instance

func _init() -> void:
	_instance = self

@onready var sky: CloudSky = environment.sky

@export var cycle_speed: float = 0.1
@export var cycle_in_editor: bool = false

signal date_changed()

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

@export var animation_player: AnimationPlayer

@export var sun_color: Color = Color.WHITE:
	set(value):
		sun_color = value
		if sky:
			sky.sunColor = sun_color

@export var sun_energy: float = 1.0:
	set(value):
		sun_energy = value
		if sky:
			sky.sunEnergy = sun_energy

@export var sun_angles: Vector2 = Vector2.ZERO:
	set(value):
		sun_angles = value
		if sky:
			sky.sunAngles = sun_angles

@export var sun_size: float = 1.0:
	set(value):
		sun_size = value
		if sky:
			sky.sunDiskSize = sun_size



func _ready() -> void:
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
	
	if update_time: time += delta * cycle_speed
	
	if time > 1.0:
		day += 1
		time = 0.0
	
	if animation_player:
		animation_player.play("cycle")
		animation_player.seek(time, true)
		


func _on_sync_timer_timeout() -> void:
	if Engine.is_editor_hint():
		return
	
	SD_Multiplayer.request_and_sync_vars_from_server(self, ["time", "day", "month", "year"])
