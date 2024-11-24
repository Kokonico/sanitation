extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $physicsbox
@onready var health_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var attackCollisionArea: CollisionPolygon2D = $AttackArea/CollisionPolygon2D

@export var health: float = 100.0


const IS_PLAYER = true
const MAX_HP = 100.0
const SPEED = 1000.0
const SPEED_CAP = 1000.0
const FRACTION_FORCE = 100
const DAMAGE = 1
var direction = Vector2.ZERO
var sliding = false
var has_y_input = false
var has_x_input = false


var last_direction = Vector2.ZERO

func _ready() -> void:
	health_bar.value = health
	health_bar.max_value = MAX_HP
	attackCollisionArea.disabled = false

func _physics_process(delta):
	var direction = Vector2.ZERO
	var has_input = false
	has_y_input = false
	has_x_input = false
	
	if abs(velocity.x) <= SPEED_CAP and abs(velocity.y) <= SPEED_CAP:
		if sliding:
			sliding = false
	
	
	if Input.is_action_pressed("move-up"):
		direction.y -= 1
		has_input = true
		has_y_input = true
	if Input.is_action_pressed("move-down"):
		direction.y += 1
		has_input = true
		has_y_input = true
	if Input.is_action_pressed("move-left"):
		direction.x -= 1
		has_input = true
		has_x_input = true
	if Input.is_action_pressed("move-right"):
		direction.x += 1
		has_input = true
		has_x_input = true
		
	if Input.is_action_just_pressed("attack"):
		has_input = true
		attack()
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	direction = direction.normalized()
	self.rotation = direction.angle()
	if not sliding:
		velocity += direction * SPEED
		if abs(velocity.x) > SPEED_CAP:
			velocity.x = SPEED_CAP * (1 if abs(velocity.x) == velocity.x else -1)
		if abs(velocity.y) > SPEED_CAP:
			velocity.y = SPEED_CAP * (1 if abs(velocity.y) == velocity.y else -1)
	
	if not has_x_input or sliding:
		var velx_abs = abs(velocity.x)
		var velx_dir = 1 if velx_abs == velocity.x else -1
		velocity.x = ((velx_abs - FRACTION_FORCE) if (velx_abs - FRACTION_FORCE) > 0 else 0) * velx_dir
	if not has_y_input or sliding:
		var vely_abs = abs(velocity.y)
		var vely_dir = 1 if vely_abs == velocity.y else -1
		velocity.y = ((vely_abs - FRACTION_FORCE) if (vely_abs - FRACTION_FORCE) > 0 else 0) * vely_dir
	
	if animator.animation != "attack":
		if has_x_input or has_y_input:
			animator.play("run")
		elif not has_input:
			animator.play("idle")
	elif animator.animation_finished:
		animator.animation == "idle"
	
	if Input.is_action_just_pressed("dash") and not sliding:
		sliding = true
		if direction == Vector2.ZERO:
			direction = last_direction
		velocity = direction * 2500
		animator.play("dash")
	move_and_slide()
	position += velocity * delta
	
	
func hurt(dmg):
	health -= dmg
	if health <= 0:
		health = 0
		animator.play("death")
	
func attack() -> void:
	animator.play("attack")
	attackCollisionArea.disabled = false
	await animator.animation_finished
	attackCollisionArea.disabled = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.get("hurt"):
		body.hurt(DAMAGE)
