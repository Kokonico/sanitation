extends Area2D

var following
var target
@export var health = 100
@export var SPEED = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if following:
		follow(target)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		target = body
		following = true
	
func follow(target) -> void:
	var direction = Vector2(target.position-position).normalized()
	position += direction * SPEED


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		following = false
