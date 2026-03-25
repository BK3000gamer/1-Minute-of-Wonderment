extends Area2D

@onready var timer := $"/root/Node2D/Timer"
@export var time := 5.0
var active := true

func _on_body_entered(body: Node2D) -> void:
	if body is Emu and active:
		timer.timer += time
		timer.collected += 1
		active = false
		visible = false
