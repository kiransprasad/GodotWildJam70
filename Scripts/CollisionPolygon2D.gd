extends CollisionPolygon2D


func _draw() -> void:
	var godot_blue : Color = Color(1, 1, 1, 0.25)
	draw_polygon(self.polygon, [ godot_blue ])
