extends Spatial

const ADS_LERP = 20

var mouse_mov
var sway_threshold = 5
var sway_lerp = 5
var fview = {"Default": 65, "ADS": 50}
var camera : Camera

export var camera_path : NodePath
export var default_position : Vector3
export var ads_position : Vector3
export var sway_left : Vector3
export var sway_right : Vector3
export var sway_normal : Vector3

func _ready():
	camera = get_node(camera_path)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x

func _process(delta):
	
	if Input.is_action_pressed("fire2"):
		transform.origin = transform.origin.linear_interpolate(ads_position, ADS_LERP * delta)
		camera.fov = lerp(camera.fov, fview["ADS"], ADS_LERP * delta)
	else:
		transform.origin = transform.origin.linear_interpolate(default_position, ADS_LERP * delta)
		camera.fov = lerp(camera.fov, fview["Default"], ADS_LERP * delta)
	
	
	if mouse_mov != null:
		if mouse_mov > sway_threshold:
			rotation = rotation.linear_interpolate(sway_left, sway_lerp * delta)
		elif mouse_mov < -sway_threshold:
			rotation = rotation.linear_interpolate(sway_right, sway_lerp * delta)
		else:
			rotation = rotation.linear_interpolate(sway_normal, sway_lerp * delta)
	
	
	






