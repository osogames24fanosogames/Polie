extends ParallaxLayer

var a = 0
var paused2 = false

func _process(delta):
	if !paused2:
		a += delta
		motion_offset.x += delta * 16
		if motion_offset.x > 8:
			motion_offset.x = 0
		motion_offset.y = cos(a) * 4

func _on_KinematicBody2D_pause(paused):
	paused2 = paused
	for child in get_children():
		if child is AnimatedSprite:
			child.playing = !paused
