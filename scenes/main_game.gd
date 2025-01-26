extends Node

signal reset_game

const PLAYER_STARTING_POSITION := Vector2i(277,446)
const CAMERA_STARTING_POSITION := Vector2i(640,360)
const GAME_OVER = preload("res://scenes/game_over.tscn")
var restart_menu = GAME_OVER.instantiate()

var forest_ground_scene: PackedScene = preload("res://scenes/forest_ground.tscn")
var ground_types := [forest_ground_scene]
var last_ground
var ground_height : int
var forest_tree: PackedScene = preload("res://scenes/forest_tree.tscn")
var forest_tree_1: PackedScene = preload("res://scenes/forest_tree_1.tscn")
var forest_tree_2: PackedScene = preload("res://scenes/forest_tree_2.tscn")
var forest_tree_types := [forest_tree,forest_tree_1,forest_tree_2]
var last_obstacle

var objects_generated_array : Array

var speed:float
const START_SPEED:float = 5
#const MAX_SPEED:int = 25
var screen_size : Vector2i

#var ground_children_debug

func _ready():
	SignalBus.reset_game.connect(new_game)
	screen_size = get_window().size
	new_game()

func new_game():
	$Player.position = PLAYER_STARTING_POSITION
	$"Player/Sprite2D".show()
	$Player.alive = true
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CAMERA_STARTING_POSITION
	$"Ground/forest ground".position = Vector2i(0,720)
	last_ground = $"Ground/forest ground"
	ground_height = last_ground.get_node("Sprite2D").texture.get_height()
	$Player/GPUParticles2D.emitting = false
	$"CenterContainer/Game restart menu".hide()
	print("Starting new game")

func _process(_delta):
	if $Player.alive == true:
		
		speed = START_SPEED
		
		if get_node("Obstacles").get_child_count() == 0:
			generate_obs()

		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		
		if $Camera2D.position.x - last_ground.position.x > screen_size.x * 1.5 :
			generate_floor()
		
		#Deletes objects that have gone off the screen
		#The 640 is to get the centre of the camera (the camera position) and the 128 is the buffer (adjustable)
		for object in objects_generated_array:
			if object.position.x + object.get_node("Sprite2D").texture.get_width() + 640 + 128 < $Camera2D.position.x:
				remove_object(object)
		
		#Debugging: counts the number of children in the Ground node and prints it to the log
		#ground_children_debug = get_node("Ground").get_child_count()
		#print(ground_children_debug)
	else:
		# We are dead and no particles on screen
		if !$"Player/GPUParticles2D".emitting:
			$"CenterContainer/Game restart menu".show()
			var center : Vector2 = $Camera2D.get_screen_center_position()
			$"CenterContainer/Game restart menu".position = Vector2(center.x - 100, center.y - 100)
		
func generate_floor():
	#The generates the floor 100 pixels off the right edge of the screen
	#Modification needed to pass in the desired floor type into the function
	var new_ground = forest_ground_scene.instantiate()
	get_node("Ground").add_child(new_ground)
	new_ground.position = Vector2i($Camera2D.position.x + 128, 720)
	last_ground = new_ground
	objects_generated_array.append(new_ground)

func generate_obs():
	#Generates ground obstacles
	var obstacle_type = forest_tree_types[randi() % forest_tree_types.size()]
	var obs
	obs = obstacle_type.instantiate()
	#var obs_height = obs.get_node("Sprite2D").texture.get_height()
	#var obs_scale = obs.get_node("Sprite2D").scale
	var obs_x : int = $Camera2D.position.x + screen_size.x + 128
	var obs_y : int = screen_size.y - ground_height + 10
	last_obstacle = obs
	obs.position = Vector2i(obs_x,obs_y)
	get_node("Obstacles").add_child(obs)
	objects_generated_array.append(obs)

func remove_object(object):
	object.queue_free()
	objects_generated_array.erase(object)
	
