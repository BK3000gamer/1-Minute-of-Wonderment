extends Area2D

@export var timer: TimerUI


func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		timer._end()
