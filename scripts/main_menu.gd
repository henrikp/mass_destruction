extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("wasm"):
		var btn = $Node2D/CenterContainer/VBoxContainer/button_quit
		btn.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_quit_pressed() -> void:
	$Node2D/CenterContainer/VBoxContainer/button_quit.get_tree().quit()
