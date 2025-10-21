extends Node2D

var difficulty = 0.00
var score: int = 0
var playing = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score = max(0, score)
	%Player/Camera2D/Score.text = str(score)


func _on_player_game_over() -> void:
	Storage.score = score
	playing = false
	$LoseSound.play()
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Player/Camera2D/Score, "scale", Vector2.ZERO, 0.2)
	tween.parallel().tween_property(%Player/Sprite, "scale", Vector2.ZERO, 0.2)
	tween.parallel().tween_property(%Player/Sprite, "rotation", TAU, 0.2)
	tween.parallel().tween_property(%Player/Camera2D, "offset", Vector2(0,0), 0.2)
	tween.parallel().tween_property(%Player/Camera2D, "zoom", Vector2(5,5), 0.9)
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://gameover.tscn"))
