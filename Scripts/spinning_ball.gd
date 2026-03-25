extends Node2D

@export var radius := 64.0
@export var speed := 1.5
@export var dir := 1.0
@export var startingAngle := 0.0
@export var colour1 : Color
@export var colour2 : Color
var angle := 0.0

@onready var ball := $Area2D

func _ready() -> void:
	angle = deg_to_rad(startingAngle)

func _process(_delta: float) -> void:
	circular_motion()
	
	queue_redraw()

func circular_motion() -> void:
	angle += speed * dir * get_process_delta_time()
	var xPos = cos(angle)
	var yPos = sin(angle)
	ball.position.x = xPos * radius
	ball.position.y = yPos * radius

func _draw() -> void:
	draw_line(Vector2(0.0, 0.0), ball.position, colour2, 3, false)
	draw_line(Vector2(0.0, 0.0), ball.position, colour1, 1, false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Emu:
		body._respawn()
