extends Area2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		# 1. Disable trophy collision to avoid double triggering
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 3. Trigger the player's disappear sequence
		if body.has_method("play_disappear"):
			await body.play_disappear()
		
		if is_inside_tree():
			get_tree().reload_current_scene()
		else:
			# Fallback if the node was removed during the await
			Engine.get_main_loop().reload_current_scene()
