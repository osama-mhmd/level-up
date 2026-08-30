extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_enter)
	
func _on_enter(body: Node2D) -> void:
	if body is CharacterBody2D and body != owner:
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 3. Trigger the player's disappear sequence
		if body.has_method("play_disappear"):
			await body.play_disappear()
		
		if is_inside_tree():
			get_tree().reload_current_scene()
		else:
			# Fallback if the node was removed during the await
			Engine.get_main_loop().reload_current_scene()
	pass
