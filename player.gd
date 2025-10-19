extends CharacterBody2D


const SPEED = 30.0
const BRAKE = 80.0
var FORWARD_FORCE = 800.0
const MAX_VELOCITY_X = 13000.0
const FRICTION = 0.2
const ACCELERATION = 0.04
const DIFFICULTY_FORCE = 50


func _physics_process(delta: float) -> void:
	FORWARD_FORCE += DIFFICULTY_FORCE * delta
	
	var forward = Input.get_axis("ui_left", "ui_right")
	
	if forward == 0:
		velocity.x = lerp(velocity.x, FORWARD_FORCE, ACCELERATION)
	elif forward > 0:
		velocity.x += SPEED * forward
	elif forward < 0:
		velocity.x += BRAKE * forward
		
	velocity.x = clamp(velocity.x, 50, MAX_VELOCITY_X)
	
	move_and_slide()
	
	
	
	
