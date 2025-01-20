extends Node

const PLAYER_STARTING_POSITION : = Vector2i(277,446)
const CAMERA_STARTING_POSITION := Vector2i(640,360)

var speed:float
const START_SPEED:float = 5
#const MAX_SPEED:int = 25
var screen_size : Vector2i

func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	$Player.position = PLAYER_STARTING_POSITION
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CAMERA_STARTING_POSITION
	$"forest ground".position = Vector2i(0,720)

func _process(_delta):
	speed = START_SPEED
	
	$Player.position.x += speed
	$Camera2D.position.x += speed
	
	#Update ground position
	if $Camera2D.position.x - $"forest ground".position.x > screen_size.x * 1.5 :
		$"forest ground".position.x += screen_size.x
