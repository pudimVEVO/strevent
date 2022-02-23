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
var speed = 7
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
	

#remake the fire fucking function it is causing a lotta problems and shit

#func fire():
#	if Input.is_action_just_pressed("fire1"):
#		if magammo > 0:
#			magammo -= 1
#			emit_signal("changed_ammo", magammo)
#			var b = b_decal.instance()
#			raycast.get_collider().add_child(b)
#			b.global_transform.origin = raycast.get_collision_point()
#			b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
#			if not anim_player.is_playing():
#				sfxgun.play()
#				camera.translation = lerp(camera.translation, 
#						Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 
#						rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
#				if raycast.is_colliding():
#					var target = raycast.get_collider()
#					if target.is_in_group("Enemy"):
#						target.health -= damage
#			anim_player.play("fireglock")
#
#		else:
#			sfxemptygun.play()
#	else:
#		camera.translation = Vector3()
#		anim_player.stop()

func reload():
	pass

func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
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
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)


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














