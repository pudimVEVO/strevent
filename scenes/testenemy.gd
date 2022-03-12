extends KinematicBody

var health = 30
var cooldown = false

onready var head = $head
onready var damagecast = $DamageCast
onready var timer = $Timer

func _ready():
	pass

func take_damage():
	pass


func _process(delta):
	if health <= 0:
		queue_free()
	

func _physics_process(delta):
	
	
	if damagecast.is_colliding() and timer.is_stopped():
		var target = damagecast.get_collider()
		if target.is_in_group("player"):
			target.damage()
			timer.start()


