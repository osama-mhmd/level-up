extends AnimatableBody2D

enum TrapMode { CLOCKWISE, HORIZONTAL, VERTICAL, ANTI_CLOCKWISE }

@export var current_mode: TrapMode = TrapMode.HORIZONTAL
@export var move_speed: float = 15

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var move_dir: Vector2 = Vector2.ZERO
var is_processing_hit: bool = false
var motion: Vector2 = Vector2.ZERO

func _ready() -> void:
	sprite.play("idle")
	_set_initial_direction()

func _physics_process(delta: float) -> void:
	if is_processing_hit:
		return

	motion += move_dir * move_speed * delta
	var collision = move_and_collide(motion, true)

	if collision:
		var normal = collision.get_normal()
		
		# If moving horizontally, ignore collisions with vertical normals (standing/riding on top)
		if move_dir.x != 0 and abs(normal.x) < 0.5:
			global_position += motion
			return
		# If moving vertically, ignore collisions with horizontal normals
		elif move_dir.y != 0 and abs(normal.y) < 0.5:
			global_position += motion
			return

		var collider = collision.get_collider()
		
		if collider is CharacterBody2D:
			_handle_player_collision(collider)
		else:
			_handle_wall_collision(collision)
	else:
		global_position += motion

func _handle_player_collision(player: CharacterBody2D) -> void:
	# Test if player has a wall behind them in the direction of motion
	var player_wall_test = player.move_and_collide(motion, true)

	if player_wall_test and not (player_wall_test.get_collider() is CharacterBody2D):
		# Player is trapped against a wall -> Crush!
		if player.has_method("die"):
			player.die()
	else:
		# Move player position directly, then move Smash Head position
		player.global_position += motion
		global_position += motion

func _handle_wall_collision(collision: KinematicCollision2D) -> void:
	is_processing_hit = true
	
	global_position += (collision.get_travel() * 3) / 4
	motion = Vector2.ZERO # Reset speed
	
	var normal = collision.get_normal()

	if normal.x < 0:
		sprite.play("right-hit")
	elif normal.x > 0:
		sprite.play("left-hit")
	elif normal.y < 0:
		sprite.play("bottom-hit")
	elif normal.y > 0:
		sprite.play("top-hit")

	await sprite.animation_finished
	sprite.play("idle")
	await get_tree().create_timer(1.5).timeout

	_update_direction()
	is_processing_hit = false

func _set_initial_direction() -> void:
	match current_mode:
		TrapMode.CLOCKWISE, TrapMode.HORIZONTAL:
			move_dir = Vector2.RIGHT
		TrapMode.ANTI_CLOCKWISE:
			move_dir = Vector2.LEFT
		TrapMode.VERTICAL:
			move_dir = Vector2.DOWN

func _update_direction() -> void:
	match current_mode:
		TrapMode.HORIZONTAL:
			move_dir.x *= -1
		TrapMode.VERTICAL:
			move_dir.y *= -1
		TrapMode.CLOCKWISE:
			move_dir = Vector2(-move_dir.y, move_dir.x)
		TrapMode.ANTI_CLOCKWISE:
			move_dir = Vector2(move_dir.y, -move_dir.x)
