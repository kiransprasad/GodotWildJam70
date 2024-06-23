extends CanvasLayer

@onready var Report = $UI_Report
#@onready var Letter = $UI_Letter
@onready var Photos = $Photos
@onready var Watch = $UI_Watch
@onready var DeleteBin = $UI_DeleteBin

var isFieldInventory : bool = false
var isDeskInventory : bool = false
var isMailboxInventory : bool = false

func setFieldInventoryShown(isShown : bool):
	isFieldInventory = isShown
	if !isDeskInventory and !isMailboxInventory:
		for photo in Photos.get_children():
			photo.setShown(isShown)
		Watch.setShown(isShown)
		DeleteBin.visible = isShown

func setDeskInventoryShown(isShown : bool):
	isDeskInventory = isShown
	Report.setShown(isShown)
	for photo in Photos.get_children():
		photo.setShown(isShown, true)
	Watch.setShown(false)
	DeleteBin.visible = true

func setMailboxInventoryShown(isShown : bool):
	isMailboxInventory = isShown
	#Letter.setShown(isShown)
	for photo in Photos.get_children():
		photo.setShown(isShown)
	Watch.setShown(false)
	DeleteBin.visible = true
