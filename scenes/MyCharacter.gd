extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WHEEL_RADIUS = 16.0

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Jump
	if Input.is_action_just_pressed("click") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	if is_on_floor():
		if direction != 0:
			var floor_normal := get_floor_normal()
			var slope_direction := Vector2(floor_normal.y, -floor_normal.x).normalized()

			# Ensure slope direction matches input direction
			if sign(slope_direction.x) != sign(direction):
				slope_direction = -slope_direction

			velocity = slope_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# Air movement
		velocity.x = direction * SPEED

	# Move and rotate
	var prev_position = position
	move_and_slide()
	var movement_delta = position - prev_position
	var distance = movement_delta.length()
	var direction_sign = sign(movement_delta.x)
	sprite.rotation += direction_sign * (distance / WHEEL_RADIUS) * 0.5
