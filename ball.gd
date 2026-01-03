extends AnimatableBody2D

var angular_speed: float = 20
var direction: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += angular_speed * delta
	var velocity: Vector2 = Vector2.RIGHT * 1000 * direction
	position += velocity * delta

func _on_start_button_pressed():
	print("button pressed")
	set_process(true)

func _unhandled_key_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		set_process(true)


func _on_paddle_body_shape_entered(body_rid: RID, body: AnimatableBody2D, body_shape_index: int, local_shape_index: int):
	var collision_angle: float = get_collision_angle(body, body_shape_index, local_shape_index)
	print(collision_angle)

	direction = direction * -1

func get_collision_angle(body: AnimatableBody2D, body_shape_index: int, local_shape_index: int) -> float:
	# Get paddle's collision shape bounds
	var paddle_shape: Shape2D = body.shape_owner_get_shape(body.shape_find_owner(body_shape_index), body_shape_index)
	var paddle_rect: Rect2 = paddle_shape.get_rect()

	# Transform to world space
	var paddle_transform: Transform2D = body.global_transform
	var paddle_world_rect: Rect2 = paddle_transform * paddle_rect

	# Ball's current position
	var ball_pos: Vector2 = global_position

	# Calculate collision point (where ball intersects paddle edge)
	var collision_point: Vector2
	if ball_pos.x < paddle_world_rect.position.x:  # Ball hit left edge
		collision_point = Vector2(paddle_world_rect.position.x, ball_pos.y)
	else:  # Ball hit right edge
		collision_point = Vector2(paddle_world_rect.position.x + paddle_world_rect.size.x, ball_pos.y)

	# Calculate angle from ball's approach direction
	var approach_angle: float = (collision_point - ball_pos).angle()

	return approach_angle
