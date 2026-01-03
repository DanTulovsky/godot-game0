extends Area2D

@export var movement_speed: float = 650.0
@export var is_player = false
var screen_size: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player:
		var direction: Vector2 = Vector2.ZERO
		var velocity: Vector2 = Vector2.ZERO

		if Input.is_action_pressed("ui_up"):
			direction = Vector2.UP
		if Input.is_action_pressed("ui_down"):
			direction = Vector2.DOWN

		velocity = direction * movement_speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
