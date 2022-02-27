extends KinematicBody

#signals
signal changed_ammo(magammo)

# stats
var curHP : int = 2
var maxHP : int = 2
var ammo : int = 0
var magammo : int = 15
const SWAY = 30
const damage = 10
var holstered = false

 
# physics
var speed = 10
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var jump = 10
var gravity : float = 20.0
const MAX_CAM_SHAKE = 0.6

 
# cam look
var cam_accel = 40
var mouse_sense = 1
var snap

# vectors
var direction = Vector3()
var h_velocity = Vector3()
var h_acceleration = 6
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

# components
onready var raycast = $head/Cam/GunCast
onready var anim_player = $AnimationPlayer
onready var hand = $head/Cam/hand
onready var head = $head
onready var handloc = $head/handloc
onready var camera = $head/Cam
onready var guncam = $head/Cam/ViewportContainer/Viewport/Guncam
onready var b_decal = preload("res://scenes/BulletDecal.tscn")
onready var sfxgun = $SFXGun
onready var sfxemptygun = $SFXEmptyGun
onready var anim_tree = $AnimationTree
onready var sfxwalkingsnow = $WalkingSnow
 
func _ready():
	hand.set_as_toplevel(true)
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	#get keyboard input
	direction = Vector3()
	
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#Moving and direction
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)


func _process(delta):
	
#	fire()
	
	guncam.global_transform = camera.global_transform
	
	hand.global_transform.origin = handloc.global_transform.origin
	hand.rotation.y = lerp_angle(hand.rotation.y, rotation.y, SWAY * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x, head.rotation.x, SWAY * delta)
	
	
	
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
 
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.y, deg2rad(-89), deg2rad(89))














