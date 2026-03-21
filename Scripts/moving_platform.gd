extends AnimatableBody2D

@export var move_distance: Vector2 = Vector2(200, 0)
@export var move_duration: float = 2.0

var start_pos: Vector2

func _ready() -> void:
	start_pos = global_position
	_start_moving()



func _start_moving() -> void:
	var tween = get_tree().create_tween().set_loops()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var target_pos = start_pos + move_distance
	tween.tween_property(self, "global_position", target_pos, move_duration)
	
	tween.tween_property(self, "global_position", start_pos, move_duration)
