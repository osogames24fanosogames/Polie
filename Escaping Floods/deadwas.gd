extends ParallaxBackground

func _on_KinematicBody2D_dead(dead):
	visible = !dead


func _on_KinematicBody2D_pause(paused):
	visible = !paused
