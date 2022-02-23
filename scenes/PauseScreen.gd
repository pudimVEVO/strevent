extends Control

func _input(event):
	if Input.is_action_just_pressed("pause"):
		$VBoxContainer/Continue.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_Continue_pressed():
	get_tree().paused = not get_tree().paused
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Quit_pressed():
	get_tree().quit()
