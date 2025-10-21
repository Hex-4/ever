extends Node2D
const WIDTH = 16
	
func _ready() -> void:
	var gap = randi() % 5
	var single_index = 0
	for i in range(5):
		if i != gap:
			get_child(single_index).position.y = (i * 16) + 152 # 152 is the first lane
			single_index += 1
		

func is_off_screen(camera_x: float) -> bool:
	return position.x < camera_x - 100
