extends CanvasLayer

@onready var resume_button: Button = $MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

var is_pausable: bool = true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Ensures the menu runs while paused
	resume_button.pressed.connect(_resume_level)
	quit_button.pressed.connect(_on_quit_pressed)
	hide()
	
	GameManager.level_up.connect(_on_game_won)
		
func _on_game_won() -> void:
	is_pausable = false
	
	await get_tree().create_timer(1).timeout
	
	is_pausable = true

func _unhandled_input(event: InputEvent) -> void:
	if is_pausable and event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause() -> void:
	var is_paused := !get_tree().paused
	get_tree().paused = is_paused
	visible = is_paused

func _resume_level() -> void:
	get_tree().paused = false
	hide()

func _on_quit_pressed() -> void:
	_resume_level()
	get_tree().change_scene_to_file("res://scenes/game_menu.tscn")
