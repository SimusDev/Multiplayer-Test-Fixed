extends Sprite2D

@export var speed: float = 100.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
	
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta
	
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
	
	if Input.is_action_pressed("ui_right"):
		position.x += speed * delta
