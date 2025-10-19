extends CharacterBody2D


const SPEED = 10.0
const BRAKE = 0.02
var FORWARD_FORCE = 800.0
const MAX_VELOCITY_X = 13000.0
const FRICTION = 0.2
const ACCELERATION = 0.02
const DIFFICULTY_FORCE = 100
const VERTICAL_SPEED = 800.0
var lane_positions = []
var current_lane = 2
var lane_tween: Tween

func _ready() -> void:
	velocity.x = 1000.0
	
	var lanes = %Lanes.get_children()
	
	for lane: Marker2D in lanes:
		lane_positions.append(lane.position)


func _physics_process(delta: float) -> void:
	### AHEAD ###
	
	FORWARD_FORCE += DIFFICULTY_FORCE * delta
	
	var forward = Input.get_axis("ui_left", "ui_right")
	
	if forward > 0:
		velocity.x += SPEED * forward
	elif forward < 0:
		velocity.x += velocity.x * BRAKE * forward
		
	velocity.x = clamp(velocity.x, 600, MAX_VELOCITY_X)
	
	
	
	### DODGING ###
	
	if Input.is_action_just_pressed("ui_up") and current_lane > 0:
		current_lane -= 1
		change_lane()
	elif Input.is_action_just_pressed("ui_down") and current_lane < 4:
		current_lane += 1
		change_lane()
		
	
	
	
	
	move_and_slide()
	
func change_lane():
	if lane_tween:
		lane_tween.kill() # Abort the previous animation.
	lane_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	lane_tween.tween_property(self, "position:y",lane_positions[current_lane].y, 0.4)
	
	
