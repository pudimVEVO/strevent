extends Control

var inv : RSInventory
var rot_box : CheckBox

func _add_ammo() :
	var item = Ammo.new()
	inv.lookup_and_put(item, 0)
	


func _input(event):
	if Input.is_action_just_pressed("inventory"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused
		visible = true
		
	if Input.is_action_just_pressed("inventory") and visible == true:
		visible = false
		get_tree().paused = false



func _ready() :
	#$dialog.show()
	
	
	
#	$inventory.resize(Vector2(15, 8))
	pass
