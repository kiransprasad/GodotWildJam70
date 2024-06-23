extends Sprite2D

var showCan : bool = false

func _process(delta):
	
	if showCan and self.modulate.a < 1:
		self.modulate.a += delta * 3
	elif not showCan and self.modulate.a > 0:
		self.modulate.a -= delta * 3

func _input(event):
	if event is InputEventMouseMotion:
		showCan = event.position.x < 50 and event.pressure > 0.5
