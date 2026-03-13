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
	clock.text = "%01d:%02d" % [m, s]

func _start() -> void:
	active = true
	timer = time
	clock.visible = true

func _end() -> void:
	active = false
	var rm = m
	var rs = s
	timer = 0
	clock.visible = false
	score.visible = true
	score.text = "Clocks Collected: %02d\nTime Remaining: %01d:%02d" % [collected, rm, rs]
