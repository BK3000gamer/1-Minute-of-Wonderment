extends Area2D

@export var maxSpeed := 200.0
@export var jumpHeight := 48.0
var recordedMaxSpeed: float
var recordedJumpHeight: float

func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		recordedMaxSpeed = body.maxSpeed
		recordedJumpHeight = body.jumpHeight
		body.maxSpeed = maxSpeed
		body.jumpHeight = jumpHeight

func _on_body_exited(body: Node2D) -> void:
	if body is Emu:
		body.maxSpeed = recordedMaxSpeed
		body.jumpHeight = recordedJumpHeight
