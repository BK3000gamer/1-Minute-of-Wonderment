extends CanvasLayer
class_name TimerUI

@onready var clock := $Clock
@onready var score := $Score
@export var time := 60.0
var timer := 0.0
var active := false
var collected: int = 0

var m: int
var s: int

func _process(delta: float) -> void:
	if active:
		timer -= delta
	m = int(timer/60)
	s = timer - m * 60
	if timer < 0.0:
		_end(true)
	clock.text = "%01d:%02d" % [m, s]

func _start() -> void:
	active = true
	timer = time
	clock.visible = true

func _end(failed: bool) -> void:
	active = false
	var rm = m
	var rs = s
	timer = 0
	clock.visible = false
	score.visible = true
	if failed:
		score.text = "Clocks Collected: %02d\nPress [R] to Restart" % [collected]
	else:
		score.text = "Clocks Collected: %02d\nTime Remaining: %01d:%02d" % [collected, rm, rs]
	get_tree().paused = true
