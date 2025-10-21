extends Node2D

@export var slice_scenes: Dictionary[PackedScene, Vector2i] = {}

@export var spacing = 600

var active_slices = []
var last_spawn_x = 0

func pick_weighted_slice() -> PackedScene:
	var total_weight = 0
	for weight in slice_scenes.values():
		total_weight += lerp(weight.x, weight.y, owner.difficulty)
	
	var random = randf() * total_weight
	
	var total = 0
	
	for slice in slice_scenes.keys():
		total += lerp(slice_scenes[slice].x, slice_scenes[slice].x, owner.difficulty)
		if random < total:
			return slice
	return slice_scenes.keys()[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	owner.difficulty += 0.00002

	if (%Player as CharacterBody2D).global_position.x + 1000 > last_spawn_x:
		spacing = lerp(600, 250, owner.difficulty)
		spawn_slice()
	
	for slice in active_slices:
		if slice.is_off_screen(%Player.global_position.x):
			slice.queue_free()
			active_slices.erase(slice)

func spawn_slice():
	var slice = pick_weighted_slice().instantiate()
	add_child(slice)
	slice.position.x = last_spawn_x
	active_slices.append(slice)
	last_spawn_x += spacing
