extends Area2D

@export var timer: TimerUI
var started := false

func _on_body_exited(body: Node2D) -> void:
	if body is Emu and !started:
		started = true
		timer._start()
