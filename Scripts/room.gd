extends Area2D

@onready var camera := $"/root/Node2D/Camera2D"
@onready var checkpoint := $Checkpoint

func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		_activate_room(body)

func _activate_room(body: Emu) -> void:
	#move camera
	var currentPos = camera.global_position
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(camera, "global_position", global_position, 0.2).from(currentPos)
	
	#set checkpoint
	body.checkpoint = checkpoint.global_position
