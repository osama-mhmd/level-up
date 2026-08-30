extends Area2D

@onready var sprite = $AnimatedSprite2D

func _ready(): 
	sprite.play('default')
	body_entered.connect(_on_enter)

func _on_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		$CollisionShape2D.set_deferred("disabled", true)
		
		if body.has_method("play_bounce"):
			body.play_bounce()
			
		sprite.play('bounce')
		
		await sprite.animation_finished
		
		$CollisionShape2D.set_deferred('disabled', false)
		 
