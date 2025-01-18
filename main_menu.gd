extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#if OS.has_feature("HTML5"):
	# placeholder, hide the quit button if we are in a browser 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	get_tree().quit()
