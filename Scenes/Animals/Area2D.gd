extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = unproject_position(get_parent().get_parent().position)
