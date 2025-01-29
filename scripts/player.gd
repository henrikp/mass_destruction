extends CharacterBody2D

class_name Player

const PlayerTransformationSprite : Array[CompressedTexture2D] = [
	preload("res://assets/images/player/PlayerDefault_0.png"), # flash 
	preload("res://assets/images/player/Player_Spike_Ball.png"), # S
	null, # R 
	null # D
]

const PlayerParticleTexture : Array[CompressedTexture2D] = [
	null, # flash
	null, # S
	null, # R
	preload("res://assets/images/player/32x32-white.png"), # D
	null
]

const PlayerParticleShader : Array[Shader] = [
	preload("res://shaders/player_flash.gdshader"), # flash
	preload("res://shaders/transformation_s.gdshader"), # S
	preload("res://shaders/transformation_r.gdshader"), # R
	preload("res://shaders/sprite_explosion.gdshader"), # D
	null
]

const PlayerMaterial : Array[ShaderMaterial] = [
	null, # flash
	null, # S
	preload("res://scripts/transformation_r.tres"), # R
	null, # D
	null
]

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# We don't switch to FORM_DEATH, only use it to get the required shader
enum transformation { FORM_SWITCHING = -1, FORM_NORMAL = 0, FORM_SPIKES = 1, FORM_RED = 2, FORM_DEATH = 3 } 
var current_form = transformation.FORM_NORMAL
var alive : bool

func _on_ready() -> void:
	pass

func _process(_delta):
	pass

func set_shader(new_shader: Shader, new_sprite: bool) -> ShaderMaterial:
	var local_material = ShaderMaterial.new()
	local_material.shader = new_shader
	match current_form:
		transformation.FORM_SWITCHING:
			pass					
		_:
			print_debug("Changing sprite")
			$Sprite2D.material = PlayerMaterial[current_form]
	local_material.set_shader_parameter("sprite", PlayerTransformationSprite[current_form])
	local_material.shader = PlayerParticleShader[transformation.FORM_DEATH]
	return local_material

func reset() -> void:
	current_form = transformation.FORM_NORMAL
	$Sprite2D.material = null

func _input(event: InputEvent) -> void:
	#print_debug("InputEvent triggered: ", event.as_text())	
	if event is InputEventKey and event.pressed and current_form != transformation.FORM_SWITCHING and self.alive:
		if event.is_action_pressed("transform_Destruction"):
			# Player pressed the D key - we dissolve/destruct/dissintigrate
			# TODO: get the shader parameters from $Sprite2D before blowing up
			self.alive = false
			show_form()
			$GPUParticles2D.process_material = set_shader(PlayerParticleShader[transformation.FORM_DEATH], true)		
			$GPUParticles2D.texture = PlayerParticleTexture[transformation.FORM_DEATH]
			$GPUParticles2D.restart()	
			$Sprite2D.hide()
		elif event.is_action_pressed("transform_Spikes") and current_form != transformation.FORM_SPIKES:
			# Player pressed the S key - we get spikes
			current_form = transformation.FORM_SPIKES
			show_form()
			$Sprite2D.play("spikes")
			$GPUParticles2D.process_material = set_shader(PlayerParticleShader[current_form], true)
			$GPUParticles2D.texture = null
		elif event.is_action_pressed("transform_Red") and current_form != transformation.FORM_RED:
			current_form = transformation.FORM_RED
			show_form()
			$Sprite2D.material = set_shader(PlayerParticleShader[current_form], true)

func show_form() -> void:
	print_debug("Form: ", current_form)
	
	
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
	$GPUParticles2D.process_material = set_shader(PlayerParticleShader[transformation.FORM_NORMAL], false)
	$GPUParticles2D.texture = null
	# TODO: load the correct material first
	$Sprite2D.material.set_shader_parameter("flash_modifier", 1)
	await get_tree().create_timer(0.05).timeout
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)	

func _on_hitbox_area_entered(area: Area2D) -> void:
	pass
#	print_debug("Player hit by area: ", area.name)

func _on_hitbox_body_entered(body: Node2D) -> void:
	#print_debug("Collision with ", body.name)
	# TODO fixme in the end, ugly
	match body.name:
		"Forest_Tree", "forest_tree_1", "forest_tree_2":
			flash()

func _on_gpu_particles_2d_finished() -> void:
	pass
	#print_debug("Player shader emission finished")
