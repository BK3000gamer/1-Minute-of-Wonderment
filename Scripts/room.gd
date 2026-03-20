extends Area2D

@export var camera: Camera2D
@onready var checkpoint := $Checkpoint

@export var room_width: float = 1884.0
@export var room_height: float = 300.0

func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		_activate_room(body)

func _activate_room(body: Emu) -> void:
	#set checkpoint
	body.checkpoint = checkpoint.global_position
	if not camera:	return
	#Match edges of area
	camera.limit_left = global_position.x - (room_width / 2)
	camera.limit_right = global_position.x + (room_width / 2)
	camera.limit_top = global_position.y - (room_height / 2)
	camera.limit_bottom = global_position.y + (room_height / 2)
	camera.reset_smoothing()
	#move camera
	var currentPos = camera.global_position
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(camera, "global_position", body.global_position, 0.4).from(currentPos)
