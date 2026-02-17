class_name AltarServer extends CharacterBody2D


@onready var anim = $AnimatedSprite2D
@export var speed = 10
var prev_anim = "stand_down"
var anim_play = "stand_down"
var inventory = ""
var genuflected = false
var genuflecting = false
var stop = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!stop):
		# Get input pressed and set velocity and animation
		if Input.is_action_pressed("ui_up"):
			velocity = Vector2(0, -speed)
			anim_play = "walk_up"
		elif Input.is_action_pressed("ui_down"):
			velocity = Vector2(0, speed)
			anim_play = "walk_down"
		elif Input.is_action_pressed("ui_left"):
			velocity = Vector2(-speed, 0)
			anim_play = "walk_left"
		elif Input.is_action_pressed("ui_right"):
			velocity = Vector2(speed, 0)
			anim_play = "walk_right"
		else:
			velocity = Vector2(0, 0)
		# Get input released and set animation
		if Input.is_action_just_released("ui_up"):
			anim_play = "stand_up"
		elif Input.is_action_just_released("ui_down"):
			anim_play = "stand_down"
		elif Input.is_action_just_released("ui_left"):
			anim_play = "stand_left"
		elif Input.is_action_just_released("ui_right"):
			anim_play = "stand_right"
		else:
			pass
		move_and_collide(velocity * delta)
		anim.play(anim_play)
		prev_anim = anim_play
	else:
		if Input.is_action_just_pressed("genuflect"):
			genuflecting = true
		else:
			move_and_collide(Vector2(0, 0))
		if genuflecting:
			anim.play("genuflect")
			await get_tree().create_timer(2.0).timeout
			anim.stop()
			anim.play("stand_up")
			genuflected = true
			genuflecting = false
			stop = false
