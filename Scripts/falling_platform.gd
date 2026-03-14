extends CharacterBody2D

var falling := false
@onready var emu := $"/root/Node2D/Emu"
@onready var trigger := $Trigger  # your trigger Area2D
var pos: Vector2

var time := 0.1
var timer := 0.0

func _ready() -> void:
	pos = position
	emu.respawn.connect(_reset)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if falling:
		velocity += get_gravity() * delta
	else:
		velocity = Vector2.ZERO
	
	timer -= delta
	if timer < 0.0:
		trigger.monitoring = true
	
	move_and_slide()

func _on_trigger_body_entered(body: Node2D) -> void:
	if body is Emu and !falling:
		await get_tree().create_timer(0.1).timeout
		falling = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Emu:
		falling = false
		body._respawn()
		trigger.monitoring = false
		timer = time
		_reset()

func _reset() -> void:
	position = pos
	falling = false
	velocity = Vector2.ZERO
