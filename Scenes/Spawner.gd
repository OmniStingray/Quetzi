class_name Spawner extends Node2D

signal body_added(body:Body)
signal tail_added(tail:Tail)

# signals
# export variables
@export var bounds:Bounds
# instantiating packe scenes
var food_scene:PackedScene = preload("res://Scenes/food.tscn")
var body_scene:PackedScene = preload("res://Scenes/body.tscn")
var tail_scene:PackedScene = preload("res://Scenes/tail.tscn")

func spawn_food():
	# 1 where to spawn it (position)
	# randf_range == random value within a min and max range
	var spawn_point:Vector2 = Vector2.ZERO
	spawn_point.x = randf_range(bounds.x_min + Global.GRID_SIZE, bounds.x_max - Global.GRID_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.GRID_SIZE, bounds.y_max - Global.GRID_SIZE)
	
	spawn_point.x = floorf(spawn_point.x / Global.GRID_SIZE) * Global.GRID_SIZE + 0.5*Global.GRID_SIZE
	spawn_point.y = floorf(spawn_point.y / Global.GRID_SIZE) * Global.GRID_SIZE + 0.5*Global.GRID_SIZE
	
	if spawn_point.x > bounds.x_max:
		spawn_point.x -= 1
	if spawn_point.y > bounds.y_max:
		spawn_point.y -= 1
	
	# 2 what we're spawning (instantiating)
	var food = food_scene.instantiate()
	food.position = spawn_point
	# 3 where we're putting it (parenting)
	get_parent().add_child(food) 
	
func spawn_body(pos:Vector2):
	var body:Body = body_scene.instantiate() as Body
	body.position = pos
	get_parent().add_child(body)
	body_added.emit(body)
	
func spawn_tail(pos:Vector2):
	var tail:Tail = body_scene.instantiate() as Tail
	tail.position = pos
	get_parent().add_child(tail)
	tail_added.emit(tail)
	
	
	
