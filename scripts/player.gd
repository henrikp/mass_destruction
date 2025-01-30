extends CharacterBody2D

class_name Player

const ParticleTexture: CompressedTexture2D = preload("res://assets/images/player/32x32-white.png")

const ParticleMaterial : Array[ShaderMaterial] = [
	null, # flash
	null, # S
	preload('res://scripts/sprite_transformation_r.tres'), # R
	preload("res://scripts/particles_explosion.tres"), # D
	null
]

const SpriteMaterial : Array[ShaderMaterial] = [
	preload("res://scripts/sprite_flash.tres"), # flash
	preload("res://scripts/sprite_transformation_s.tres"), # S
	preload("res://scripts/sprite_transformation_r.tres"), # R
	null, # D
	null
]

@onready var ParticleGen: GPUParticles2D = $GPUParticles2D as GPUParticles2D
@onready var PlayerSprite: AnimatedSprite2D = $SubViewportContainer/SubViewport/Sprite2D as AnimatedSprite2D
@onready var ViewPort: SubViewport = $SubViewportContainer/SubViewport as SubViewport

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

enum transformation { FORM_CALM = -2, FORM_SWITCHING = -1, FORM_NORMAL = 0, FORM_SPIKES = 1, FORM_RED = 2, FORM_DEATH = 3 } 
var current_form: int = transformation.FORM_NORMAL as int
var real_form: int = transformation.FORM_CALM as int
var alive : bool

# GPUParticles2D default
const particles_amount : int = 8000
const particles_emitting : bool = false
const particles_lifetime: int = 1
const particles_oneshot: bool = true

func _on_ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func reset() -> void:
	current_form = transformation.FORM_NORMAL
	PlayerSprite.material = null
	reset_ParticleGen()
	
func reset_ParticleGen() -> void:
	ParticleGen.amount = particles_amount
	ParticleGen.emitting = particles_emitting
	ParticleGen.lifetime = particles_lifetime
	ParticleGen.one_shot = particles_oneshot
	

func play_animation(animation: String) -> void:
	PlayerSprite.play(animation)

func _input(event: InputEvent) -> void:
	#print_debug("InputEvent triggered: ", event.as_text())	
	if event is InputEventKey and event.pressed and current_form != transformation.FORM_SWITCHING and self.alive:
		reset_ParticleGen()
		if event.is_action_pressed("transform_Destruction"):
			# Player pressed the D key - we dissolve/destruct/dissintigrate
			self.alive = false
			# TODO: get the shader parameters from $Sprite2D before blowing up (colours)
			ParticleGen.process_material = set_custom_sprite(ParticleMaterial[transformation.FORM_DEATH], current_form)
			ParticleGen.texture = ParticleTexture
			current_form = transformation.FORM_DEATH
			ParticleGen.restart()
			PlayerSprite.hide()	
			clear_red_effects()
		elif event.is_action_pressed("transform_Spikes") and current_form != transformation.FORM_SPIKES:
			# Player pressed the S key - we get spikes
			current_form = transformation.FORM_SPIKES
			show_form()
			ParticleGen.process_material = null
			ParticleGen.texture = null
			PlayerSprite.material = SpriteMaterial[current_form]
			PlayerSprite.set_animation("spikes")
			clear_red_effects()
		elif event.is_action_pressed("transform_Red") and current_form != transformation.FORM_RED:
			# We start to glow red in our current form 
			real_form = current_form
			current_form = transformation.FORM_RED
			PlayerSprite.material = SpriteMaterial[current_form]

func clear_red_effects() -> void:
	PlayerSprite.material = null
	real_form = transformation.FORM_CALM

func set_custom_sprite(new_material: ShaderMaterial, state: int) -> ShaderMaterial:
	print_debug(state)
	## Override the state if we are being affected by rage
	if (real_form != transformation.FORM_CALM):
		state = real_form
	## Capture the sprite picture just before we are exploding it
	var image_shaded: Image = ViewPort.get_texture().get_image()
	var texture_shaded: ImageTexture = ImageTexture.create_from_image(image_shaded)
	new_material.set_shader_parameter("sprite", texture_shaded)
	## This is currently baked in as a hardcoded option unless we need some other effects
	ParticleGen.texture = ParticleTexture
	return new_material

func flash() -> void:
	PlayerSprite.material = SpriteMaterial[transformation.FORM_NORMAL]
	(PlayerSprite.material as ShaderMaterial).set_shader_parameter("flash_modifier", 1)
	await get_tree().create_timer(0.05).timeout
	(PlayerSprite.material as ShaderMaterial).set_shader_parameter("flash_modifier", 0)	

func _on_hitbox_area_entered(_area: Area2D) -> void:
	pass
#	print_debug("Player hit by area: ", area.name)

func _on_hitbox_body_entered(body: Node2D) -> void:
	#print_debug("Collision with ", body.name)
	# TODO fixme in the end, ugly
	match body.name:
		"Forest_Tree", "forest_tree_1", "forest_tree_2":
			body.rotate(deg_to_rad(-90.0))

func show_form() -> void:
	print_debug("Form: ", current_form)

func _on_gpu_particles_2d_finished() -> void:
	pass
	#print_debug("Player shader emission finished")
	
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
