extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var key_prompt: Node2D = $KeyBinding
@onready var label: Label = $KeyBinding/Label

@export var cooldown: int = 3
@export var target_node: InteractiveElement

var is_player_in: bool = false
var pressed: bool = false
var tween: Tween

func _ready() -> void:
	# Initialize key prompt to be invisible and slightly scaled down
	if key_prompt:
		key_prompt.modulate.a = 0.0
		key_prompt.scale = Vector2(0.8, 0.8)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Text
	var text = _get_interact_key_name()
	label.text = text

func _on_body_entered(_body: Node2D) -> void:
	is_player_in = true
	if not pressed: _animate_prompt(true)

func _on_body_exited(_body: Node2D) -> void:
	is_player_in = false
	_animate_prompt(false)

func _unhandled_input(event: InputEvent) -> void:
	
	if not pressed and event.is_action_pressed("ui_interact") and is_player_in:
		sprite.play("default")
		
		# Call _action that perform trigger on the target node
		_action()
		
		# Hide prompt immediately upon activation
		_animate_prompt(false)
		
		if cooldown != 0:
			get_tree().create_timer(cooldown).timeout.connect(_on_cooldown_finished)
		
		pressed = true

func _action() -> void:
	if target_node and target_node.has_method("trigger"):
		target_node.trigger()

func _on_cooldown_finished() -> void:
	sprite.play("reverse")
	pressed = false
	# If player is still standing inside after cooldown, bring back the prompt
	if is_player_in:
		_animate_prompt(true)

func _animate_prompt(show: bool) -> void:
	if not key_prompt:
		return
		
	if tween and tween.is_running():
		tween.kill() # Interrupt ongoing animation to prevent overlap
	
	tween = create_tween().set_parallel(true)
	
	var target_alpha: float = 1.0 if show else 0.0
	var target_scale: Vector2 = Vector2.ONE if show else Vector2(0.8, 0.8)
	var ease_type: Tween.EaseType = Tween.EASE_OUT if show else Tween.EASE_IN
	
	# Smoothly fade opacity
	tween.tween_property(key_prompt, "modulate:a", target_alpha, 0.2)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(ease_type)
		
	# Smoothly scale (with a slight pop effect when appearing)
	tween.tween_property(key_prompt, "scale", target_scale, 0.2)\
		.set_trans(Tween.TRANS_BACK if show else Tween.TRANS_CUBIC).set_ease(ease_type)

func _get_interact_key_name() -> String:
	var events := InputMap.action_get_events("ui_interact")
	if events.size() > 0:
		# Returns clean text like "E", "Space", "Controller Button 0", etc.
		return events[0].as_text().split(" ")[0] 
	return ""
