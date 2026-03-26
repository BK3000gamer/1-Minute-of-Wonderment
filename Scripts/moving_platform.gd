extends Path2D

@export var loop := true
@export var speed := 2.0
@export var speedScale := 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	if loop:
		animation.play("move")
		animation.speed_scale = speedScale
		set_process(false)

func _process(_delta: float) -> void:
	path.progress += speed
