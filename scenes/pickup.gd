extends RigidBody

var interacted = false

func _process(delta):
	if interacted == true:
		queue_free()
