extends CharacterBody2D

@onready var Animator = $AnimatedSprite2D
@onready var Camera = $Node/Camera2D
@onready var PhotoFrame = $Canvas/PhotoFrame
@onready var scArea = $Scare/CollisionShape2D

# var PhotoScene = load("res://Scenes/UI/Elements/ui_photo.tscn");

var walkSpeed = 75
var runSpeed = 150
var isRunning = false
var playerState = "idle"

var cameraTargetPosition = self.position
var cameraTargetZoom = Vector2(1.5, 1.5)

var isInside = false
var interactObject = null

var isTakingPhoto = false
var isInventoryOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if not isInside:
		cameraTargetPosition = self.position
		
	if isTakingPhoto:
		var mousePos = get_viewport().get_mouse_position()
	
	Camera.targetPosition = cameraTargetPosition
	Camera.targetZoom = cameraTargetZoom
	
	if Input.is_action_just_pressed("INVENTORY"):
		isInventoryOpen = !isInventoryOpen
		isTakingPhoto = false
		PhotoFrame.visible = false
	if Input.is_action_just_pressed("CAMERA") and !isInside and !isInventoryOpen:
		isTakingPhoto = !isTakingPhoto
		PhotoFrame.visible = isTakingPhoto
	if Input.is_action_just_pressed("INTERACT"):
		if interactObject:
			print(interactObject)
	if Input.is_action_just_pressed("CLICK"):
		if isInventoryOpen:
			pass
		elif isTakingPhoto:
			PhotoFrame.takePhoto()
			isTakingPhoto = false
			PhotoFrame.visible = false
	if Input.is_action_just_pressed("SPRINT"):
		isRunning = !isRunning

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN").normalized()
	
	if direction.x == 0 and direction.y == 0:
		scArea.shape.radius = 0
		playerState = "idle"
	elif direction.x != 0 or direction.y != 0:
		scArea.shape.radius = 200 if isRunning else 75
		if isRunning:
			playerState = "run"
		else:
			playerState = "walk"
	
	velocity = direction * (runSpeed if isRunning and !isTakingPhoto else walkSpeed)
	move_and_slide()
	
	play_anim(direction)

func play_anim(direction):
	if playerState == "idle":
		Animator.play(playerState)
	if playerState == "walk" or playerState == "run":
		if direction.x:
			Animator.set_flip_h(direction.x < 0)
		Animator.play(playerState)
		
func go_inside(cabinPos):
	isTakingPhoto = false
	PhotoFrame.visible = false
	self.position.y -= 5
	self.z_index = 2
	cameraTargetPosition = cabinPos
	cameraTargetZoom = Vector2(8, 8)
	self.scale = Vector2(0.5, 0.5)
	isInside = true
	
func go_outside():
	self.position.y += 5
	self.z_index = 0
	cameraTargetPosition = self.position
	cameraTargetZoom = Vector2(1.5, 1.5)
	self.scale = Vector2(1, 1)
	isInside = false

func _on_scare_body_entered(body):
	if body.is_in_group("Animal"):
		body.scare(self.position)
