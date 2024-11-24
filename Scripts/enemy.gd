extends CharacterBody2D
@onready var attack_zone: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var pathfinder: NavigationAgent2D = $physicsbox/pathfinder
@onready var timer: Timer = $physicsbox/pathfinder/Timer
@onready var attack_timer: Timer = $AttackTimer
@onready var blood: CPUParticles2D = $CPUParticles2D
@onready var blood_effect_timer: Timer = $BloodEffectTimer

var following
var target
var in_attack_radius
var attacking = false
@export var DAMAGE = 1
@export var COOLDOWN = 1
@export var health = 500
@export var SPEED = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.wait_time = COOLDOWN
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if following:
		if not in_attack_radius:
			var dir = to_local(pathfinder.get_next_path_position()).normalized()
			velocity = dir * SPEED
		elif attacking == false:
			print("prep")
			velocity = Vector2.ZERO
			print("going for it")
			attacking = true
			attack_timer.start(COOLDOWN)
		else:
			velocity = Vector2.ZERO
			
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func makepath():
	if target != null:
		if target.get("IS_PLAYER"):
			pathfinder.target_position = target.global_position


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		target = body
		following = true

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		in_attack_radius = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		in_attack_radius = false


func _on_timer_timeout() -> void:
	makepath()

func hurt(dmg, direction):
	print("owie owie ow")
	attacking = false
	health -= dmg
	blood.emitting = true
	blood_effect_timer.start()
	velocity += direction * 100
	if health <= 0:
		health = 0
		queue_free()


func _on_attack_timer_timeout() -> void:
	if in_attack_radius and attacking:
		attacking = false
		print("attacking!!!")
		target.hurt(DAMAGE)
		attack_timer.stop()
	else:
		print(in_attack_radius)
		print(attacking)


func _on_blood_effect_timer_timeout() -> void:
	blood.emitting = false
