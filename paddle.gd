extends CharacterBody2D

@export var speed: float = 650.0
@export var is_player: bool = false
@export var rotation_speed: float = 1.5

var rotation_direction: float = 0.0
var screen_size: Vector2
var ball: CharacterBody2D
var ai_target_rotation_direction: float = 0.0
var ai_rotation_change_timer: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# Find the ball node using the "ball" group
	ball = get_tree().get_first_node_in_group("ball") as CharacterBody2D

	# Initialize AI rotation timer to a random value so it doesn't trigger immediately
	if not is_player:
		ai_rotation_change_timer = randf_range(1.0, 3.0)
		ai_target_rotation_direction = randf_range(-1.0, 1.0)


func _physics_process(delta):
	if is_player:
		var direction = 0

		if Input.is_action_pressed("ui_up"):
			direction = -1
		elif Input.is_action_pressed("ui_down"):
			direction = 1

		rotation_direction = Input.get_axis("ui_left", "ui_right")
		rotation += rotation_direction * rotation_speed * delta
		rotation = clamp(rotation, -0.3, 0.3)

		velocity.y = direction * speed
	else:
		# AI: Move towards the ball's Y position
		# Re-find ball if it was destroyed and recreated
		if not is_instance_valid(ball):
			ball = get_tree().get_first_node_in_group("ball") as CharacterBody2D

		if ball:
			var ball_y = ball.position.y
			var paddle_y = position.y
			var difference = ball_y - paddle_y

			# Calculate velocity proportional to distance for smooth movement
			# This creates smooth acceleration and deceleration
			var target_velocity = difference * 2.0  # Adjust multiplier for responsiveness
			velocity.y = clamp(target_velocity, -speed, speed)

			# AI: Smooth random rotation
			ai_rotation_change_timer -= delta
			if ai_rotation_change_timer <= 0.0:
				# Change target direction every 1-3 seconds
				ai_target_rotation_direction = randf_range(-1.0, 1.0)
				ai_rotation_change_timer = randf_range(1.0, 3.0)

			# Smoothly interpolate rotation direction towards target
			rotation_direction = lerp(rotation_direction, ai_target_rotation_direction, delta * 2.0)
			rotation += rotation_direction * rotation_speed * delta
			rotation = clamp(rotation, -0.3, 0.3)
		else:
			# No ball found, stop moving
			velocity.y = 0

	# Use move_and_slide() - paddles won't be pushed by the ball
	move_and_slide()
