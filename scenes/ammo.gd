extends Item

class_name Ammo

var ammo_tex := preload("res://textures/ammoicontext.png") as StreamTexture

func get_texture() -> Texture :
	return ammo_tex

func get_size() -> Vector2 :
	return Vector2(2, 1)
