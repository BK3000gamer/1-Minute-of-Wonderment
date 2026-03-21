extends Area2D

@export var camera: Camera2D
@onready var checkpoint := $Checkpoint

@export var camera_y_offset : float = 0.0
@export var room_width: float = 1884.0
@export var room_height: float = 300.0

func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		_activate_room(body)

func _activate_room(body: Emu) -> void:
	#set checkpoint
	body.checkpoint = checkpoint.global_position
	if not camera:
		if camera:
			camera.limit_left = -10000000
			camera.limit_right = 10000000
			camera.limit_top = -10000000
			camera.limit_bottom = 10000000
			camera.reset_smoothing()
		return
	#move camera
	var currentPos = camera.global_position
	var targetPos = body.global_position + Vector2(0, camera_y_offset)
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(camera, "global_position", targetPos, 0.4).from(currentPos)
