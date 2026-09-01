extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
#@onready var dust_emitter: CPUParticles2D = $DustEmitter

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

var is_disappearing: bool = false
var ext_force: Vector2 = Vector2.ZERO

# Fetch default gravity setting from Project Settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var max_jumps: int = 2
var jumps_left: int = 2
var is_wall_jumping: bool = false

func _physics_process(delta):
	var on_wall: bool = is_on_wall()
	var on_floor: bool = is_on_floor()
	
	if is_disappearing:
		return
		
	# Handle flips depending on direction
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

	# Play animations based on movement state
	if not on_floor:
		velocity.y += gravity * delta
		if velocity.y < 0:
			if jumps_left == 1:
				animated_sprite.play("jump")
			else:
				animated_sprite.play('double_jump')
		else:
			animated_sprite.play("fall")
	else:
		jumps_left = max_jumps # Reset jump count on reaching ground
		
		if velocity.x != 0:
			animated_sprite.play("run") 
		else:
			animated_sprite.play("idle")
			#dust_emitter.emitting = false
			
	_on_animated_sprite_2d_frame_changed()
	if Input.is_action_just_pressed("ui_accept"):
		if on_floor or jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1
			if on_wall and not on_floor:
				velocity.x = get_wall_normal().x * 100
				is_wall_jumping = true
				get_tree().create_timer(0.15).timeout.connect(func(): is_wall_jumping = false)
			
	if is_on_wall() and not is_on_floor():
		animated_sprite.play("wall")
		jumps_left = max_jumps
		if velocity.y >0: velocity.y = min(velocity.y, 60)
		
	var direction = Input.get_axis("ui_left", "ui_right")

	if not is_wall_jumping:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity += ext_force
	ext_force = Vector2.ZERO
	
	move_and_slide()
	
func apply_force(vec: Vector2) -> void:
	ext_force = vec

func play_disappear():
	$CollisionShape2D.set_deferred("disabled", true)
	
	is_disappearing = true
	velocity = Vector2.ZERO # Stop all movement instantly
	animated_sprite.play("disappear")
	
	await animated_sprite.animation_finished
	
	hide()
	
func die():
	await play_disappear()
	
	if is_inside_tree(): 
		get_tree().reload_current_scene()

func bounce():
	velocity.y = JUMP_VELOCITY * 1.25
	
func _on_animated_sprite_2d_frame_changed() -> void:
	pass
	#if animated_sprite.animation == "run" and (animated_sprite.frame == 1 or animated_sprite.frame == 4):
		#dust_emitter.restart()
