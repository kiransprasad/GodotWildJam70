extends CharacterBody2D

@onready var Animator = $AnimatedSprite2D
@onready var Camera = $Node/Camera2D

var walkSpeed = 75
var runSpeed = 200
var isRunning = false
var playerState = "idle"

var cameraTargetPosition = self.position
var cameraTargetZoom = Vector2(1.5, 1.5)

var isInside = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if not isInside:
		cameraTargetPosition = self.position
	
	Camera.targetPosition = cameraTargetPosition
	Camera.targetZoom = cameraTargetZoom
	
	
	if Input.is_action_just_pressed("SPRINT"):
		isRunning = !isRunning
	
	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN").normalized()
	
	if direction.x == 0 and direction.y == 0:
		playerState = "idle"
	elif direction.x != 0 or direction.y != 0:
		if isRunning:
			playerState = "run"
		else:
			playerState = "walk"
	
	velocity = direction * (runSpeed if isRunning else walkSpeed)
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
	self.z_index = 2
	cameraTargetPosition = cabinPos
	cameraTargetZoom = Vector2(8, 8)
	isInside = true
	
func go_outside():
	self.z_index = 0
	cameraTargetPosition = self.position
	cameraTargetZoom = Vector2(1.5, 1.5)
	isInside = false
	
