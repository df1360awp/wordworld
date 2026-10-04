extends CharacterBody2D

@export var move_speed: float = 160.0
@export var walk_animation_fps: float = 8.0

var last_move_direction: Vector2 = Vector2.DOWN
var is_moving: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	_configure_animation_speeds()
	_update_animation()


func _physics_process(_delta: float) -> void:
	var input_direction := _get_input()
	_update_facing(input_direction)
	_update_movement(input_direction)
	_update_animation()


func _get_input() -> Vector2:
	return Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)


func _update_facing(input_direction: Vector2) -> void:
	if input_direction.is_zero_approx():
		return

	var abs_x := absf(input_direction.x)
	var abs_y := absf(input_direction.y)

	if abs_x > abs_y:
		last_move_direction = Vector2.RIGHT if input_direction.x > 0.0 else Vector2.LEFT
	elif abs_y > abs_x:
		last_move_direction = Vector2.DOWN if input_direction.y > 0.0 else Vector2.UP
	# Equal diagonal input keeps the previous facing direction.


func _update_movement(input_direction: Vector2) -> void:
	is_moving = not input_direction.is_zero_approx()
	velocity = input_direction * move_speed
	move_and_slide()


func _update_animation() -> void:
	var target_animation := _get_target_animation()

	if animated_sprite.animation != target_animation or not animated_sprite.is_playing():
		animated_sprite.play(target_animation)


func _get_target_animation() -> StringName:
	var movement_prefix := "walk" if is_moving else "idle"
	return StringName(movement_prefix + "_" + _get_facing_suffix())


func _get_facing_suffix() -> String:
	if last_move_direction == Vector2.UP:
		return "up"
	if last_move_direction == Vector2.LEFT:
		return "left"
	if last_move_direction == Vector2.RIGHT:
		return "right"
	return "down"


func _configure_animation_speeds() -> void:
	var walk_animations: Array[StringName] = [
		&"walk_down",
		&"walk_up",
		&"walk_left",
		&"walk_right"
	]

	for animation_name in walk_animations:
		if animated_sprite.sprite_frames.has_animation(animation_name):
			animated_sprite.sprite_frames.set_animation_speed(
				animation_name,
				walk_animation_fps
			)


func get_facing_name() -> String:
	if last_move_direction == Vector2.UP:
		return "UP"
	if last_move_direction == Vector2.LEFT:
		return "LEFT"
	if last_move_direction == Vector2.RIGHT:
		return "RIGHT"
	return "DOWN"


func get_movement_name() -> String:
	return "WALK" if is_moving else "IDLE"


func get_current_animation_name() -> String:
	return String(animated_sprite.animation)
