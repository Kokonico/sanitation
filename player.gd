extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


const SPEED = 1000.0
const SPEED_CAP = 1000.0
const FRACTION_FORCE = 100
var directions = []
var direction = 0
var sliding = false

var last_direction = Vector2.ZERO

func _physics_process(delta):
	var direction = Vector2.ZERO
	var has_input = false
	
	if abs(velocity.x) == 0 and abs(velocity.y) == 0:
		sliding = false
	
	if Input.is_action_pressed("move-up"):
		direction.y -= 1
		has_input = true
	if Input.is_action_pressed("move-down"):
		direction.y += 1
		has_input = true
	if Input.is_action_pressed("move-left"):
		direction.x -= 1
		has_input = true
	if Input.is_action_pressed("move-right"):
		direction.x += 1
		has_input = true
	
	if has_input and not sliding:
		direction = direction.normalized()
		self.rotation = direction.angle()
		velocity += direction * SPEED
		if abs(velocity.x) > SPEED_CAP:
			velocity.x = SPEED_CAP * (1 if abs(velocity.x) == velocity.x else -1)
		if abs(velocity.y) > SPEED_CAP:
			velocity.y = SPEED_CAP * (1 if abs(velocity.y) == velocity.y else -1)
	else:
		var velx_abs = abs(velocity.x)
		var velx_dir = 1 if velx_abs == velocity.x else -1
		velocity.x = ((velx_abs - FRACTION_FORCE) if (velx_abs - FRACTION_FORCE) > 0 else 0) * velx_dir
		var vely_abs = abs(velocity.y)
		var vely_dir = 1 if vely_abs == velocity.y else -1
		velocity.y = ((vely_abs - FRACTION_FORCE) if (vely_abs - FRACTION_FORCE) > 0 else 0) * vely_dir
	
	if Input.is_action_just_pressed("dash"):
		sliding = true
		collision_shape_2d.disabled = true
		if direction == Vector2.ZERO:
			direction.x = 1
		velocity = direction * 2000
		collision_shape_2d.disabled = false
	move_and_slide()
	position += velocity * delta
	self.rotation = 0
	
