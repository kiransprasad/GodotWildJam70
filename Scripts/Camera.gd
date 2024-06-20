extends Camera2D

var targetPosition = self.position
var targetZoom = self.zoom

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = targetPosition
	self.zoom = lerp(self.zoom, targetZoom, min(0.1, delta + self.zoom.distance_to(targetZoom)))
