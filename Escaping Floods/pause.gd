extends Control

const tabs = ["Settings", "Volume"]
var tabTag = 1
var pause = false

func _process(_delta):
	if pause:
		if Input.is_action_just_released("left"):
			tabTag -= 1
		if Input.is_action_just_released("right"):
			tabTag += 1
		if tabTag > tabs.size():
			tabTag = 1
		if tabTag < 1:
			tabTag = tabs.size()
		for panel in $capa2.get_children():
			panel.visible = false
			if panel.name == tabs[tabTag-1]:
				panel.visible = true
			get_node("option-tab").text = tabs[tabTag-1]

func _on_KinematicBody2D_pause(paused):
	pause = paused
