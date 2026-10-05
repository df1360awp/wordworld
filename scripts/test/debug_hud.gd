extends CanvasLayer

@onready var player = get_node("../Player")
@onready var stats_label: Label = $StatsLabel


func _process(_delta: float) -> void:
	if not is_instance_valid(player):
		return

	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	var collision_state := "BLOCKED" if player.get_slide_collision_count() > 0 else "CLEAR"

	stats_label.text = (
		"Player Position:\n"
		+ "X: %.1f\n" % player.global_position.x
		+ "Y: %.1f\n\n" % player.global_position.y
		+ "Velocity:\n"
		+ "X: %.1f\n" % player.velocity.x
		+ "Y: %.1f\n\n" % player.velocity.y
		+ "Facing:\n%s\n\n" % player.get_facing_name()
		+ "Movement:\n%s\n\n" % player.get_movement_name()
		+ "Animation:\n%s\n\n" % player.get_current_animation_name()
		+ "Character Asset:\n%s\n\n" % player.get_character_asset_status()
		+ "Map Area:\nQINGFENG_V04\n\n"
		+ "Collision:\n%s\n\n" % collision_state
		+ "Input:\n%s\n\n" % _get_input_name(input_vector)
		+ "Speed:\n%.0f" % player.move_speed
	)


func _get_input_name(input_vector: Vector2) -> String:
	if input_vector.is_zero_approx():
		return "NONE"

	if absf(input_vector.x) > absf(input_vector.y):
		return "RIGHT" if input_vector.x > 0.0 else "LEFT"

	if absf(input_vector.y) > absf(input_vector.x):
		return "DOWN" if input_vector.y > 0.0 else "UP"

	return player.get_facing_name()
