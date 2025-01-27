extends Node

@onready var quit_button = $Node2D/CenterContainer/VBoxContainer/button_quit
@onready var main_game_scene = "res://scenes/main_game.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide the exit menu button if we are running in a HTML file
	if OS.has_feature("wasm"):
		quit_button.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_quit_pressed() -> void:
	quit_button.get_tree().quit()

func _on_button_start_continue_pressed() -> void:
	get_tree().change_scene_to_file(main_game_scene)
