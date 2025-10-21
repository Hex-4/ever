extends Node2D
const WIDTH = 16
	
func _ready() -> void:
	# pick random lane(s) to place block in
	var laneA = randi() % 5
	get_child(0).position.y = (laneA * 16) + 152 # 152 is the first lane
	var laneB = randi() % 5
	while laneA == laneB:
		laneB = randi() % 5
	get_child(1).position.y = (laneB * 16) + 152 # 152 is the first lane
	
func is_off_screen(camera_x: float) -> bool:
	return position.x < camera_x - 100
