extends Control

@onready var grid_container: GridContainer = $Camera2D/MarginContainer/GridContainer

func _ready() -> void:
	# Clean up any existing placeholder nodes in the container
	for child in grid_container.get_children():
		child.queue_free()
		
	# Create a reusable transparent stylebox instead of setting flat = true
	var transparent_style := StyleBoxFlat.new()
	transparent_style.bg_color = Color(0, 0, 0, 0) # Fully transparent
		
	# Spawn 50 level buttons directly
	for i in range(1, 51):
		var btn := Button.new()
		
		# 1. Configure Icon & Sizing
		btn.icon_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		btn.expand_icon = true
		btn.custom_minimum_size = Vector2(48, 48)
		
		# Override 'normal' state with transparent stylebox to fix min size issues
		btn.add_theme_stylebox_override("normal", transparent_style)
		btn.add_theme_stylebox_override("hover", transparent_style)
		btn.add_theme_stylebox_override("pressed", transparent_style)
		
		if GameManager.current_level < i: 
			btn.disabled = true
		
		# 2. Load Icon (.png image, not .tscn)
		var texture_path := "res://assets/levels/%d.png" % i
		if ResourceLoader.exists(texture_path):
			btn.icon = load(texture_path) as Texture2D
		
		# 3. Add to GridContainer
		grid_container.add_child(btn)
		
		# 4. Connect Click Signal using a lambda to pass the level number
		btn.pressed.connect(func(): _on_level_selected(i))

func _on_level_selected(level_num: int) -> void:
	var scene_path := "res://scenes/level_%d.tscn" % level_num
	if ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
	else:
		print("Level scene not found: ", scene_path)
