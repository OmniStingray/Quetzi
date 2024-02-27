class_name Gameplay extends Node2D

const gameover_scene:PackedScene = preload("res://menus/game_over.tscn")
var gameover_menu:GameOver
const pausemenu_scene:PackedScene = preload("res://menus/pause_menu.tscn")
var pausemenu_menu:PauseMenu


@onready var head: Head = %Head as Head
@onready var bounds: Bounds = $Bounds as Bounds
@onready var spawner: Spawner = $Spawner as Spawner
@onready var tail: Tail = %Tail as Tail 
@onready var hud: HUD = %HUD as HUD
@onready var bite = %Bite


var time_between_moves:float = 1000.0
var time_since_last_move:float = 0
var speed:float = 4000.0  # can be changed to make the game more difficult. (higher number == faster)
var move_dir: Vector2 = Vector2.UP # Vector2(0,-1)
var snake_parts:Array[SnakePart] = []
var score:int:
	get:  # Getters and Setters are helpful for larger projects, so mostly just a demonstration here
		return score
	set(value):  # score =
		score = value
		hud.update_score(value)
		# example of it being helpful.  If special items spawn which give extra points, all I 
		# would have to do is to update the score value, and this will automatically update the 
		# HUD score value for me.

# Called when the node enters the scene tree for the first time.
func _ready():
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_body.connect(_on_body_collided)
	head.collided_with_wall.connect(_on_wall_collided)
	spawner.body_added.connect(_on_body_added)
	spawner.tail_added.connect(_on_tail_added)
	
	time_since_last_move = time_since_last_move
	spawner.spawn_food()
	snake_parts.push_back(head) # [Head, Body, n_body, Tail]
	snake_parts.push_back(tail)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var new_dir:Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		new_dir = Vector2.UP # (0,-1)
		Global.face_direction = 0
	if Input.is_action_pressed("ui_right"):
		new_dir = Vector2.RIGHT # (1,0)
		Global.face_direction = 90
	if Input.is_action_pressed("ui_down"):
		new_dir = Vector2.DOWN # (0,1)
		Global.face_direction = 180
	if Input.is_action_pressed("ui_left"):
		new_dir = Vector2.LEFT # (-1,0)
		Global.face_direction = 270

	# don't allow player to reverse direction
	if new_dir + move_dir != Vector2.ZERO and new_dir != Vector2.ZERO:
		move_dir = new_dir
		head.rotation_degrees = Global.face_direction
		Global.turn_location = head.position
		
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()
		
func _physics_process(delta: float):
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		time_since_last_move = 0
	
func update_snake():
	# print("Snake moved")
	# move direction and how much?
	var new_pos:Vector2 = head.position + move_dir * Global.GRID_SIZE
	new_pos = bounds.wrap_vector(new_pos)
	head.move_to(new_pos)
	for i in range(1, snake_parts.size(),1):
		snake_parts[i].move_to(snake_parts[i-1].last_position)
		# idea
		# grab position of head when input command is recorded.
		# when last position == head position when change in direction, apply rotation
		if i > 0 && snake_parts[i].position == Global.turn_location:
			snake_parts[i].rotation_degrees = Global.face_direction
			# this currently doesn't quite work... but close!

func _on_food_eaten():
	print("Yummy!")	
	# 1. Spawn more food once food is eaten.
	bite.play()
	spawner.call_deferred("spawn_food")
	# 2. Add to the body, and adjust the tail
	  # first, remove the current "tail" before adding a body segment	
	  # Second, spawn the body segment 
	spawner.call_deferred("spawn_body", snake_parts[snake_parts.size()-1].last_position)
	  # third, add the tail segment again
	#spawner.call_deferred("spawn_tail",snake_parts[snake_parts.size()-1].last_position)
	# 3. increase speed?
	speed += 500.0
	# 4. update score
	score += 1

func _on_body_added(body:Body):
	snake_parts.insert(snake_parts.size()-1,body)
	
func _on_tail_added(tail:Tail):
	snake_parts.push_back(tail)
	
func _on_body_collided():
	print("Game Over")
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
		gameover_menu.set_score(score)

func _on_wall_collided():
	print("Hit wall")
	_on_body_collided()  # temporary game end until I have time to work on the wall condition
	# turn the snake to the right unless another wall.
	#if head.position.x < 0 && head.position.y < 0:
		# top left corner
	#	if head.position.y > 
		

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()
		
func pause_game():
	if not pausemenu_menu:
		pausemenu_menu = pausemenu_scene.instantiate() as PauseMenu
		add_child(pausemenu_menu)

	pass
