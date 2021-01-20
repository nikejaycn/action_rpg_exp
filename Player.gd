extends KinematicBody2D


# Called when the node enters the scene tree for the first time.
var ACCELERATION = 500
var MAX_SPEED = 80
var FRICTION = 600

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	var input_velocity = Vector2.ZERO
	# 最终的结果是 0 - 1 或者 1 - 0（取决于哪个按键被按下）
	input_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_velocity = input_velocity.normalized()

	if input_velocity != Vector2.ZERO:
		# velocity += input_velocity * ACCELERATION * delta
		# velocity = velocity.clamped(MAX_SPEED * delta)
		animationTree.set("parameters/Idle/blend_position", input_velocity)
		animationTree.set("parameters/Run/blend_position", input_velocity)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_velocity * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
