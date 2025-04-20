class_name Player
extends CharacterBody2D

const SPEED = 800.0  # Max rolling speed
const JUMP_VELOCITY = -800.0
const WHEEL_RADIUS = 32.0
const FLAT_FRICTION = 250.0

# Coyote time (allows jump slightly after leaving ground)
var coyote_time := 0.2
var coyote_timer := 0.0

# Jump buffer (allows jump slightly before hitting ground)
var jump_buffer_time := 0.1
var jump_buffer_timer := 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# COYOTE TIME: Refresh if on floor
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# JUMP BUFFER: Set buffer when jump is pressed
	if Input.is_action_just_pressed("space"):
		jump_buffer_timer = jump_buffer_time

	jump_buffer_timer -= delta

	# HANDLE JUMPING
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY + velocity.y
		coyote_timer = 0.0
		jump_buffer_timer = 0.0

	# DIRECTIONAL INPUT
	var direction := Input.get_axis("left", "right")

	# SLOPE AND FRICTION HANDLING
	if is_on_floor():
		var floor_normal = get_floor_normal()
		var angle_from_up = abs(floor_normal.angle_to(Vector2.UP))
		if angle_from_up > 0.001:
			# Slope logic
			var slope_dir = Vector2(floor_normal.y, -floor_normal.x).normalized()
			var gravity_force = get_gravity().y
			velocity -= slope_dir * gravity_force * delta

			if velocity.length() > SPEED:
				velocity = velocity.normalized() * SPEED
		else:
			# Flat ground
			velocity.x = move_toward(velocity.x, 0, FLAT_FRICTION * delta)
	else:
		# In air movement and gravity
		velocity.x = direction * SPEED
		velocity.y += get_gravity().y * delta

	# MOVE
	move_and_slide()

	# ROTATION BASED ON MOVEMENT
	var movement_delta = velocity * delta
	var distance = movement_delta.length()

	if abs(velocity.x) > 1 and distance > 1.0:
		var direction_sign = sign(velocity.x)
		sprite.rotation += direction_sign * (distance / WHEEL_RADIUS)
