extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		body._respawn()
