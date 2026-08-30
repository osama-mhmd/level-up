extends Node2D

@export var swing_speed: float = 2.0        
@export var max_angle_degrees: float = 45.0  # Set to 360 for full continuous spin

var time_passed: float = 0.0
var initial_rotation: float = 0.0

func _ready() -> void:
	# Save the initial rotation you set in the editor (in radians)
	initial_rotation = rotation

func _process(delta: float) -> void:
	if max_angle_degrees == 360:
		# Mode 1: Continuous 360° rotation from initial offset
		rotation += swing_speed * TAU * delta
	else:
		# Mode 2: Pendulum swing centered around your initial angle
		time_passed += delta * swing_speed
		var swing_offset = sin(time_passed) * deg_to_rad(max_angle_degrees)
		rotation = initial_rotation + swing_offset
