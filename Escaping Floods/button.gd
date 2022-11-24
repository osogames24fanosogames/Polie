extends Area2D

export (int) var id
signal button_pressed

func _ready():
	$AnimatedSprite.animation = "normal"

func _on_button_area_entered(area):
	if area.is_in_group("player") && $AnimatedSprite.animation == "normal":
		emit_signal("button_pressed", id)
		$AnimatedSprite.animation = "press"
		$audio.play()

func _on_KinematicBody2D_dead(_dead):
	$AnimatedSprite.animation = "normal"
	emit_signal("button_pressed", id)
