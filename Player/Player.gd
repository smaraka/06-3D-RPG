extends KinematicBody

onready var Camera = get_node("/root/Game/Player/Pivot/Camera")
onready var Ray = $Pivot/RayCast

var velocity = Vector3()
var gravity = -9.8
var speed = 0.5
var max_speed = 4
var sens = 0.002


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	var target = Ray.get_collider()
	velocity.y += gravity * _delta
	var falling = velocity.y
	velocity.y = 0 
	var desired_velocity = get_input() * speed
	if desired_velocity.length():
		velocity += desired_velocity
	else:
		velocity *= 0.9
	var current_speed = velocity.length()
	velocity = velocity.normalized() * clamp(current_speed, 0, max_speed)
	velocity.y = falling
	
	$AnimationTree.set("parameters/Idle_Run/blend_amount", current_speed/max_speed)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if Input.is_action_just_pressed("shoot") and target != null:
		target.queue_free()


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sens)

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir -= Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir -= Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
