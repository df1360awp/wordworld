extends Node2D

const WORLD_HALF_SIZE := Vector2(1500.0, 1000.0)
const GRID_STEP := 100
const MAJOR_GRID_STEP := 500

const BACKGROUND_COLOR := Color(0.075, 0.085, 0.11, 1.0)
const MINOR_GRID_COLOR := Color(0.17, 0.19, 0.24, 1.0)
const MAJOR_GRID_COLOR := Color(0.31, 0.34, 0.42, 1.0)
const BORDER_COLOR := Color(0.5, 0.53, 0.62, 1.0)
const X_AXIS_COLOR := Color(0.95, 0.35, 0.35, 1.0)
const Y_AXIS_COLOR := Color(0.35, 0.85, 0.5, 1.0)
const ORIGIN_COLOR := Color(1.0, 0.82, 0.3, 1.0)

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var world_rect := Rect2(-WORLD_HALF_SIZE, WORLD_HALF_SIZE * 2.0)
	draw_rect(world_rect, BACKGROUND_COLOR, true)
	draw_rect(world_rect, BORDER_COLOR, false, 4.0)

	for x in range(int(-WORLD_HALF_SIZE.x), int(WORLD_HALF_SIZE.x) + 1, GRID_STEP):
		if x == 0:
			continue
		var is_major := x % MAJOR_GRID_STEP == 0
		var color := MAJOR_GRID_COLOR if is_major else MINOR_GRID_COLOR
		var width := 2.0 if is_major else 1.0
		draw_line(
			Vector2(float(x), -WORLD_HALF_SIZE.y),
			Vector2(float(x), WORLD_HALF_SIZE.y),
			color,
			width
		)

	for y in range(int(-WORLD_HALF_SIZE.y), int(WORLD_HALF_SIZE.y) + 1, GRID_STEP):
		if y == 0:
			continue
		var is_major := y % MAJOR_GRID_STEP == 0
		var color := MAJOR_GRID_COLOR if is_major else MINOR_GRID_COLOR
		var width := 2.0 if is_major else 1.0
		draw_line(
			Vector2(-WORLD_HALF_SIZE.x, float(y)),
			Vector2(WORLD_HALF_SIZE.x, float(y)),
			color,
			width
		)

	_draw_axes()

func _draw_axes() -> void:
	draw_line(
		Vector2(-WORLD_HALF_SIZE.x, 0.0),
		Vector2(WORLD_HALF_SIZE.x, 0.0),
		X_AXIS_COLOR,
		4.0
	)
	draw_line(
		Vector2(0.0, -WORLD_HALF_SIZE.y),
		Vector2(0.0, WORLD_HALF_SIZE.y),
		Y_AXIS_COLOR,
		4.0
	)

	# Positive X arrow.
	draw_line(Vector2(WORLD_HALF_SIZE.x, 0.0), Vector2(WORLD_HALF_SIZE.x - 24.0, -12.0), X_AXIS_COLOR, 4.0)
	draw_line(Vector2(WORLD_HALF_SIZE.x, 0.0), Vector2(WORLD_HALF_SIZE.x - 24.0, 12.0), X_AXIS_COLOR, 4.0)

	# Positive Y points downward in Godot 2D coordinates.
	draw_line(Vector2(0.0, WORLD_HALF_SIZE.y), Vector2(-12.0, WORLD_HALF_SIZE.y - 24.0), Y_AXIS_COLOR, 4.0)
	draw_line(Vector2(0.0, WORLD_HALF_SIZE.y), Vector2(12.0, WORLD_HALF_SIZE.y - 24.0), Y_AXIS_COLOR, 4.0)

	# World origin marker.
	draw_circle(Vector2.ZERO, 10.0, ORIGIN_COLOR)
	draw_line(Vector2(-28.0, 0.0), Vector2(28.0, 0.0), ORIGIN_COLOR, 2.0)
	draw_line(Vector2(0.0, -28.0), Vector2(0.0, 28.0), ORIGIN_COLOR, 2.0)

	var font := ThemeDB.fallback_font
	var font_size := 20
	draw_string(font, Vector2(52.0, -16.0), "X AXIS +", HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, X_AXIS_COLOR)
	draw_string(font, Vector2(12.0, 66.0), "Y AXIS +", HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, Y_AXIS_COLOR)
	draw_string(font, Vector2(16.0, -40.0), "ORIGIN (0, 0)", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, ORIGIN_COLOR)
	draw_string(font, Vector2(WORLD_HALF_SIZE.x - 54.0, -16.0), "X+", HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, X_AXIS_COLOR)
	draw_string(font, Vector2(12.0, WORLD_HALF_SIZE.y - 16.0), "Y+", HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, Y_AXIS_COLOR)
