extends Area2D

@export var timer: TimerUI
var active := true

func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		timer.timer += 1.0
		timer.collected += 1
		active = false
		visible = false
