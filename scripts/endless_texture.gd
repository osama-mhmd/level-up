extends TextureRect

@export var scroll_speed: Vector2 = Vector2(50, 50)

func _ready() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

func _process(delta: float) -> void:
	# Shifts texture UVs endlessly without moving the node boundaries
	pivot_offset -= scroll_speed * delta
