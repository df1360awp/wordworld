extends SceneTree

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load("res://scenes/main.tscn")
	if packed == null:
		_fail("Could not load main scene.")
		_finish()
		return

	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await physics_frame
	await process_frame

	var player: CharacterBody2D = game.get_node("Player")
	var world: Node2D = game.get_node("World")
	var ground: TileMapLayer = world.get_node("Ground")
	var decoration: TileMapLayer = world.get_node("Decoration")
	var blacksmith: Sprite2D = world.get_node("Architecture/Blacksmith")
	var fisherman: Sprite2D = world.get_node("Environment/FishermanPreview")
	var camera: Camera2D = player.get_node("Camera2D")

	_check(player.global_position.distance_to(Vector2(350, 850)) < 0.5, "Player spawns inside AuntHouse at (350, 850).")
	_check(ground.get_used_cells().size() > 1000, "Ground TileMapLayer is populated.")
	_check(decoration.get_used_cells().size() > 10, "Decoration TileMapLayer is populated.")
	_check(blacksmith.texture != null, "Blacksmith preview art is loaded.")
	_check(fisherman.texture != null, "Riverside fisherman preview art is loaded.")
	_check(camera.enabled, "Player Camera2D is enabled.")
	_check(
		camera.limit_left == 0 and camera.limit_top == 0
		and camera.limit_right == 2400 and camera.limit_bottom == 1600,
		"Camera2D limits remain 0,0,2400,1600."
	)

	# Verify the aunt house wall blocks movement, then reset.
	player.global_position = Vector2(350, 850)
	await physics_frame
	await _hold(["move_left"], 1.2)
	_check(player.global_position.x > 205.0, "AuntHouse wall collision blocks the player.")
	player.global_position = Vector2(350, 850)
	await physics_frame

	# Door opening: moving south from spawn must leave the house.
	await _hold(["move_down"], 0.9)
	_check(player.global_position.y > 950.0, "Player can leave AuntHouse through the courtyard door.")

	# Cardinal and diagonal movement on open ground.
	player.global_position = Vector2(1000, 900)
	await physics_frame
	var start := player.global_position
	await _hold(["move_up"], 0.25)
	_check(player.global_position.y < start.y, "move_up moves player upward.")

	start = player.global_position
	await _hold(["move_down"], 0.25)
	_check(player.global_position.y > start.y, "move_down moves player downward.")

	start = player.global_position
	await _hold(["move_left"], 0.25)
	_check(player.global_position.x < start.x, "move_left moves player left.")

	start = player.global_position
	await _hold(["move_right"], 0.25)
	_check(player.global_position.x > start.x, "move_right moves player right.")

	player.global_position = Vector2(1000, 900)
	await physics_frame
	start = player.global_position
	await _hold(["move_up", "move_right"], 0.3)
	_check(player.global_position.x > start.x and player.global_position.y < start.y, "Diagonal movement works.")

	# Sample per-physics-frame displacement to catch positional hopping/jitter.
	player.global_position = Vector2(1000, 900)
	await physics_frame
	var deltas: Array[float] = []
	Input.action_press("move_right")
	var previous_x := player.global_position.x
	for _i in range(12):
		await physics_frame
		var delta_x := player.global_position.x - previous_x
		deltas.append(delta_x)
		previous_x = player.global_position.x
	Input.action_release("move_right")
	await physics_frame
	var smooth := true
	for delta_x in deltas:
		if delta_x < 2.0 or delta_x > 3.2:
			smooth = false
			break
	_check(smooth, "Player movement is smooth without positional hopping.")

	# The river is blocked except at the preserved wooden bridge opening.
	player.global_position = Vector2(1625, 1085)
	await physics_frame
	await _hold(["move_down"], 2.0)
	_check(player.global_position.y > 1400.0, "Player can reach/cross the river using the bridge gap.")

	# The east boundary intentionally leaves the village gate corridor open.
	player.global_position = Vector2(2300, 820)
	await physics_frame
	await _hold(["move_right"], 0.8)
	_check(player.global_position.x > 2400.0, "Player can leave through the east village gate.")

	# Capture an actual rendered viewport around the village center.
	player.global_position = Vector2(1200, 820)
	await physics_frame
	await process_frame
	await process_frame
	var screenshot := root.get_texture().get_image()
	var screenshot_path := ProjectSettings.globalize_path("res://qingfeng_v04_runtime.png")
	var save_error := screenshot.save_png(screenshot_path)
	_check(save_error == OK, "Runtime screenshot saved.")
	print("SCREENSHOT_PATH=", screenshot_path)

	_finish()


func _hold(actions: Array[String], seconds: float) -> void:
	for action in actions:
		Input.action_press(action)
	var frames := maxi(1, int(ceil(seconds * 60.0)))
	for _i in range(frames):
		await physics_frame
	for action in actions:
		Input.action_release(action)
	await physics_frame


func _check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: ", message)
	else:
		_fail(message)


func _fail(message: String) -> void:
	failures.append(message)
	push_error("FAIL: " + message)


func _finish() -> void:
	if failures.is_empty():
		print("QINGFENG_V04_TEST_RESULT=PASS")
		quit(0)
	else:
		print("QINGFENG_V04_TEST_RESULT=FAIL")
		for message in failures:
			print(" - ", message)
		quit(1)
