extends Sprite2D

const MIN = 64
const XMAX = 1088
const YMAX = 584

var photosArray = Array()

const UI_Photo = preload("res://Scenes/UI/Elements/ui_photo.tscn")

func _input(event):
	if event is InputEventMouseMotion:
		var mPos = get_global_mouse_position()
		self.position = Vector2(clamp(mPos.x, MIN, XMAX), clamp(mPos.y, MIN, YMAX))
	
func takePhoto():
	var capture = get_viewport().get_texture().get_image().get_region(Rect2(position.x - 64, position.y - 64, 128, 128))
	var photoTexture = ImageTexture.create_from_image(capture)
	
	var newPhoto = UI_Photo.instantiate()
	newPhoto.position = Vector2(XMAX/2 + photosArray.size() * 64, YMAX/3 + photosArray.size() * 64)
	newPhoto.photoTexture = photoTexture
	add_sibling(newPhoto)
	
	photosArray.append(newPhoto)
