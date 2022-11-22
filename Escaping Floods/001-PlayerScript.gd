extends KinematicBody2D

const GRAVITY = 10
const JUMPSPEED = 235
const FLOOR = Vector2(0, -1)
const SAFE = 0.2

signal dead
signal pause

var velocity = Vector2.ZERO
var speed = 100;
var jumped = false
var timer = false
var paused = false
var dead = false
var deadConfirmable = false

# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	$AS.animation = "idle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !paused && !dead:
		velocity.y += GRAVITY
		velocity.x = (int(Input.is_action_pressed("left")) * -speed) + (int(Input.is_action_pressed("right")) * speed)
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
	if velocity.x == 0:
		pass
	else:
		$AS.flip_h = velocity.x < 0
	if !jumped:
		if velocity.x != 0:
			$AS.animation = "run"
		else:
			$AS.animation = "idle"
	if Input.is_action_just_pressed("pause") && !dead:
		paused = !paused
		emit_signal("pause", paused)
		if paused:
			$Camera2D/pause/AnimationPlayer.play("load")
	if !paused && !dead:
		move_and_slide(velocity, FLOOR)
	if dead:
		if Input.is_action_just_pressed("ui_accept") && deadConfirmable:
			$Camera2D/dead/AnimationPlayer.play("end")
			deadConfirmable = false
	$Camera2D/pause.visible = paused
	$AS.playing = !paused
	$Camera2D/dead.visible = dead


func _on_AnimatedSprite_animation_finished():
	if $AS.animation == "jumpstart":
		$AS.animation = "jumploop"

func death():
	dead = true
	deadConfirmable = false
	$Camera2D/dead/AnimationPlayer.play("deadStart")
	emit_signal("dead", dead)

func _on_death_area_entered(area):
	if area.is_in_group("inst"):
		death()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "deadStart":
		deadConfirmable = true
	if anim_name == "end":
		dead = false
		var node = get_node_or_null("spawn")
		position = node.position
		emit_signal("dead", dead)
		velocity = Vector2.ZERO
