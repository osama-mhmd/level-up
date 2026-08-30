extends Area2D

var player: CharacterBody2D = null

func _ready():
	body_entered.connect(_handle_enter)
	body_exited.connect(_handle_exit)
	
func _physics_process(_delta: float) -> void:
	if player: player.velocity.y -= 20
	
func _handle_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body

func _handle_exit(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = null
