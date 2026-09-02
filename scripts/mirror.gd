extends Node2D

@onready var reflection: AnimatedSprite2D = $GlassMask/ReflectionSprite
@onready var area: Area2D = $ProximityArea

var player: CharacterBody2D = null

func _ready():
	area.body_entered.connect(_on_body_enter)
	area.body_exited.connect(_on_body_exit)
	
func _on_body_enter(body: Node2D) -> void:
	reflection.visible = true
	if body is CharacterBody2D:
		player = body
	
func _on_body_exit(_body):
	reflection.visible = false
	player = null
	
func _process(_delta):
	if not player or not reflection.visible:
		return
	
	var player_x_offset = player.global_position.x - global_position.x
	reflection.global_position.x = global_position.x - player_x_offset
	reflection.global_position.y = player.global_position.y
	
	var player_sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
	reflection.sprite_frames = player_sprite.sprite_frames
	reflection.animation = player_sprite.animation
	reflection.frame = player_sprite.frame
	reflection.flip_h = not player_sprite.flip_h
