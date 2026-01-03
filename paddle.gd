extends CharacterBody2D

@export var speed: float = 650.0
@export var is_player = false
var screen_size: Vector2
var ball: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# Find the ball node using the "ball" group
	ball = get_tree().get_first_node_in_group("ball") as CharacterBody2D

func _physics_process(_delta):
	if is_player:
		var direction = 0

		if Input.is_action_pressed("ui_up"):
			direction = -1
		elif Input.is_action_pressed("ui_down"):
			direction = 1

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
		else:
			# No ball found, stop moving
			velocity.y = 0

	# Use move_and_slide() - paddles won't be pushed by the ball
	move_and_slide()
