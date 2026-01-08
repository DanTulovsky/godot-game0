extends AIController2D

# Stores the actions sampled for the agent's policy, running in python
var vertical_action: float = 0.0 # -1.0 (down) to 1.0 (up)
var rotation_action: float = 0.0 # -1.0 (left) to 1.0 (right)

func get_obs() -> Dictionary:
	# get the balls position and velocity in the paddle's frame of reference
	var ball_pos = to_local(_player.ball.global_position)
	var ball_vel = to_local(_player.ball.velocity)
	var obs = [ball_pos.x, ball_pos.y, ball_vel.x / 10.0, ball_vel.y / 10.0]

	# todo: add observations for the paddle's own position and velocity
	# todo: add observations for the other paddle's position and velocity

	return {"obs": obs}

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {
		"vertical_action": {
			"size": 1,
			"action_type": "continuous"
		},
		"rotation_action": {
			"size": 1,
			"action_type": "continuous"
		},
	}

func set_action(action) -> void:
	vertical_action = clamp(action["vertical_action"][0], -1.0, 1.0)
	rotation_action = clamp(action["rotation_action"][0], -1.0, 1.0)
