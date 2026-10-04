extends CharacterBody2D

@export var move_speed: float = 160.0

var last_move_direction: Vector2 = Vector2.DOWN

@onready var facing_indicator: Polygon2D = $FacingIndicator

func _ready() -> void:
	_update_facing_indicator()

func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = input_direction * move_speed

	if not input_direction.is_zero_approx():
		last_move_direction = _get_cardinal_direction(input_direction)
		_update_facing_indicator()

	move_and_slide()

func _get_cardinal_direction(direction: Vector2) -> Vector2:
	if absf(direction.x) >= absf(direction.y):
		return Vector2.RIGHT if direction.x > 0.0 else Vector2.LEFT

	return Vector2.DOWN if direction.y > 0.0 else Vector2.UP

func _update_facing_indicator() -> void:
	if last_move_direction == Vector2.UP:
		facing_indicator.position = Vector2(0.0, -50.0)
		facing_indicator.rotation = 0.0
	elif last_move_direction == Vector2.RIGHT:
		facing_indicator.position = Vector2(38.0, 0.0)
		facing_indicator.rotation = PI * 0.5
	elif last_move_direction == Vector2.LEFT:
		facing_indicator.position = Vector2(-38.0, 0.0)
		facing_indicator.rotation = -PI * 0.5
	else:
		facing_indicator.position = Vector2(0.0, 50.0)
		facing_indicator.rotation = PI

func get_facing_name() -> String:
	if last_move_direction == Vector2.UP:
		return "UP"
	if last_move_direction == Vector2.RIGHT:
		return "RIGHT"
	if last_move_direction == Vector2.LEFT:
		return "LEFT"
	return "DOWN"
