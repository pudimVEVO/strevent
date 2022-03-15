extends RigidBody

onready var anim_player = $AnimationPlayer
onready var Timer = $closeTimer

var is_open = false

func open():
	if is_open == false:
		anim_player.play("opening")
		is_open = true
		Timer.start()

func close():
	if is_open == true:
		anim_player.play("closing")
		is_open = false

func _process(delta):
	if Timer.is_stopped():
		close()
	
