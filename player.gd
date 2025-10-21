extends CharacterBody2D


const SPEED = 2.0
const BRAKE = 0.02
const MAX_VELOCITY_X = 600.0
const FRICTION = 0.2
const ACCELERATION = 0.02
const DIFFICULTY_FORCE = 10
var lane_positions = []
var current_lane = 2
var lane_tween: Tween


@export var tilemap1: Node2D
@export var tilemap2: Node2D

var tilemap_width: int

func _process(delta):
	var camera = $Camera2D
		# wrap whichever is furthest behind to the front
	if tilemap1.global_position.x < tilemap2.global_position.x:
		if (camera.global_position.x - 2000) - tilemap1.global_position.x > tilemap_width:
			tilemap1.global_position.x = tilemap2.global_position.x + tilemap_width
	else:
		if (camera.global_position.x - 2000) - tilemap2.global_position.x > tilemap_width:
			tilemap2.global_position.x = tilemap1.global_position.x + tilemap_width

func _ready() -> void:
	
	tilemap_width = tilemap1.get_child(0).get_used_rect().size.x * 16
	velocity.x = 50
	
	var lanes = %Lanes.get_children()
	
	for lane: Marker2D in lanes:
		lane_positions.append(lane.position)


func _physics_process(delta: float) -> void:
	### AHEAD ###
	
	velocity.x += DIFFICULTY_FORCE * delta
	
	var forward = Input.get_axis("ui_left", "ui_right")
	if not lane_tween or not lane_tween.is_running():
		$Sprite.animation = "default"
	
	velocity.x = min(velocity.x, MAX_VELOCITY_X) # Upper limit
	
	if forward > 0:
		velocity.x += SPEED * forward
	elif forward < 0:
		if not lane_tween or not lane_tween.is_running():
			$Sprite.animation = "brake"
		velocity.x += velocity.x * BRAKE * forward
		
	velocity.x = max(velocity.x, 100)
	
	$CollisionShape2D.position.x = -(ceil(velocity.x / 50)) + -10
	print(velocity.x)
	
	### DODGING ###
	
	if Input.is_action_just_pressed("ui_up") and current_lane > 0:
		current_lane -= 1
		change_lane(true)
	elif Input.is_action_just_pressed("ui_down") and current_lane < 4:
		current_lane += 1
		change_lane(false)
		
	
	
	
	
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		if (collision.get_collider() as Node2D).is_in_group("obstacles"):
			get_tree().quit()
		
	
func change_lane(up: bool):
	if lane_tween:
		lane_tween.kill() # Abort the previous animation.
	lane_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if up:
		lane_tween.tween_property($Sprite, "animation", &"up", 0)
	else:
		lane_tween.tween_property($Sprite, "animation", &"down", 0)
	lane_tween.tween_property(self, "position:y",lane_positions[current_lane].y, 0.2)
	lane_tween.tween_property($Sprite, "animation", &"default", 0)
	
	
