class_name Player extends CharacterBody2D

const SPEED = 1000.0  # Max rolling speed
const JUMP_VELOCITY = -800.0
const WHEEL_RADIUS = 32.0
const FLAT_FRICTION = 00.0  # Smooth deceleration force

var lives := 5

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# Handle jumping
	if Input.is_action_just_pressed("click") and is_on_floor():
		velocity.y = JUMP_VELOCITY + velocity.y

	var direction := Input.get_axis("left", "right")

	if is_on_floor():
		var floor_normal = get_floor_normal()
		var angle_from_up = abs(floor_normal.angle_to(Vector2.UP))
		if angle_from_up > 0.001:
			# We are on a slope — compute slope direction
			var slope_dir = Vector2(floor_normal.y, -floor_normal.x).normalized()

			# Apply force downhill
			var gravity_force = get_gravity().y
			velocity -= slope_dir * gravity_force * delta

			# Clamp speed
			if velocity.length() > SPEED:
				velocity = velocity.normalized() * SPEED
		else:
			# Flat ground — apply friction
			velocity.x = move_toward(velocity.x, 0, FLAT_FRICTION * delta)
	else:
		# In air — control and gravity
		velocity.x = direction * SPEED
		velocity.y += get_gravity().y * delta

	# Store position before moving
	var prev_position = position

	# Move the character
	move_and_slide()

	# Rotate sprite based on real movement
	var movement_delta = position - prev_position
	var distance = movement_delta.length()

	if distance > 0.1:
		var direction_sign = sign(movement_delta.x)
		sprite.rotation += direction_sign * (distance / WHEEL_RADIUS)
