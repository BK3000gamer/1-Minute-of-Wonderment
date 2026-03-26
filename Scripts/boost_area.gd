extends Area2D

@export var jumpHeight := 128.0
var boosted := false
var player

func _on_body_entered(body: Node2D) -> void:
	if body is Emu:
		boosted = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body is Emu:
		boosted = false

func _physics_process(_delta: float) -> void:
	if boosted:
		player.jumpHeight = jumpHeight
