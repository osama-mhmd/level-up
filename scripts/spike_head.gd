extends CharacterBody2D

enum TrapMode { CLOCKWISE, HORIZONTAL, VERTICAL, ANTI_CLOCKWISE }

@export var current_mode: TrapMode = TrapMode.HORIZONTAL
@export var move_acc = 200

@onready var sprite = $AnimatedSprite2D

var x_dir = 0;
var y_dir = 0;

func _ready():
	sprite.play('idle')
	
	if current_mode == TrapMode.CLOCKWISE or current_mode == TrapMode.HORIZONTAL:
		x_dir = 1
	elif current_mode == TrapMode.ANTI_CLOCKWISE:
		x_dir = -1
	else: # VERTICAL
		y_dir = 1

var wall_hit = false
var vertical_hit = false

func _physics_process(delta: float) -> void:	
	if is_on_wall() and not wall_hit:
		wall_hit = true
		
		if x_dir == 1: sprite.play('right-hit')
		else: sprite.play('left-hit')
		
		await sprite.animation_finished
		
		sprite.play('idle')
		
		await get_tree().create_timer(1.5).timeout
		
		if current_mode == TrapMode.HORIZONTAL: x_dir *= -1
		elif current_mode == TrapMode.CLOCKWISE: 
			y_dir = x_dir
			x_dir = 0
		else: # Anti clockwise
			y_dir = -x_dir
			x_dir = 0
	elif not is_on_wall():
		wall_hit = false
		
	if (is_on_floor() or is_on_ceiling()) and not vertical_hit:
		vertical_hit = true
		
		if y_dir == 1: sprite.play('bottom-hit')
		else: sprite.play('top-hit')
		
		await sprite.animation_finished
		
		sprite.play('idle')
		
		await get_tree().create_timer(1.5).timeout
		
		if current_mode == TrapMode.VERTICAL: y_dir *= -1
		elif current_mode == TrapMode.CLOCKWISE: 
			x_dir = -y_dir
			y_dir = 0
		else: # Anti Clockwise
			x_dir = y_dir
			y_dir = 0
		
	if not is_on_floor() and not is_on_ceiling():
		vertical_hit = false
	
	if x_dir != 0: velocity.x += x_dir * move_acc * delta
	else: velocity.x = 0
	if y_dir != 0: velocity.y += y_dir * move_acc * delta
	else: velocity.y = 0 
	
	move_and_slide()
