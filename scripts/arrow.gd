extends Area2D

@export var bounce: int = -400
@export var cooldown: int = 3

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(_on_enter)
	
func _on_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity.y = bounce

		collision.set_deferred("disabled", true)
		sprite.play('hit')
		await sprite.animation_finished
		
		hide()
		
		if cooldown != 0:
			get_tree().create_timer(cooldown).timeout\
			.connect(_on_cooldown_finished)
			
func _on_cooldown_finished():
	collision.set_deferred("disabled", false)
	show()
	sprite.play_backwards("hit")
	await sprite.animation_finished
	sprite.play("default")
