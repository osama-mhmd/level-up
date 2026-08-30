extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound := $AudioStreamPlayer2D
@onready var collision := $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite.play('default')

func _on_body_entered(body: Node2D) -> void:
	sound.pitch_scale = randf_range(0.75, 1.25)
	sound.play()
	
	if body is CharacterBody2D:
		collision.set_deferred('disabled', true)
		sprite.play('collected')
		await sprite.animation_finished
		GameManager.add_xp(100)
		queue_free()
