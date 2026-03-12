extends CharacterBody2D

@export_category("Stats")
@export var baseSpeed: float
@export var maxSpeed: float
@export var acceleration: float
@export var deceleration: float
@export var jumpHeight: float
@export var jumpTimeToPeak: float
@export var jumpTimeToDecent: float
@export var jumpBufferTime: float
@export var coyoteTime: float

var InputDir: float = 0.0
var Speed: float
var Momentum: float
var jumpVelocity: float
var jumpGravity: float
var fallGravity: float
var jumpBufferTimer: float = 0.0
var coyoteTimer: float = 0.0

enum States {
	Idle,
	Run,
	Jump,
	Fall
}

var CurrentState = States.Idle

func _ready() -> void:
	jumpVelocity = (2.0 * jumpHeight) / jumpTimeToPeak * -1.0
	jumpGravity = (-2.0 * jumpHeight) / pow(jumpTimeToPeak, 2.0) * -1.0
	fallGravity = (-2.0 * jumpHeight) / pow(jumpTimeToDecent, 2.0) * -1.0

func _get_gravity() -> float:
	return jumpGravity if velocity.y < 0.0 else fallGravity

func _physics_process(delta: float) -> void:
	print(velocity.x)
	#Input Direction
	InputDir = Input.get_action_strength("right") - Input.get_action_strength("left")
	#Gravity
	velocity.y += _get_gravity() * delta
	match CurrentState:
		States.Idle:
			velocity = Vector2.ZERO
			if !InputDir == 0.0:
				_change_state(States.Run)
			if is_on_floor():
				if Input.is_action_just_pressed("jump"):
					_change_state(States.Jump)
			else:
				_change_state(States.Fall)
		States.Run:
			Speed *= acceleration
			velocity.x = InputDir * min(Speed, maxSpeed)
			if InputDir == 0.0:
				_change_state(States.Idle)
			if is_on_floor():
				if Input.is_action_just_pressed("jump"):
					_change_state(States.Jump)
			else:
				_change_state(States.Fall)
		States.Jump:
			Speed *= acceleration
			velocity.x = InputDir * min(Speed, maxSpeed)
			if velocity.y < 0.0:
				_change_state(States.Fall)
			if is_on_floor():
				if InputDir == 0.0:
					_change_state(States.Idle)
				else:
					_change_state(States.Run)
		States.Fall:
			Momentum *= deceleration
			velocity.x = InputDir * Momentum
			if Input.is_action_just_pressed("jump"):
				if coyoteTimer > 0:
					coyoteTimer = 0.0
					_change_state(States.Jump)
				else:
					jumpBufferTimer = jumpBufferTime
			if is_on_floor():
				if jumpBufferTimer > 0:
					jumpBufferTimer = 0.0
					_change_state(States.Jump)
				else:
					if InputDir == 0.0:
						_change_state(States.Idle)
					else:
						_change_state(States.Run)
	move_and_slide()

func _process(delta: float) -> void:
	jumpBufferTimer -= delta
	coyoteTimer -= delta
	match CurrentState:
		States.Idle:
			return
		States.Run:
			return
		States.Jump:
			return
		States.Fall:
			return

func _change_state(NewState: States) -> void:
	CurrentState = NewState
	match CurrentState:
		States.Idle:
			velocity = Vector2.ZERO
		States.Run:
			Speed = baseSpeed
		States.Jump:
			velocity.y = jumpVelocity
		States.Fall:
			coyoteTimer = coyoteTime
			Momentum = abs(velocity.x)
