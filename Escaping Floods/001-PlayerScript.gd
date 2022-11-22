extends KinematicBody2D

const GRAVITY = 10
const JUMPSPEED = 235
const FLOOR = Vector2(0, -1)
const SAFE = 0.2

var velocity = Vector2.ZERO
var speed = 100;
var jumped = false
var timer = false
var paused = false

# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	$AS.animation = "idle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !paused:
		velocity.y += GRAVITY
		velocity.x = (int(Input.is_action_pressed("left")) * -speed) + (int(Input.is_action_pressed("right")) * speed)
		print(int($detector.is_colliding()))
		if $detector.is_colliding():
			velocity.y -= velocity.y * 2
	if is_on_floor():
		jumped = false
		velocity.y = 0
	if !jumped && !is_on_floor():
		if !timer:
			timer = true
			$safeFrames.start()
		else:
			if !$safeFrames.time_left > 0:
				jumped = true
	if Input.is_action_pressed("jump") && !jumped:
		jumped = true
		velocity.y = -JUMPSPEED
		$AS.animation = "jumpstart"
		$AS.frame = 0
	$AS.flip_h = velocity.x < 0
	if !jumped:
		if velocity.x != 0:
			$AS.animation = "run"
		else:
			$AS.animation = "idle"
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		if paused:
			$Camera2D/pause/AnimationPlayer.play("load")
	if !paused:
		move_and_slide(velocity, FLOOR)
	$Camera2D/pause.visible = paused
	$AS.playing = !paused


func _on_AnimatedSprite_animation_finished():
	if $AS.animation == "jumpstart":
		$AS.animation = "jumploop"
