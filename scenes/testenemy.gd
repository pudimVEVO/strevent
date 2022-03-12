extends KinematicBody

var health = 30

onready var 


func _ready():
	pass

func take_damage():
	pass


func _process(delta):
	if health <= 0:
		queue_free()
