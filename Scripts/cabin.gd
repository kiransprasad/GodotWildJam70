extends Node2D

@onready var Outside = $Outside
@onready var Inside = $Inside

var targetOpacity = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Outside.modulate.a < targetOpacity:
		Outside.modulate.a += delta
	elif Outside.modulate.a > targetOpacity:
		Outside.modulate.a -= delta
		
	if Outside.modulate.a > 0.95:
		Inside.visible = false
	else:
		Inside.visible = true


func _on_area_2d_body_entered(body):
	if body.name == "Ranger":
		targetOpacity = 0
		self.z_index = 1
		
		body.go_inside(self.position)

func _on_area_2d_body_exited(body):
	if body.name == "Ranger":
		targetOpacity = 1
		self.z_index = 0
		
		body.go_outside()
