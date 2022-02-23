extends Control

onready var _transition_rect := $SceneTransitionRect

func _ready():
	$buttons/Start.grab_focus()

func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	_transition_rect.transition_to("res://scenes/World.tscn")


func _on_Options_pressed():
	pass # Replace with function body.
