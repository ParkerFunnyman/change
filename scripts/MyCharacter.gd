extends CharacterBody2D

const SPEED = 300.0  # Max slope speed
const JUMP_VELOCITY = -400.0
const WHEEL_RADIUS = 16.0
const FLAT_FRICTION = 200.0  # Controls how quickly the ball slows on flat ground

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# Jump input
	if Input.is_action_just_pressed("click") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	if is_on_floor():
		var floor_normal = get_floor_normal()

		# Check if on a slope
		if abs(floor_normal.angle_to(Vector2.UP)) > 0.0001:
			# Compute slope direction and roll automatically
			var slope_direction = Vector2(floor_normal.y, -floor_normal.x).normalized()

			# Apply slope-rolling force
			var gravity_strength = get_gravity().y
			var slope_acceleration = slope_direction * gravity_strength * delta
			velocity -= slope_acceleration * 15.0

			# Clamp max speed
			if velocity.length() > SPEED:
				velocity = velocity.normalized() * SPEED
		else:
			# Flat ground — apply smooth friction
			if abs(velocity.x) < 5.0:
				velocity.x = 0.0
			else:
				velocity.x = move_toward(velocity.x, 0, FLAT_FRICTION * delta)
	else:
		# In air — basic directional control
		velocity.x = direction * SPEED
		velocity.y += get_gravity().y * delta

	# Store position before move
	var prev_position = position

	# Move the character
	move_and_slide()

	# Rotate sprite based on actual movement
	var movement_delta = position - prev_position
	var distance = movement_delta.length()

	if distance > 0.5:  # Prevent jittery rotation on near-zero motion
		var direction_sign = sign(movement_delta.x)
		sprite.rotation += direction_sign * (distance / WHEEL_RADIUS * 0.5)
