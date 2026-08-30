# game_manager.gd
extends Node

# Persistent Stats
var player_xp: int = 0
var current_level: int = 1

# Signals (Optional: Notify UI when stats change)
signal xp_changed(new_xp)
signal level_up(new_level)

func add_xp(amount: int) -> void:
	player_xp += amount
	xp_changed.emit(player_xp)
	save_game()
	
func _on_level_up(val = 0) -> void:
	if val:
		current_level = val
	else:
		current_level += 1
	save_game()

const SAVE_PATH = "user://savegame.json"

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = { "xp": player_xp, "level": current_level }
	file.store_string(JSON.stringify(data))

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		player_xp = data.get("xp", 0)
		current_level = data.get("level", 1)

func _ready():
	level_up.connect(_on_level_up)
	load_game()
