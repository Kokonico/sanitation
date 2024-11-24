extends Area2D

var following
var target
var health
@export var SPEED = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = int(randf_range(1, 3))
	print(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if following:
		follow(target)


func _on_area_2d_body_entered(body: Node2D) -> void:
	target = body
	following = true
	
func follow(target) -> void:
	var direction = Vector2(target.position-position).normalized()
	position += direction * SPEED


func _on_area_2d_body_exited(body: Node2D) -> void:
	following = false

func hurt(dmg):
	health -= dmg
	if health <= 0:
		health = 0
		queue_free()
