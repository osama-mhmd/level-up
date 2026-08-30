extends AnimatableBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var solid_collision: CollisionShape2D = $CollisionShape2D
@onready var detection_area: Area2D = $Area2D

var is_falling: bool = false
var fall_speed: float = 300.0

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	sprite.play("on")

func _physics_process(delta: float) -> void:
	if is_falling:
		# Move the platform down
		position.y += fall_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_falling:
		# Wait 1 second before disabling collision and dropping
		await get_tree().create_timer(0.3).timeout
		
		is_falling = true
		
		sprite.play("off")
 		
		# Optional: remove platform after 3 seconds to clean up memory
		await get_tree().create_timer(3.0).timeout
		queue_free()
