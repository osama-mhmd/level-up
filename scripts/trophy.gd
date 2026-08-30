extends Area2D

@export var next_level: PackedScene
@onready var sprite = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	sprite.play("idle")

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		# 1. Disable trophy collision to avoid double triggering
		$CollisionShape2D.set_deferred("disabled", true)
		
		GameManager.level_up.emit()
		
		# 2. Play trophy animation
		sprite.play("activated")
		
		# 3. Trigger the player's disappear sequence
		if body.has_method("play_disappear"):
			await body.play_disappear()
		
		await sprite.animation_finished

		# 4. Change level
		if next_level:
			get_tree().change_scene_to_packed(next_level)
		else:
			print("No next level assigned!")
			get_tree().change_scene_to_file("res://scenes/levels_menu.tscn")
		
