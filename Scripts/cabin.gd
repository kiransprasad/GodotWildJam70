extends Node2D

@onready var Outside = $Outside
@onready var Inside = $Inside
@onready var Fire = $Inside/Fire

var targetOpacity = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Outside.modulate.a < targetOpacity:
		Fire.energy = max(0, Fire.energy - delta * 2)
		Outside.modulate.a += delta
	elif Outside.modulate.a > targetOpacity:
		Fire.energy = min(1, Fire.energy + delta * 2)
		Outside.modulate.a -= delta
		
	if Outside.modulate.a > 0.95:
		Inside.visible = false
	else:
		Inside.visible = true


func _on_inside_area_body_entered(body):
	if body.name == "Ranger":
		targetOpacity = 0
		self.z_index = 1
		
		body.go_inside(self.position + Vector2(0, -30))

func _on_inside_area_body_exited(body):
	if body.name == "Ranger":
		targetOpacity = 1
		self.z_index = 0
		
		body.go_outside()


func _on_desk_area_body_entered(body):
	if body.name == "Ranger":
		body.setDeskInventory(true)

func _on_desk_area_body_exited(body):
	if body.name == "Ranger":
		body.setDeskInventory(false)

func _on_mailbox_area_body_entered(body):
	if body.name == "Ranger":
		body.setMailboxInventory(true)

func _on_mailbox_area_body_exited(body):
	if body.name == "Ranger":
		body.setMailboxInventory(false)
