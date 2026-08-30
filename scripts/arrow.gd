extends Area2D

@export var bounce: int = -400

func _ready() -> void:
	body_entered.connect(_on_enter)
	
func _on_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity.y = bounce

		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play('hit')
		await $AnimatedSprite2D.animation_finished
		
		hide()
