extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var area := $Area2D
@onready var hurt_area := $HurtBox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: CharacterBody2D = null
var last_player_position: float # x-axis
var is_attacking: bool = false
var is_being_damaged: bool = false

@export var speed: float = 90
@export var health_points: int = 2

func _ready() -> void:
	area.body_entered.connect(func(body): player = body)
	area.body_exited.connect(_on_area_exited)
	hurt_area.body_entered.connect(_on_hurt)
	
func _on_hurt(body: Node2D):
	
	is_being_damaged = true
	
	if body.has_method('bounce'):
		body.bounce()
	
	health_points -= 1
	if health_points > 0:
		sprite.play("hit")
	else:
		sprite.play("die")
		$CollisionShape2D.set_deferred("disabled", true)
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	
	await sprite.animation_finished
	is_being_damaged = false

func _on_area_exited(body: Node2D) -> void:
	player = null
	last_player_position = body.global_position.x

func _physics_process(delta: float) -> void:
	if is_being_damaged or not health_points: return
	if is_attacking: 
		var should_move = sprite.frame > 3 and sprite.frame < 6 and sprite.animation == 'attack'
		
		if should_move: velocity.x += speed / 3
		else: velocity.x = 0
		
		move_and_slide()

		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player:
		var space: float = player.global_position.x - global_position.x
		
		var right: bool = space > 0
		
		# Face direction
		sprite.flip_h = right
		
		if abs(space) <= 35:
			_attack(right)
		else:
			velocity.x = speed
			sprite.play('run')
		velocity.x *= 1 if right else -1
	else:
		velocity.x = 0
		
		sprite.play('idle')

	move_and_slide()

func _attack(right: bool) -> void:
	is_attacking = true
	
	if not right: speed *= -1
	sprite.play('attack')
	
	await sprite.animation_finished
	
	var space: float = 999 if right else -999
	
	if player:
		space = player.global_position.x - self.global_position.x
		
	if (space <= 35 and right) or (space >= -35 and not right): 
		if player.has_method("die"): player.die()
		sprite.play("attack_2")
		await sprite.animation_finished
		sprite.play('idle')
	else:
		sprite.play("attack_2")
		await sprite.animation_finished
		sprite.play('stun')
		await sprite.animation_finished
		is_attacking = false

	if not right: speed *= -1
