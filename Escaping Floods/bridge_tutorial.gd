extends Node2D

func _ready():
	position = Vector2(-88, 258)

func _on_button_button_pressed(id):
	if id == 1:
		position = Vector2(-88, 16)

func _on_KinematicBody2D_dead(_dead):
	position = Vector2(-88, 258)
