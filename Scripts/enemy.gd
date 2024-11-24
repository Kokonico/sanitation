extends CharacterBody2D
@onready var attack_zone: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var pathfinder: NavigationAgent2D = $Pathfinder

var following
var target
var in_attack_radius
@export var health = 100
@export var SPEED = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if following and not in_attack_radius:
		follow(target)
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		target = body
		following = true
	
func follow(target) -> void:
	var direction = Vector2(target.position-position).normalized()
	velocity = direction * SPEED


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		following = false


func _on_attack_range_body_entered(body: Node2D) -> void:
	in_attack_radius = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	in_attack_radius = false
