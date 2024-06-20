extends CanvasModulate

@export var gradient:GradientTexture1D

func tick(time:float):
	var value = (sin(time - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
