extends CharacterBody2D


const SPEED = 20.0
const BRAKE = 0.02
var FORWARD_FORCE = 400.0
const MAX_VELOCITY_X = 4000.0
const FRICTION = 0.2
const ACCELERATION = 0.02
const DIFFICULTY_FORCE = 10
var lane_positions = []
var current_lane = 2
var lane_tween: Tween

func _ready() -> void:
	velocity.x = 100.0
	
	var lanes = %Lanes.get_children()
	
	for lane: Marker2D in lanes:
		lane_positions.append(lane.position)


func _physics_process(delta: float) -> void:
	### AHEAD ###
	
	velocity.x += DIFFICULTY_FORCE * delta
	
	var forward = Input.get_axis("ui_left", "ui_right")
	if not lane_tween or not lane_tween.is_running():
		$Sprite.animation = "default"
	
	if forward > 0:
		velocity.x += SPEED * forward
	elif forward < 0:
		if not lane_tween or not lane_tween.is_running():
			$Sprite.animation = "brake"
		velocity.x += velocity.x * BRAKE * forward
		
	velocity.x = clamp(velocity.x, 100, MAX_VELOCITY_X)
	
	
	
	### DODGING ###
	
	if Input.is_action_just_pressed("ui_up") and current_lane > 0:
		current_lane -= 1
		change_lane(true)
	elif Input.is_action_just_pressed("ui_down") and current_lane < 4:
		current_lane += 1
		change_lane(false)
		
	
	
	
	
	move_and_slide()
	
func change_lane(up: bool):
	if lane_tween:
		lane_tween.kill() # Abort the previous animation.
	lane_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if up:
		lane_tween.tween_property($Sprite, "animation", &"up", 0)
	else:
		lane_tween.tween_property($Sprite, "animation", &"down", 0)
	lane_tween.tween_property(self, "position:y",lane_positions[current_lane].y, 0.1)
	lane_tween.tween_property($Sprite, "animation", &"default", 0)
	
	
