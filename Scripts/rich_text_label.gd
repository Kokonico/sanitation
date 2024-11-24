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
			await get_tree().create_timer(6).timeout
			visible = false
