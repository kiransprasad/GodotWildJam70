extends Node2D

var photoTexture = null;
var focus = ""

@onready var PhotoSprite = $PhotoSprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(PhotoSprite.texture)
	if !PhotoSprite.texture:
		PhotoSprite.texture = photoTexture
