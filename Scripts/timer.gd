extends Node

var timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60

func _start() -> void:
	timer.start()
