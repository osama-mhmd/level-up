extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hearts = {
	1: $"../BossHearts/Heart1",
	2: $"../BossHearts/Heart2",
	3: $"../BossHearts/Heart3"
}

@export var player: CharacterBody2D

var speed: int = 180
var is_attacking: bool = false
var is_being_damaged: bool = false
var player_on_right: bool = false
var health_points: int = 3

var border_left: int = -60
var border_right: int = 580
var top_border: int = 220

func _physics_process(_delta: float) -> void:
	if not player or is_being_damaged: return
	
	var playerX: float = player.global_position.x
	var playerY: float = player.global_position.y
	var space = playerX - global_position.x
	
	if sprite.animation == "attack" and sprite.frame == 4:
		global_position.x += 35 if player_on_right else -35
		if global_position.x <= border_left:
			global_position.x = border_left
		if player_on_right and space >= -50 and space < -10 and playerY >= top_border \
		or (not player_on_right and space <= 50 and space > 10 and playerY >= top_border): 
			if player.has_method("die"):
				player.die()
			
	if is_attacking: return
	if not is_on_floor():
		velocity.y += 20
	if player:
		player_on_right = space > 0
		
		velocity.x = speed if player_on_right else -speed
		sprite.flip_h = not player_on_right
		if abs(space) <= 80 and playerY >= top_border:
			_attack()
		elif playerY >= top_border and playerX > border_left and playerX < border_right:
			sprite.play("run")
		else: 
			velocity.x = 0
			sprite.play("idle")
	move_and_slide()
	
func _attack():
	is_attacking = true
	sprite.play("attack")
	await sprite.animation_finished
	sprite.play("idle")
	await get_tree().create_timer(1).timeout
	is_attacking = false

func damage():
	print("called")
	is_being_damaged = true
	hearts[health_points].play("default")
	health_points -= 1
	if health_points == 0:
		hide()
	sprite.play("hit")
	await sprite.animation_finished
	sprite.play("idle")
	await get_tree().create_timer(1).timeout
	is_being_damaged = false
