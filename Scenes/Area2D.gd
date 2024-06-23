extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_global_mouse_position() + Vector2(0, 8)
