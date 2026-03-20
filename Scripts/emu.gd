extends CharacterBody2D
class_name Emu

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
@export var maxStamina: float = 100.0
@export var staminaDepletionRate: float = 50.0 #per second
@export var airAcceleration: float = 20.0
@export var airDeceleration: float = 15.0

var InputDir: float = 0.0
var Speed: float
var Momentum: float
var jumpVelocity: float
var jumpGravity: float
var fallGravity: float
var jumpBufferTimer: float = 0.0
var coyoteTimer: float = 0.0
var checkpoint := Vector2.ZERO
var currentStamina: float = 100.0

signal respawn

enum States {
	Idle,
	Run,
	Jump,
	Fall,
	WallCling
}

var CurrentState = States.Idle

func _get_gravity() -> float:
	return jumpGravity if velocity.y < 0.0 else fallGravity

func _physics_process(delta: float) -> void:
	#Input Direction
	InputDir = Input.get_action_strength("right") - Input.get_action_strength("left")
	#Gravity
	jumpVelocity = (2.0 * jumpHeight) / jumpTimeToPeak * -1.0
	jumpGravity = (-2.0 * jumpHeight) / pow(jumpTimeToPeak, 2.0) * -1.0
	fallGravity = (-2.0 * jumpHeight) / pow(jumpTimeToDecent, 2.0) * -1.0
	velocity.y += _get_gravity() * delta
	#Layer 4 WallCling Collision
	if is_on_wall() and !is_on_floor() and currentStamina >0:
		if get_last_slide_collision().get_collider().collision_layer == 8:
			if CurrentState != States.WallCling:
				_change_state(States.WallCling)
	
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
			#Speed based on input for air momentum (Look States.Fall)
			if InputDir != 0:
				Momentum = move_toward(Momentum, maxSpeed, airAcceleration)
			else:
				Momentum = move_toward(Momentum, 0, airDeceleration)
			velocity.x = InputDir * Momentum
			if velocity.y < 0.0:
				_change_state(States.Fall)
			if is_on_floor():
				if InputDir == 0.0:
					_change_state(States.Idle)
				else:
					_change_state(States.Run)
		States.Fall:
			if InputDir != 0:
				Momentum = move_toward(Momentum, maxSpeed, airAcceleration)
			else:
				Momentum = move_toward(Momentum, 0, airDeceleration)
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
		States.WallCling:
			currentStamina -= staminaDepletionRate * delta
			#Exit Conditons
			# 1. Out of Stamina
			# 2. Jump Away from wall
			# 3. No longer touching wall (let go of direction)
			if currentStamina <= 0 or !is_on_wall():
				_change_state(States.Fall)
				
			if Input.is_action_just_pressed("jump"):
				velocity.x = get_wall_normal().x * maxSpeed
				_change_state(States.Jump)
				
			var input_dir = Input.get_axis("right", "left")
			var wall_normal = get_wall_normal().x
			var is_pushing_into_wall = (wall_normal > 0 and input_dir < 0) or (wall_normal < 0 and input_dir > 0)
			#Cling ONLY if player is pressing input into wall
			if !is_pushing_into_wall:
				_change_state(States.Fall)
				 
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
			#Refill stamina on floor
			if is_on_floor():
				currentStamina = maxStamina
			velocity = Vector2.ZERO
		States.Run:
			if is_on_floor():
				currentStamina = maxStamina
			Speed = baseSpeed
		States.Jump:
			velocity.y = jumpVelocity
			Momentum = abs(velocity.x)
		States.Fall:
			coyoteTimer = coyoteTime
			Momentum = abs(velocity.x)
		States.WallCling:
			velocity = Vector2.ZERO

func _respawn() -> void:
	global_position = checkpoint
	respawn.emit()
