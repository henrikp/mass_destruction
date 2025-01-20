extends Node

const PLAYER_STARTING_POSITION : = Vector2i(277,446)
const CAMERA_STARTING_POSITION := Vector2i(640,360)

var forest_ground_scene: PackedScene = preload("res://scenes/forest_ground.tscn")
var ground_types := [forest_ground_scene]
var ground_generated : Array
var last_ground 

var speed:float
const START_SPEED:float = 1
#const MAX_SPEED:int = 25
var screen_size : Vector2i

var ground_children_debug

func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	$Player.position = PLAYER_STARTING_POSITION
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CAMERA_STARTING_POSITION
	$"Ground/forest ground".position = Vector2i(0,720)
	last_ground = $"Ground/forest ground"

func _process(_delta):
	speed = START_SPEED
	
	$Player.position.x += speed
	$Camera2D.position.x += speed
	
	
	if $Camera2D.position.x - last_ground.position.x > screen_size.x * 1.5 :
		generate_floor()
	
	#Deletes floors that have gone off the screen
	for ground in ground_generated:
		if ground.position.x < ($Camera2D.position.x - screen_size.x * 3):
			remove_scene(ground)
	
	#Debugging: counts the number of children in the Ground node and prints it to the log
	ground_children_debug = get_node("Ground").get_child_count()
	print(ground_children_debug)

func generate_floor():
	#The generates the floor 100 pixels off the right edge of the screen
	#Modification needed to pass in the desired floor type into the function
	var new_ground = forest_ground_scene.instantiate()
	get_node("Ground").add_child(new_ground)
	new_ground.position = Vector2i($Camera2D.position.x + 128, 720)
	last_ground = new_ground
	ground_generated.append(new_ground)

func remove_scene(scene):
	scene.queue_free()
	ground_generated.erase(scene)
