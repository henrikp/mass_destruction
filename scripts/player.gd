extends CharacterBody2D

class_name Player

const TransformationSprite_spikes: CompressedTexture2D = preload("res://assets/images/player/Player_Spike_Ball.png") #
const TransformationSprite_default: CompressedTexture2D = preload("res://assets/images/player/PlayerDefault_0.png")
const PlayerExplosionTexture: CompressedTexture2D = preload("res://assets/images/player/32x32-white.png")
const TransformationShader_S: Shader = preload("res://scripts/transformation_s.gdshader")
const PlayerFlashShader: Shader = preload("res://scripts/player_flash.gdshader")
const PlayerExplosionShader: Shader = preload("res://scripts/sprite_explosion.gdshader")
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
enum transformation { FORM_SWITCHING = -1, FORM_NORMAL = 0, FORM_SPIKES = 1 } 
var current_form = transformation.FORM_NORMAL
var alive : bool

func _on_ready() -> void:
	pass

func _process(_delta):
	pass

func _input(event: InputEvent) -> void:
	#print_debug("InputEvent triggered: ", event.as_text())	
	if event is InputEventKey and event.pressed and current_form != transformation.FORM_SWITCHING and self.alive:
		if event.is_action_pressed("transform_Destruction"):
			# Player pressed the D key - we dissolve/destruct/dissintigrate
			self.alive = false
			var local_material = ShaderMaterial.new()
			local_material.shader = PlayerExplosionShader
			$GPUParticles2D.texture = PlayerExplosionTexture
			
			match current_form:
				transformation.FORM_NORMAL:
					local_material.set_shader_parameter("sprite", TransformationSprite_default)
				transformation.FORM_SPIKES:
					local_material.set_shader_parameter("sprite", TransformationSprite_spikes)
				_:
					local_material.set_shader_parameter("sprite", TransformationSprite_default)

			$GPUParticles2D.process_material = local_material
			$GPUParticles2D.restart()	
			$Sprite2D.hide()
			current_form = transformation.FORM_NORMAL
		elif event.is_action_pressed("transform_Spikes") and current_form != transformation.FORM_SPIKES:
			# Player pressed the S key
			current_form = transformation.FORM_SWITCHING
			$Sprite2D.play("spikes")
			var local_material = ShaderMaterial.new()
			local_material.shader = TransformationShader_S
			$GPUParticles2D.process_material = local_material
			$GPUParticles2D.texture = null
			current_form = transformation.FORM_SPIKES
			

#func _physics_process(delta: float) -> void:
		
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
	print_debug("Player hit by area: ", area.name)

func _on_hitbox_body_entered(body: Node2D) -> void:
	print_debug("Collision with ", body.name)
	# TODO fixme in the end, ugly
	match body.name:
		"Forest_Tree", "forest_tree_1", "forest_tree_2":
			flash()

func _on_gpu_particles_2d_finished() -> void:
	print_debug("Player shader emission finished")
