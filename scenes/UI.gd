extends Control


onready var ammoui = $ColorRect/VBoxContainer/HBoxContainer/CurrentAmmo

# Called when the node enters the scene tree for the first time.
func _ready():
	ammoui.text = '15'


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_changed_ammo(magammo):
	ammoui.text = str(magammo)
	
