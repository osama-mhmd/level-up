class_name InteractiveElement
extends StaticBody2D

enum Direction { Top, Bottom, Left, Right }

var on: bool = true

@export var dir: Direction = Direction.Top
@export var force: int = 20

@onready var emitter := $WindParticles
@onready var area := $Area2D

var player: CharacterBody2D = null


func _ready():
	area.body_entered.connect(_handle_enter)
	area.body_exited.connect(_handle_exit)
	
	if dir == Direction.Top: pass
	elif dir == Direction.Bottom:
		emitter.gravity = Vector2(0, 980)
	elif dir == Direction.Left:
		emitter.gravity = Vector2(-980, 0)
	else: 
		emitter.gravity = Vector2(980, 0)

func trigger():
	on = not on
	emitter.emitting = on
	$Area2D/CollisionShape2D.set_deferred("disabled", \
	false if on else true)
	$AnimatedSprite2D.play("on" if on else "idle")

func _physics_process(_delta: float) -> void:
	if not player: return
	
	var x: int = 0
	var y: int = 0
	
	if dir == Direction.Top: y = -force
	elif dir == Direction.Bottom: y = force
	elif dir == Direction.Right: x = force
	else: x = -force
	
	if player.has_method("apply_force"):
		player.apply_force(Vector2(x, y))
	
	
func _handle_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body

func _handle_exit(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = null
