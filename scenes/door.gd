extends RigidBody

onready var anim_player = $DoorPlayer
onready var closeTimer = $closeTimer

#var interacted = false
var is_open = false

func open():
	if is_open == false:
		anim_player.play("opening")
		is_open = true
		closeTimer.start()

func close():
	if is_open == true:
		anim_player.play("closing")
		is_open = false

func _process(delta):
	if closeTimer.is_stopped():
		close()
