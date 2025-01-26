extends CharacterBody2D

@onready var Transformation_D = preload("res://scripts/sprite_explosion.gdshader")
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
var alive : bool = false

func _process(_delta):
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("transform_Destruction") && alive:
		print("KABOOM!")
		
		alive = false
		$GPUParticles2D.emitting = true
		$Sprite2D.hide()
		#set_scale(Vector2(2.0, 2.0))
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()


func flash():
	$Sprite2D.material.set_shader_parameter("flash_modifier", 1)
	await get_tree().create_timer(0.05).timeout
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)	

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Player hit by area: ", area.name)

func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Collision with ", body.name)
	# TODO fixme in the end, ugly
	match body.name:
		"Forest_Tree", "forest_tree_1", "forest_tree_2":
			flash()
