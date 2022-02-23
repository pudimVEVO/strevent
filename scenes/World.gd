extends Spatial

onready var timer = $AudioTimer
var usmdialog1 = Dialogic.start("usm1")
var usmdialog2 = Dialogic.start("usm2")
var magodialog1 = Dialogic.start("mago1")
onready var pausescreen = $PauseScreen

func _ready():
	timer.start()
	$backgroundoutside.play()

func _on_AudioTimer_timeout():
	add_child(usmdialog1)
	timer.stop()
	AudioManager.play("res://audio/usmvoicelines.wav")
	AudioManager._on_stream_finished(1)
	

#func pause():
#	if Input.is_action_just_pressed("pause"):
#		get_tree().paused = true
#		pausescreen.popup()
#		if Input.is_action_just_pressed("pause"):
#			pausescreen.hide()
#			get_tree().paused = false
#
#
#func _on_Continue_pressed():
#	pausescreen.hide()
#	get_tree().paused = false
#
#
#func _on_Quit_pressed():
#	get_tree().quit()
#
#func _physics_process(delta):
#	pause()


