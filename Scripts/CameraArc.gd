extends Area2D

var isActive:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func takePhoto():
	var group_name = "A"
	var sprites_in_group = []
	for area in get_overlapping_areas():
		if area.is_in_group(group_name):
			sprites_in_group.push_back(area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isActive):
		look_at(get_global_mouse_position())


func setActive(active):
	isActive = active
	self.visible = active
