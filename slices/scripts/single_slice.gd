extends Node2D
const WIDTH = 16
	
func _ready() -> void:
	# pick random lane(s) to place block in
	var lane = randi() % 5
	get_child(0).position.y = (lane * 16) + 152 # 152 is the first lane
	
func is_off_screen(camera_x: float) -> bool:
	return position.x < camera_x - 100
