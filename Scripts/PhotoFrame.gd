extends Sprite2D

const MIN = 64
const XMAX = 1088
const YMAX = 584

var PhotosObj = null

var focusArray = Array()
var focus = null
const outlineShader = preload("res://outline.tres")

const UI_Photo = preload("res://Scenes/UI/Elements/ui_photo.tscn")

func _input(event):
	if event is InputEventMouseMotion:
		var mPos = get_global_mouse_position()
		self.position = Vector2(clamp(mPos.x, MIN, XMAX), clamp(mPos.y, MIN, YMAX))
		
	
func _process(delta):
	
	if !PhotosObj:
		PhotosObj = get_parent().get_node("Photos")
	
	var oldFocus = focus
	var minDist = 256
	
	if focusArray.size() == 0:
		focus = null
		
	var mPos = get_parent().get_parent().get_node("Node2").get_node("Area2D").position - Vector2(0, 8)
	for entity in focusArray:
		var dist = entity.position.distance_to(mPos)
		if(dist <= minDist):
			minDist = dist
			focus = entity
	
	if focus != oldFocus and oldFocus:
		oldFocus.material = null
		
	if self.visible and focus:
		focus.material = outlineShader
	
func takePhoto():
	if focus:
		focus.material = null
	
	var viewportImage = get_viewport().get_texture().get_image()
	var xRatio:float = viewportImage.get_width() / 1152.0
	var yRatio:float = viewportImage.get_height() / 648.0
	var capture = viewportImage.get_region(Rect2((position.x - 64) * xRatio, (position.y - 64) * yRatio, 128 * xRatio, 128 * yRatio))
	var photoTexture = ImageTexture.create_from_image(capture)
	
	var newPhoto = UI_Photo.instantiate()
	newPhoto.position = position
	newPhoto.focus = focus.NAME if focus else ""
	newPhoto.photoScale = Vector2(xRatio, yRatio)
	newPhoto.photoTexture = photoTexture
	
	PhotosObj.add_child(newPhoto)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Evidence") or body.is_in_group("Animal"):
		focusArray.append(body)


func _on_area_2d_body_exited(body):
	if body.is_in_group("Evidence") or body.is_in_group("Animal"):
		focusArray.erase(body)
