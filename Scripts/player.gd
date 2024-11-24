extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $physicsbox
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var attackCollisionArea: CollisionPolygon2D = $AttackArea/CollisionPolygon2D
@onready var health_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar

@export var health: int = 5

@onready var walk: AudioStreamPlayer = $Walk
@onready var dash: AudioStreamPlayer = $Dash
@onready var slash: AudioStreamPlayer = $Slash


const IS_PLAYER = true
const MAX_HP = 5
const SPEED = 1000.0
const SPEED_CAP = 1000.0
const FRACTION_FORCE = 100
const DAMAGE = 1
var direction = Vector2.ZERO
var sliding = false
var has_y_input = false
var has_x_input = false
var enemyCount = 0

var is_dead = false


var last_direction = Vector2.ZERO

func _ready() -> void:
	health_bar.value = health
	health_bar.max_value = MAX_HP
	attackCollisionArea.disabled = true

func _physics_process(delta):
	var direction = Vector2.ZERO
	var has_input = false
	has_y_input = false
	has_x_input = false
	
	if abs(velocity.x) <= SPEED_CAP and abs(velocity.y) <= SPEED_CAP:
		if sliding:
			sliding = false
			dash.stop()
	
	if not is_dead:
		
		if Input.is_action_pressed("move-up"):
			direction.y -= 1
			has_input = true
			has_y_input = true
		if Input.is_action_pressed("move-down"):
			direction.y += 1
			has_input = true
			has_y_input = true
		if Input.is_action_pressed("move-left"):
			scale.y = -1
			rotation = PI
			direction.x -= 1
			has_input = true
			has_x_input = true
		if Input.is_action_pressed("move-right"):
			scale.y = 1
			rotation = 0
			direction.x += 1
			has_input = true
			has_x_input = true
			
		if Input.is_action_just_pressed("attack"):
			has_input = true
			attack()
		
		direction = direction.normalized()
		if direction != Vector2.ZERO:
			last_direction = direction
		
		# self.rotation = direction.angle()
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
		
		if not has_input and last_direction == Vector2(-1, 0):
			rotation = PI
		
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
		
		# anims driver
		if sliding:
			if not dash.playing:
				dash.play()
		elif has_input:
			if not walk.playing:
				walk.play()
		else:
			walk.stop()
	
	
func hurt(dmg):
	health -= dmg
	health_bar.value = health
	if health <= 0 and not is_dead:
		health = 0
		is_dead = true
		velocity = Vector2.ZERO
		animator.play("death")
		await animator.animation_finished
		get_tree().reload_current_scene()
	
func attack() -> void:
	animator.play("attack")
	slash.play()
	attackCollisionArea.disabled = false
	await animator.animation_finished
	attackCollisionArea.disabled = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.get("hurt"):
		body.hurt(DAMAGE, direction)
