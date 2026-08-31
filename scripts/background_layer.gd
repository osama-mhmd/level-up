extends CanvasLayer

func _physics_process(_delta: float) -> void:
	offset.y += 1
	if offset.y >= 320:
		offset.y = 0 # Reset
