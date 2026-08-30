# HUD.gd
extends CanvasLayer

@onready var label = $Label

func _ready() -> void:
	# Connect to the signal
	GameManager.xp_changed.connect(_on_xp_changed)
	
	# Set initial visual state once on load
	_on_xp_changed(GameManager.player_xp)

func _on_xp_changed(new_xp: int) -> void:
	label.text = str(new_xp) + ' XP'
