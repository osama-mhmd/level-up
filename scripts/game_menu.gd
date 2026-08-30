extends Control

@onready var StartButton = $MarginContainer/VBoxContainer/StartButton
@onready var QuitButton = $MarginContainer/VBoxContainer/QuitButton

func _ready():
	StartButton.pressed.connect(_show_levels)
	QuitButton.pressed.connect(_on_quit_pressed)
	
func _show_levels():
	get_tree().change_scene_to_file("res://scenes/levels_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
