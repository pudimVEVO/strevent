extends MeshInstance

onready var light = $SpotLight
onready var player = get_node("/root/World/Player")


func _on_Area3_body_entered(body):
	if body == player:
		print_debug("entrou")
		$SpotLight.visible = true
		


func _on_Area3_body_exited(body):
	if body == player:
		print_debug("saiu")
		$SpotLight.visible = false
