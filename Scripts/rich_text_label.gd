extends RichTextLabel

@export var y = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(get_parent().get_parent().get_parent().position.y)
	if get_parent().get_parent().get_parent().position.y < y:
		visible_characters += 1
		if visible_ratio == 1:
			if self.name == "RichTextLabel5":
				get_parent().get_parent().get_parent().get_parent().get_node("Guy1-profile").position = Vector2(11600, -9500)
				get_parent().get_parent().get_parent().position = Vector2(11600, -9750)
				get_parent().get_parent().get_parent().hurt(1000)
				get_parent().get_parent().get_parent().velocity = Vector2.ZERO
				await get_tree().create_timer(5).timeout
				get_parent().get_parent().get_parent().get_child(2).get_child(2).visible = true
			await get_tree().create_timer(1).timeout
			visible = false
