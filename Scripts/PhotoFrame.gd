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
	var viewportImage = get_viewport().get_texture().get_image()
	var xRatio:float = viewportImage.get_width() / 1152.0
	var yRatio:float = viewportImage.get_height() / 648.0
	var capture = viewportImage.get_region(Rect2((position.x - 64) * xRatio, (position.y - 64) * yRatio, 128 * xRatio, 128 * yRatio))
	var photoTexture = ImageTexture.create_from_image(capture)
	
	var newPhoto = UI_Photo.instantiate()
	newPhoto.position = position
	newPhoto.photoScale = Vector2(xRatio, yRatio)
	newPhoto.photoTexture = photoTexture
	add_sibling(newPhoto)
	
	photosArray.append(newPhoto)
	
