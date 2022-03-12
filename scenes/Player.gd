extends KinematicBody

const MAX_CAM_SHAKE = 0.3
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
const AMMO_IN_MAG = 6

onready var accel = ACCEL_DEFAULT

var health = 3

var ammo_spare = 12
var ammo_weapon = 0

var speed = 7
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.3
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var GunCast = $head/Cam/hand/GunCast
onready var head = $head
onready var camera = $head/Cam
onready var anim_player = $head/Cam/AnimationPlayer
onready var anim_tree = $AnimationTree
onready var IntCast = $head/Cam/InteractCast
onready var bodycollider = $CollisionShape

func _ready():
#	anim_tree.active = true
	
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func damage():
	print("I JUST TOOK DAMAGE! :(")
	if health <= 0:
		queue_free()
	else:
		health -= 2


func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func interact():
	if Input.is_action_just_pressed("interact"):
		if IntCast.is_colliding():
			var interact_target = IntCast.get_collider()
			if interact_target.is_in_group("ammo_pickup"):
				print("im interacting with a ammo pickup")
				ammo_spare += 3
				interact_target.interacted = true

func reload():
	if Input.is_action_just_pressed("reload"):
		
		if ammo_spare != 0 or ammo_weapon == AMMO_IN_MAG:
			if not anim_player.is_playing():
				anim_player.play("simpleReloadRevolver")
				
				var ammo_needed = AMMO_IN_MAG - ammo_weapon
				
				if ammo_spare >= ammo_needed:
					ammo_spare -= ammo_needed
					ammo_weapon = AMMO_IN_MAG
				else:
					ammo_weapon += ammo_spare
					ammo_spare = 0
				
		

func fire():
	if Input.is_action_just_pressed("fire1"):
		if ammo_weapon > 0:
			ammo_weapon -= 1
			if not anim_player.is_playing():
				camera.translation = lerp(camera.translation, Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
				if GunCast.is_colliding():
					var target = GunCast.get_collider()
					if target.is_in_group("enemy"):
						target.health -= 10
			anim_player.play("RevolverFire")
#	else:
#		anim_player.stop()


func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	
	interact()
	reload()
	fire()
	
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
	
# warning-ignore:return_value_discarded
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
	#headbob
	
#	if direction != Vector3.ZERO:
#		anim_player.play("headbob")
	


