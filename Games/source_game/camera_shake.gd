class_name CameraShake extends Node3D

@export_group("Setup")
@export var player: CharacterBody3D # Убедитесь, что это ссылка на ваш главный узел игрока
@export var viewmodel_root: Node3D # Ссылка на SourceViewModelRoot3D
@export var camera_node: W_FPCSourceLikeCamera # Ссылка на родительский узел Camera3D

@export_group("Settings")
@export var snappiness: float = 15.0 # Резкость удара
@export var return_speed: float = 8.0 # Скорость возврата позиционного кика

@export_group("Recoil Values")
@export var recoil_vertical: float = 0.1 # Подброс вверх за выстрел (в радианах или градусах, лучше в рад)
@export var recoil_horizontal: float = 0.05 # Разброс по горизонтали
@export var recoil_kickback: float = 0.1 # Отдача позиции (назад)

@export_group("ViewModel Bob/Sway")
@export var bob_frequency: float = 2.0
@export var bob_amplitude_x: float = 0.01
@export var bob_amplitude_y: float = 0.02
@export var crouch_offset:Vector3 = Vector3(0.0, 0.05, 0.05)

var time_elapsed: float = 0.0
var target_position: Vector3
var current_position: Vector3

# В Rust отдача накапливается и не возвращается сама
var accumulated_recoil_pitch: float = 0.0 
var accumulated_recoil_yaw: float = 0.0

func _ready() -> void:
	# Убедимся, что компонент может ловить ввод, если нужно
	set_process_input(true) 
	SD_Components.append_to(player, self) # ваша логика привязки
	if viewmodel_root == null:
		viewmodel_root = $SourceViewModelRoot3d # Попытка найти автоматически

func _input(event: InputEvent) -> void:
	# Этот компонент перехватывает ввод мыши, 
	# чтобы отслеживать компенсацию игрока
	if event is InputEventMouseMotion:
		# Игрок двигает мышь, компенсируя отдачу
		# Мы регистрируем это движение, чтобы отделить его от "автоматической" отдачи
		if accumulated_recoil_pitch != 0:
			# Это очень сложно сделать без доступа к логике поворота камеры игрока.
			# Если игрок использует стандартный FPS контроллер, 
			# он уже обрабатывает ввод. 
			# Лучшее, что можно сделать без изменения Player.gd:
			pass 

func _process(delta: float) -> void:
	handle_crouch()
	handle_bobbing(delta)
	
	# Позиционный кик (возвращается сам)
	target_position = target_position.lerp(Vector3.ZERO, return_speed * delta)
	current_position = current_position.lerp(target_position, snappiness * delta)
	
	# Применяем позицию к нашему узлу CameraShake
	# (Bobbing уже модифицирует position.x и position.y)
	position.z = current_position.z
	

func apply() -> void:
	var pitch_offset = recoil_vertical * randf_range(0.8, 1.2)
	var yaw_offset = recoil_horizontal * randf_range(-1.0, 1.0)
	
	if camera_node:
		camera_node.rotate_x(pitch_offset)
		player.rotate_y(yaw_offset) 

func handle_bobbing(delta: float) -> void:
	if player and player.is_on_floor():
		var speed = player.velocity.length()
		if speed > 0.1:
			time_elapsed += delta * speed * bob_frequency
			var bob_x = sin(time_elapsed) * bob_amplitude_x
			var bob_y = abs(cos(time_elapsed)) * bob_amplitude_y
			
			# Применяем покачивание к viewmodel_root
			if viewmodel_root:
				position.x = bob_x
				position.y = bob_y + (crouch_offset.y if is_crouching else 0)
			return

	if is_crouching:
		position = position.lerp(
			crouch_offset,
			delta * 15.0
		)
	else:
		position = position.lerp(
			Vector3.ZERO,
			delta * 15.0
		)
	time_elapsed = 0.0

var is_crouching: bool = false # Предполагаем, что вы как-то устанавливаете эту переменную

func handle_crouch() -> void:
	var comp:W_FPCSourceLikeMovement = SD_Components.find_first(player, W_FPCSourceLikeMovement)
	is_crouching = comp.is_crouched
