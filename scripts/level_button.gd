extends Button

var level_number: int = 1

func setup(num: int) -> void:
	level_number = num
	var texture_path = "res://assets/levels/%d.png" % num
	if ResourceLoader.exists(texture_path):
		icon = load(texture_path) as Texture2D
	else:
		push_warning("Icon missing for level: ", num)

func _on_pressed() -> void:
	# Change scene dynamically or pass level data
	var scene_path = "res://levels/level_%d.tscn" % level_number
	get_tree().change_scene_to_file(scene_path)
