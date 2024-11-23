extends CharacterBody2D


const TILES_PER_MOVEMENT = 1000

func _process(delta):
	if Input.is_action_pressed("move-up"):
		position.y -= TILES_PER_MOVEMENT * delta
	if Input.is_action_pressed("move-down"):
		position.y += TILES_PER_MOVEMENT * delta
	if Input.is_action_pressed("move-left"):
		position.x -= TILES_PER_MOVEMENT * delta
	if Input.is_action_pressed("move-right"):
		position.x += TILES_PER_MOVEMENT * delta
	
