extends CharacterBody2D
@onready var attack_zone: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var pathfinder: NavigationAgent2D = $physicsbox/pathfinder
@onready var timer: Timer = $physicsbox/pathfinder/Timer

var following
var target
var in_attack_radius
@export var health = 100
@export var SPEED = 500
var health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = int(randf_range(1, 3))
	print(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if following and not in_attack_radius:
		var dir = to_local(pathfinder.get_next_path_position()).normalized()
		velocity = dir * SPEED
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
	
func follow(target) -> void:
	var direction = Vector2(target.position-position).normalized()
	velocity = direction * SPEED

func _on_attack_range_body_entered(body: Node2D) -> void:
	in_attack_radius = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	in_attack_radius = false


func _on_timer_timeout() -> void:
	makepath()

func hurt(dmg):
	health -= dmg
	if health <= 0:
		health = 0
		queue_free()
