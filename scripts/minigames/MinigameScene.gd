extends Node2D

const VIEW_W := 1280.0
const VIEW_H := 720.0
const MENU_SCENE := "res://scenes/menu/MenuScene.tscn"
const ARCADE_TEXTURE_PATH := "res://assets/minigames/arcade.png"
const CCTV_LINES_TEXTURE_PATH := "res://assets/gm/sprites/sprt_cctv_lines_0.png"
const FOXY_SPRITE_BASE_PATH := "res://assets/minigames/foxy_go/foxy"
const FOXY_ENEMY_SPRITE_BASE_PATH := "res://assets/minigames/foxy_go/enemies"
const FOXY_ITEM_BASE_PATH := "res://assets/minigames/foxy_go/items"
const FOXY_LEVEL_1_BASE_PATH := "res://assets/minigames/foxy_go/level_1"
const FOXY_LEVEL_2_BASE_PATH := "res://assets/minigames/foxy_go/level_2"
const FOXY_THEME_PATH := "res://assets/minigames/foxy_go/foxy_go_go_go_theme.ogg"
const FOXY_SFX_BASE_PATH := "res://assets/minigames/foxy_go/sfx"
const FOXY_JUMPSCARE_BASE_PATH := "res://assets/gm/sprites/sprt_scare_wx"
const CCTV_NOISE_BASE_PATH := "res://assets/gm/sprites/sprt_cctv_noise"
const FOXY_JUMPSCARE_SOUND_PATH := "res://assets/gm/sounds/soun_scare_withered.wav"
const FOXY_THEME_VOLUME_OFFSET_DB := -10.0
const FOXY_SFX_VOLUME_OFFSETS := {
	"jump": -5.0,
	"land": -8.0,
	"dash": -6.0,
	"hurt": -4.0,
	"pickup": -7.0,
	"stomp": -5.0,
	"clear": -5.0,
}

const HALIGN_LEFT := 0
const HALIGN_CENTER := 1
const HALIGN_RIGHT := 2
const VALIGN_TOP := 0
const VALIGN_MIDDLE := 1

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_GRAY := Color(0.5, 0.5, 0.5, 1.0)
const COLOR_BLACK := Color(0.0, 0.0, 0.0, 1.0)
const COLOR_PURPLE := Color(0.46, 0.08, 0.62, 1.0)
const COLOR_RED := Color(0.74, 0.12, 0.05, 1.0)
const COLOR_YELLOW := Color(0.95, 0.75, 0.12, 1.0)
const COLOR_BLUE := Color(0.1, 0.25, 0.85, 1.0)
const COLOR_GREEN := Color(0.18, 0.7, 0.28, 1.0)

const ARCADE_SCREEN_RECT := Rect2(298.0, 98.0, 684.0, 528.0)
const ARCADE_SAFE_LEFT := 52.0
const ARCADE_SAFE_RIGHT := 52.0
const ARCADE_SAFE_TOP := 18.0
const ARCADE_SAFE_BOTTOM := 34.0
const PLAYER_SIZE := Vector2(34.0, 54.0)
const ENEMY_SIZE := Vector2(42.0, 38.0)
const PIZZA_SIZE := Vector2(22.0, 18.0)
const FOXY_LEVEL_COUNT := 4
const FOXY_LEVEL_LENGTH := 9000.0
const FOXY_LEVEL_TIME := 95.0
const FOXY_GROUND_Y := 444.0
const FOXY_LEVEL_1_GROUND_Y := 384.0
const FOXY_LEVEL_2_GROUND_Y := 384.0
const FOXY_GRAVITY := 1250.0
const FOXY_MOVE_SPEED := 210.0
const FOXY_JUMP_SPEED := -570.0
const FOXY_MAX_FALL_SPEED := 820.0
const FOXY_DASH_SPEED := 560.0
const FOXY_DASH_DURATION := 0.18
const FOXY_DASH_COOLDOWN := 0.22
const FOXY_ENEMY_EDGE_MARGIN := 18.0
const FOXY_HOPPER_MOVE_SPEED := 130.0
const FOXY_HOPPER_JUMP_SPEED := -360.0
const FOXY_HOPPER_GRAVITY := 1050.0
const FOXY_HOPPER_HOP_INTERVAL := 0.42
const FOXY_PICKUP_BLOCK_OFFSET := 16.0
const FOXY_COYOTE_TIME := 0.12
const FOXY_JUMP_BUFFER_TIME := 0.12
const FOXY_JUMP_HOLD_TIME := 0.18
const FOXY_JUMP_HOLD_GRAVITY_SCALE := 0.45
const FOXY_JUMP_CUT_MULTIPLIER := 0.45
const FOXY_PLAYER_HAZARD_INSET := Vector2(5.0, 5.0)
const FOXY_ENEMY_HAZARD_INSET := Vector2(6.0, 5.0)
const FOXY_SPRITE_DRAW_SIZE := Vector2(118.0, 118.0)
const FOXY_ENEMY_SPRITE_DRAW_SIZE := Vector2(94.0, 94.0)
const FOXY_PIZZA_DRAW_SIZE := Vector2(64.0, 64.0)
const FOXY_EXIT_DRAW_SIZE := Vector2(96.0, 112.0)
const FOXY_LEVEL_1_BG_SCALE := 2.75
const FOXY_LEVEL_1_TILE_SOURCE_SIZE := 16.0
const FOXY_LEVEL_1_TILE_DRAW_SIZE := 44.0
const FOXY_LEVEL_1_DECOR_SCALE := 2.75
const FOXY_LEVEL_2_TILE_SOURCE_SIZE := 16.0
const FOXY_LEVEL_2_TILE_DRAW_SIZE := 44.0
const FOXY_LEVEL_2_DECOR_SCALE := 2.75
const FOXY_JUMP_START_FRAME_TIME := 0.09
const FOXY_JUMP_RISE_FRAME_TIME := 0.18
const FOXY_LANDING_FRAME_TIME := 0.14
const FOXY_LEVEL_CLEAR_TIME := 0.75
const FOXY_ANIM_FRAME_COUNTS := {
	"idle": 4,
	"run": 4,
	"jump": 3,
	"fall": 2,
	"dash": 3,
	"dead": 4,
	"win": 3,
}
const FOXY_ANIM_SPEEDS := {
	"idle": 5.0,
	"run": 10.0,
	"jump": 8.0,
	"fall": 6.0,
	"dash": 12.0,
	"dead": 8.0,
	"win": 6.0,
}
const FOXY_ENEMY_ANIM_FRAME_COUNTS := {
	"enemy_wolf": {
		"run": 4,
		"deading": 4,
	},
	"enemy_kao": {
		"jump": 3,
		"fall": 2,
		"deading": 4,
	},
}
const FOXY_ENEMY_ANIM_SPEEDS := {
	"run": 10.0,
	"jump": 8.0,
	"fall": 6.0,
	"deading": 8.0,
}

var font_data := {}
var fallback_font: FontFile
var arcade_texture: Texture2D
var cctv_lines_texture: Texture2D
var foxy_sprite_frames := {}
var foxy_enemy_sprite_frames := {}
var foxy_item_textures := {}
var foxy_level_1_textures := {}
var foxy_level_2_textures := {}
var foxy_jumpscare_frames: Array[Texture2D] = []
var cctv_noise_frames: Array[Texture2D] = []
var foxy_jumpscare_player: AudioStreamPlayer
var foxy_theme_player: AudioStreamPlayer
var foxy_sfx_players := {}
var foxy_theme_resume_position := 0.0
var mode_id := "give_gifts"
var elapsed := 0.0
var player_pos := Vector2.ZERO
var interact_queued := false
var jump_queued := false
var dash_queued := false
var completed := false
var failed := false
var phase := 0
var round_index := 0
var time_left := 0.0
var car_x := -120.0
var targets := []

var foxy_level := 0
var foxy_world_length := FOXY_LEVEL_LENGTH
var foxy_pos := Vector2.ZERO
var foxy_velocity := Vector2.ZERO
var foxy_on_ground := false
var foxy_camera_x := 0.0
var foxy_platforms := []
var foxy_enemies := []
var foxy_pizzas := []
var foxy_pizza_count := 0
var foxy_total_pizzas := 0
var foxy_deaths := 0
var foxy_goal_rect := Rect2()
var foxy_hurt_cooldown := 0.0
var foxy_ending_phase := 0
var foxy_ending_time := 0.0
var foxy_facing := 1.0
var foxy_air_anim_time := 0.0
var foxy_landing_anim_time := 0.0
var foxy_death_anim_time := 0.0
var foxy_level_clear_time := 0.0
var foxy_level_clear_next := -1
var foxy_coyote_timer := 0.0
var foxy_jump_buffer_timer := 0.0
var foxy_jump_hold_timer := 0.0
var foxy_jump_cut_queued := false
var foxy_jump_held := false
var foxy_dash_timer := 0.0
var foxy_dash_cooldown := 0.0
var foxy_dash_anim_time := -1.0
var foxy_dash_direction := 1.0
var foxy_dash_hold_until_ground := false
var foxy_air_dash_used := false


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	GameState.finish_scene_transition()
	GameState.apply_options()
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	arcade_texture = load(ARCADE_TEXTURE_PATH)
	cctv_lines_texture = load(CCTV_LINES_TEXTURE_PATH)
	_load_foxy_sprite_frames()
	_load_foxy_enemy_sprite_frames()
	_load_foxy_item_textures()
	foxy_jumpscare_frames = _load_numbered_texture_frames(FOXY_JUMPSCARE_BASE_PATH, 64)
	cctv_noise_frames = _load_numbered_texture_frames(CCTV_NOISE_BASE_PATH, 16)
	_setup_foxy_jumpscare_audio()
	_setup_foxy_audio()
	_register_vector_font("menubt", 18, 25)
	_register_vector_font("cnsmall", 16, 22)
	_register_vector_font("footer", 12, 17)
	mode_id = GameState.active_minigame_id
	_reset_minigame()


func _exit_tree() -> void:
	font_data.clear()
	fallback_font = null
	arcade_texture = null
	cctv_lines_texture = null
	foxy_sprite_frames.clear()
	foxy_enemy_sprite_frames.clear()
	foxy_item_textures.clear()
	foxy_level_1_textures.clear()
	foxy_level_2_textures.clear()
	foxy_jumpscare_frames.clear()
	cctv_noise_frames.clear()
	foxy_jumpscare_player = null
	foxy_theme_player = null
	foxy_sfx_players.clear()
	targets.clear()
	foxy_platforms.clear()
	foxy_enemies.clear()
	foxy_pizzas.clear()


func _process(delta: float) -> void:
	elapsed += delta
	if mode_id == "foxy_go" and failed:
		foxy_death_anim_time += delta
	if not completed and not failed:
		match mode_id:
			"foxy_go":
				_update_foxy_go(delta)
			"take_cake":
				_update_take_cake(delta)
			_:
				_update_give_gifts(delta)
	interact_queued = false
	jump_queued = false
	dash_queued = false
	queue_redraw()


func _input(event: InputEvent) -> void:
	var key_event := event as InputEventKey
	if key_event == null:
		return
	if key_event.pressed and not key_event.echo:
		if key_event.keycode == KEY_ESCAPE:
			_return_to_menu()
		elif key_event.keycode == KEY_R:
			_reset_minigame()
		elif completed or failed:
			if key_event.keycode == KEY_SPACE or key_event.keycode == KEY_ENTER:
				_return_to_menu()
		elif mode_id == "foxy_go" and _is_foxy_jump_key(key_event.keycode):
			jump_queued = true
			foxy_jump_buffer_timer = FOXY_JUMP_BUFFER_TIME
			foxy_jump_held = true
		elif mode_id == "foxy_go" and _is_foxy_dash_key(key_event.keycode):
			dash_queued = true
		elif key_event.keycode == KEY_SPACE or key_event.keycode == KEY_ENTER:
			interact_queued = true
	elif not key_event.pressed and mode_id == "foxy_go" and not completed and not failed and _is_foxy_jump_key(key_event.keycode):
		foxy_jump_held = false
		foxy_jump_cut_queued = true


func _reset_minigame() -> void:
	completed = false
	failed = false
	phase = 0
	round_index = 0
	car_x = -120.0
	targets.clear()
	match mode_id:
		"foxy_go":
			_reset_foxy_game()
		"take_cake":
			player_pos = Vector2(180.0, 360.0)
			time_left = 45.0
			for child_pos in [Vector2(390.0, 220.0), Vector2(610.0, 220.0), Vector2(830.0, 220.0), Vector2(390.0, 488.0), Vector2(610.0, 488.0), Vector2(830.0, 488.0)]:
				targets.append({"pos": child_pos, "served": false, "patience": 1.0})
		_:
			player_pos = Vector2(180.0, 360.0)
			for child_pos in [Vector2(450.0, 230.0), Vector2(710.0, 230.0), Vector2(450.0, 480.0), Vector2(710.0, 480.0)]:
				targets.append({"pos": child_pos, "gift": false, "life": false})


func _reset_foxy_game() -> void:
	foxy_level = 0
	foxy_pizza_count = 0
	foxy_total_pizzas = 0
	foxy_deaths = 0
	foxy_ending_phase = 0
	foxy_ending_time = 0.0
	foxy_air_anim_time = 0.0
	foxy_landing_anim_time = 0.0
	foxy_death_anim_time = 0.0
	foxy_level_clear_time = 0.0
	foxy_level_clear_next = -1
	foxy_theme_resume_position = 0.0
	_reset_foxy_jump_state()
	_reset_foxy_level()


func _reset_foxy_level() -> void:
	completed = false
	failed = false
	foxy_world_length = FOXY_LEVEL_LENGTH + (float(foxy_level) * 420.0)
	time_left = FOXY_LEVEL_TIME
	var ground_y := _foxy_ground_y()
	foxy_pos = Vector2(76.0, ground_y - PLAYER_SIZE.y)
	foxy_velocity = Vector2.ZERO
	foxy_on_ground = false
	foxy_camera_x = 0.0
	foxy_hurt_cooldown = 0.0
	foxy_ending_phase = 0
	foxy_ending_time = 0.0
	foxy_air_anim_time = 0.0
	foxy_landing_anim_time = 0.0
	foxy_death_anim_time = 0.0
	foxy_level_clear_time = 0.0
	foxy_level_clear_next = -1
	_reset_foxy_jump_state()
	_build_foxy_level()
	_play_foxy_theme()


func _build_foxy_level() -> void:
	foxy_platforms.clear()
	foxy_enemies.clear()
	foxy_pizzas.clear()
	var gap_width := 92.0 + (float(foxy_level) * 16.0)
	var segment_length := 820.0 - (float(foxy_level) * 28.0)
	var ground_y := _foxy_ground_y()
	var world_x := 0.0
	while world_x < foxy_world_length + 700.0:
		foxy_platforms.append(Rect2(world_x, ground_y, segment_length, 96.0))
		world_x += segment_length + gap_width
		if foxy_level == 3:
			gap_width = min(gap_width + 4.0, 132.0)

	for platform_index in range(8 + foxy_level):
		var platform_x := 620.0 + (float(platform_index) * 850.0)
		var platform_y := ground_y - 96.0 - (float((platform_index + foxy_level) % 2) * 72.0)
		foxy_platforms.append(Rect2(platform_x, platform_y, 210.0, 24.0))

	var enemy_count := 7 + (foxy_level * 2)
	if foxy_level == 3:
		enemy_count = 3
	for enemy_index in range(enemy_count):
		var enemy_x := 780.0 + (float(enemy_index) * 880.0) + (float(foxy_level) * 95.0)
		var patrol_platform := _foxy_platform_for_x(enemy_x + (ENEMY_SIZE.x * 0.5))
		if patrol_platform.size == Vector2.ZERO:
			patrol_platform = _nearest_foxy_platform_for_x(enemy_x + (ENEMY_SIZE.x * 0.5))
		if patrol_platform.size == Vector2.ZERO:
			continue
		var min_patrol_x := patrol_platform.position.x + FOXY_ENEMY_EDGE_MARGIN
		var max_patrol_x := patrol_platform.position.x + patrol_platform.size.x - ENEMY_SIZE.x - FOXY_ENEMY_EDGE_MARGIN
		if max_patrol_x < min_patrol_x:
			min_patrol_x = patrol_platform.position.x
			max_patrol_x = patrol_platform.position.x + patrol_platform.size.x - ENEMY_SIZE.x
		enemy_x = clampf(enemy_x, min_patrol_x, max_patrol_x)
		var enemy_y := patrol_platform.position.y - ENEMY_SIZE.y
		var enemy_kind := "hopper" if foxy_level > 0 and enemy_index % 3 == 1 else "walker"
		foxy_enemies.append({
			"rect": Rect2(enemy_x, enemy_y, ENEMY_SIZE.x, ENEMY_SIZE.y),
			"alive": true,
			"dying": false,
			"kind": enemy_kind,
			"sprite": "enemy_kao" if enemy_kind == "hopper" else "enemy_wolf",
			"min_x": min_patrol_x,
			"max_x": max_patrol_x,
			"dir": 1.0 if enemy_index % 2 == 0 else -1.0,
			"base_y": enemy_y,
			"vel_y": 0.0,
			"hop_timer": float(enemy_index % 3) * 0.14,
			"air_anim_time": 0.0,
			"landing_anim_time": 0.0,
			"death_anim_time": 0.0,
		})

	var pizza_count_for_level := 18 + (foxy_level * 4)
	var pizza_rng := RandomNumberGenerator.new()
	pizza_rng.seed = 12091 + (foxy_level * 1013)
	for pizza_index in range(pizza_count_for_level):
		var pizza_x := 360.0 + (float(pizza_index) * 395.0)
		var pizza_y := ground_y - 78.0
		if pizza_index % 4 == 2:
			pizza_y = ground_y - 176.0
		var pizza_rect := _foxy_resolve_pizza_spawn_rect(Rect2(pizza_x, pizza_y, PIZZA_SIZE.x, PIZZA_SIZE.y), pizza_rng)
		foxy_pizzas.append({
			"rect": pizza_rect,
			"collected": false
		})
	foxy_total_pizzas = max(foxy_total_pizzas, foxy_pizza_count + foxy_pizzas.size())
	foxy_goal_rect = Rect2(foxy_world_length - 118.0, ground_y - 112.0, 72.0, 112.0)


func _foxy_ground_y() -> float:
	if foxy_level == 0:
		return FOXY_LEVEL_1_GROUND_Y
	if foxy_level == 1:
		return FOXY_LEVEL_2_GROUND_Y
	return FOXY_GROUND_Y


func _update_give_gifts(delta: float) -> void:
	_move_player(delta, 210.0, Rect2(80.0, 150.0, 940.0, 430.0))
	if not interact_queued:
		return
	var target_index := _nearest_target_index(78.0)
	if target_index < 0:
		return
	var target: Dictionary = targets[target_index]
	if phase == 0 and not bool(target.get("gift", false)):
		target["gift"] = true
		targets[target_index] = target
		if _all_targets_flag("gift"):
			phase = 1
	elif phase == 1 and not bool(target.get("life", false)):
		target["life"] = true
		targets[target_index] = target
		if _all_targets_flag("life"):
			completed = true


func _update_foxy_go(delta: float) -> void:
	if foxy_level_clear_next >= 0:
		_update_foxy_level_clear(delta)
		return
	if foxy_ending_phase > 0:
		_update_foxy_ending(delta)
		return

	time_left = max(time_left - delta, 0.0)
	if time_left <= 0.0:
		_fail_foxy_game()
		return

	foxy_hurt_cooldown = max(foxy_hurt_cooldown - delta, 0.0)
	foxy_landing_anim_time = max(foxy_landing_anim_time - delta, 0.0)
	foxy_dash_cooldown = maxf(foxy_dash_cooldown - delta, 0.0)
	if foxy_dash_anim_time >= 0.0:
		foxy_dash_anim_time += delta
	if foxy_on_ground:
		foxy_coyote_timer = FOXY_COYOTE_TIME
		foxy_air_anim_time = 0.0
	else:
		foxy_coyote_timer = maxf(foxy_coyote_timer - delta, 0.0)
		foxy_air_anim_time += delta
	if jump_queued:
		foxy_jump_buffer_timer = FOXY_JUMP_BUFFER_TIME
	else:
		foxy_jump_buffer_timer = maxf(foxy_jump_buffer_timer - delta, 0.0)
	var input_axis := 0.0
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		input_axis -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		input_axis += 1.0
	if absf(input_axis) > 0.01:
		foxy_facing = signf(input_axis)
	if dash_queued and _can_foxy_dash():
		_start_foxy_dash(input_axis)
	if foxy_dash_timer > 0.0:
		foxy_dash_timer = maxf(foxy_dash_timer - delta, 0.0)
		foxy_velocity.x = foxy_dash_direction * FOXY_DASH_SPEED
	else:
		foxy_velocity.x = input_axis * FOXY_MOVE_SPEED
	if foxy_jump_buffer_timer > 0.0 and (foxy_on_ground or foxy_coyote_timer > 0.0):
		_start_foxy_jump()
	if not foxy_jump_held and foxy_jump_hold_timer > 0.0 and foxy_velocity.y < 0.0:
		foxy_jump_cut_queued = true
	if foxy_jump_cut_queued and foxy_velocity.y < 0.0 and foxy_jump_hold_timer > 0.0:
		foxy_velocity.y *= FOXY_JUMP_CUT_MULTIPLIER
		foxy_jump_hold_timer = 0.0
	foxy_jump_cut_queued = false
	var gravity_scale := 1.0
	if foxy_velocity.y < 0.0 and foxy_jump_held and foxy_jump_hold_timer > 0.0:
		gravity_scale = FOXY_JUMP_HOLD_GRAVITY_SCALE
		foxy_jump_hold_timer = maxf(foxy_jump_hold_timer - delta, 0.0)
	else:
		foxy_jump_hold_timer = 0.0
	foxy_velocity.y = min(foxy_velocity.y + (FOXY_GRAVITY * gravity_scale * delta), FOXY_MAX_FALL_SPEED)

	var was_on_ground := foxy_on_ground
	var was_falling := foxy_velocity.y > 0.0
	_move_foxy_axis(Vector2(foxy_velocity.x * delta, 0.0))
	foxy_on_ground = false
	_move_foxy_axis(Vector2(0.0, foxy_velocity.y * delta))
	if foxy_on_ground and not was_on_ground and was_falling:
		foxy_landing_anim_time = FOXY_LANDING_FRAME_TIME
		foxy_air_anim_time = 0.0
		foxy_coyote_timer = FOXY_COYOTE_TIME
		foxy_jump_hold_timer = 0.0
		foxy_jump_cut_queued = false
		foxy_air_dash_used = false
		foxy_dash_hold_until_ground = false
		if foxy_dash_timer <= 0.0:
			foxy_dash_anim_time = -1.0
		_play_foxy_sfx("land")
	elif foxy_dash_timer <= 0.0 and not foxy_dash_hold_until_ground:
		foxy_dash_anim_time = -1.0
	foxy_pos.x = clampf(foxy_pos.x, 0.0, foxy_world_length - PLAYER_SIZE.x)
	if foxy_pos.y > ARCADE_SCREEN_RECT.size.y + 180.0:
		_hurt_foxy(true)

	_update_foxy_enemies(delta)
	_update_foxy_pickups()
	_update_foxy_enemy_collisions()
	_update_foxy_goal()
	foxy_camera_x = clampf((foxy_pos.x + (PLAYER_SIZE.x * 0.5)) - (ARCADE_SCREEN_RECT.size.x * 0.42), 0.0, max(foxy_world_length - ARCADE_SCREEN_RECT.size.x, 0.0))


func _update_foxy_ending(delta: float) -> void:
	foxy_ending_time += delta
	match foxy_ending_phase:
		2:
			if foxy_ending_time >= 1.1:
				foxy_ending_phase = 3
				foxy_ending_time = 0.0
		3:
			if foxy_ending_time >= 2.0:
				_return_to_menu()


func _update_foxy_level_clear(delta: float) -> void:
	foxy_level_clear_time += delta
	foxy_velocity = Vector2.ZERO
	foxy_landing_anim_time = 0.0
	foxy_air_anim_time = 0.0
	if foxy_level_clear_time < FOXY_LEVEL_CLEAR_TIME:
		return
	foxy_level = foxy_level_clear_next
	foxy_level_clear_next = -1
	_reset_foxy_level()


func _move_foxy_axis(delta_pos: Vector2) -> void:
	if delta_pos == Vector2.ZERO:
		return
	foxy_pos += delta_pos
	var player_rect := _foxy_player_rect()
	for solid in foxy_platforms:
		if not player_rect.intersects(solid):
			continue
		if delta_pos.x > 0.0:
			foxy_pos.x = solid.position.x - PLAYER_SIZE.x
			foxy_velocity.x = 0.0
		elif delta_pos.x < 0.0:
			foxy_pos.x = solid.position.x + solid.size.x
			foxy_velocity.x = 0.0
		elif delta_pos.y > 0.0:
			foxy_pos.y = solid.position.y - PLAYER_SIZE.y
			foxy_velocity.y = 0.0
			foxy_on_ground = true
		elif delta_pos.y < 0.0:
			foxy_pos.y = solid.position.y + solid.size.y
			foxy_velocity.y = 0.0
		player_rect = _foxy_player_rect()


func _update_foxy_enemies(delta: float) -> void:
	for enemy_index in range(foxy_enemies.size()):
		var enemy: Dictionary = foxy_enemies[enemy_index]
		if not bool(enemy.get("alive", true)):
			if bool(enemy.get("dying", false)):
				enemy["death_anim_time"] = float(enemy.get("death_anim_time", 0.0)) + delta
				if float(enemy["death_anim_time"]) >= float(FOXY_ENEMY_ANIM_FRAME_COUNTS[str(enemy.get("sprite", "enemy_wolf"))].get("deading", 4)) / float(FOXY_ENEMY_ANIM_SPEEDS["deading"]):
					enemy["dying"] = false
				foxy_enemies[enemy_index] = enemy
			continue
		if str(enemy.get("kind", "walker")) == "hopper":
			_update_foxy_hopper_enemy(enemy, delta)
		else:
			_update_foxy_walker_enemy(enemy, delta)
		foxy_enemies[enemy_index] = enemy


func _update_foxy_walker_enemy(enemy: Dictionary, delta: float) -> void:
	var enemy_rect: Rect2 = enemy["rect"]
	var direction := float(enemy.get("dir", 1.0))
	enemy_rect.position.x += direction * (72.0 + (float(foxy_level) * 8.0)) * delta
	if enemy_rect.position.x < float(enemy["min_x"]):
		enemy_rect.position.x = float(enemy["min_x"])
		direction = 1.0
	elif enemy_rect.position.x > float(enemy["max_x"]):
		enemy_rect.position.x = float(enemy["max_x"])
		direction = -1.0
	enemy["rect"] = enemy_rect
	enemy["dir"] = direction


func _update_foxy_hopper_enemy(enemy: Dictionary, delta: float) -> void:
	var enemy_rect: Rect2 = enemy["rect"]
	var direction := float(enemy.get("dir", 1.0))
	var base_y := float(enemy.get("base_y", enemy_rect.position.y))
	var velocity_y := float(enemy.get("vel_y", 0.0))
	var hop_timer := maxf(float(enemy.get("hop_timer", 0.0)) - delta, 0.0)
	var air_anim_time := float(enemy.get("air_anim_time", 0.0))
	var landing_anim_time := maxf(float(enemy.get("landing_anim_time", 0.0)) - delta, 0.0)
	var grounded := enemy_rect.position.y >= base_y - 0.01
	var was_airborne := not grounded or absf(velocity_y) > 0.01
	if grounded:
		enemy_rect.position.y = base_y
		velocity_y = 0.0
		if hop_timer <= 0.0:
			velocity_y = FOXY_HOPPER_JUMP_SPEED
			hop_timer = FOXY_HOPPER_HOP_INTERVAL
	if velocity_y < 0.0 or not grounded:
		air_anim_time += delta
		enemy_rect.position.x += direction * (FOXY_HOPPER_MOVE_SPEED + (float(foxy_level) * 7.0)) * delta
		velocity_y = minf(velocity_y + (FOXY_HOPPER_GRAVITY * delta), FOXY_MAX_FALL_SPEED)
		enemy_rect.position.y += velocity_y * delta
	if enemy_rect.position.x < float(enemy["min_x"]):
		enemy_rect.position.x = float(enemy["min_x"])
		direction = 1.0
	elif enemy_rect.position.x > float(enemy["max_x"]):
		enemy_rect.position.x = float(enemy["max_x"])
		direction = -1.0
	if enemy_rect.position.y >= base_y:
		enemy_rect.position.y = base_y
		if was_airborne:
			landing_anim_time = FOXY_LANDING_FRAME_TIME
			air_anim_time = 0.0
		velocity_y = 0.0
	enemy["rect"] = enemy_rect
	enemy["dir"] = direction
	enemy["vel_y"] = velocity_y
	enemy["hop_timer"] = hop_timer
	enemy["air_anim_time"] = air_anim_time
	enemy["landing_anim_time"] = landing_anim_time


func _update_foxy_pickups() -> void:
	var player_rect := _foxy_player_rect()
	for pizza_index in range(foxy_pizzas.size()):
		var pizza: Dictionary = foxy_pizzas[pizza_index]
		if bool(pizza.get("collected", false)):
			continue
		var pizza_rect: Rect2 = pizza["rect"]
		if player_rect.intersects(pizza_rect):
			pizza["collected"] = true
			foxy_pizza_count += 1
			foxy_pizzas[pizza_index] = pizza
			_play_foxy_sfx("pickup")


func _update_foxy_enemy_collisions() -> void:
	if foxy_hurt_cooldown > 0.0:
		return
	var player_rect := _foxy_hazard_rect()
	for enemy_index in range(foxy_enemies.size()):
		var enemy: Dictionary = foxy_enemies[enemy_index]
		if not bool(enemy.get("alive", true)):
			continue
		var enemy_rect := _foxy_enemy_hazard_rect(enemy["rect"])
		if not player_rect.intersects(enemy_rect):
			continue
		var stomp_depth := (player_rect.position.y + player_rect.size.y) - enemy_rect.position.y
		if foxy_velocity.y > 0.0 and stomp_depth <= 22.0:
			enemy["alive"] = false
			enemy["dying"] = true
			enemy["death_anim_time"] = 0.0
			foxy_enemies[enemy_index] = enemy
			foxy_velocity.y = FOXY_JUMP_SPEED * 0.55
			foxy_on_ground = false
			foxy_coyote_timer = 0.0
			foxy_jump_hold_timer = FOXY_JUMP_HOLD_TIME * 0.35
			_play_foxy_sfx("stomp")
			return
		_hurt_foxy(false)
		return


func _update_foxy_goal() -> void:
	if not _foxy_player_rect().intersects(foxy_goal_rect):
		return
	if foxy_level < FOXY_LEVEL_COUNT - 1:
		_start_foxy_level_clear(foxy_level + 1)
	else:
		_start_foxy_ending()


func _start_foxy_level_clear(next_level: int) -> void:
	foxy_level_clear_next = next_level
	foxy_level_clear_time = 0.0
	foxy_velocity = Vector2.ZERO
	foxy_on_ground = true
	foxy_landing_anim_time = 0.0
	foxy_air_anim_time = 0.0
	_reset_foxy_jump_state()
	_pause_foxy_theme_for_level_clear()
	_play_foxy_sfx("clear")


func _start_foxy_ending() -> void:
	foxy_ending_phase = 2
	foxy_ending_time = 0.0
	foxy_velocity = Vector2.ZERO
	foxy_landing_anim_time = 0.0
	foxy_air_anim_time = 0.0
	_reset_foxy_jump_state()
	_stop_foxy_theme()
	foxy_camera_x = clampf(foxy_world_length - ARCADE_SCREEN_RECT.size.x, 0.0, max(foxy_world_length - ARCADE_SCREEN_RECT.size.x, 0.0))
	if foxy_jumpscare_player != null:
		foxy_jumpscare_player.volume_db = GameState.volume_db(GameState.mastervol)
		foxy_jumpscare_player.play()


func _hurt_foxy(from_fall: bool) -> void:
	if foxy_hurt_cooldown > 0.0:
		return
	_play_foxy_sfx("hurt")
	foxy_deaths += 1
	time_left = max(time_left - (10.0 if from_fall else 7.0), 0.0)
	if time_left <= 0.0:
		_fail_foxy_game()
		return
	foxy_pos = Vector2(max(76.0, foxy_camera_x + 54.0), _foxy_ground_y() - PLAYER_SIZE.y)
	foxy_velocity = Vector2.ZERO
	foxy_on_ground = false
	foxy_hurt_cooldown = 1.0
	foxy_landing_anim_time = 0.0
	foxy_air_anim_time = 0.0
	_reset_foxy_jump_state()


func _fail_foxy_game() -> void:
	if failed:
		return
	failed = true
	_stop_foxy_theme()
	foxy_death_anim_time = 0.0
	foxy_velocity = Vector2.ZERO
	foxy_landing_anim_time = 0.0
	foxy_air_anim_time = 0.0
	foxy_level_clear_next = -1
	_reset_foxy_jump_state()


func _ground_top_for_x(world_x: float) -> float:
	var best_y := INF
	for solid in foxy_platforms:
		if world_x >= solid.position.x and world_x <= solid.position.x + solid.size.x:
			best_y = min(best_y, solid.position.y)
	return best_y


func _foxy_platform_for_x(world_x: float) -> Rect2:
	var best_platform := Rect2()
	var best_y := INF
	for solid in foxy_platforms:
		if world_x < solid.position.x or world_x > solid.position.x + solid.size.x:
			continue
		if solid.position.y < best_y:
			best_platform = solid
			best_y = solid.position.y
	return best_platform


func _nearest_foxy_platform_for_x(world_x: float) -> Rect2:
	var best_platform := Rect2()
	var best_distance := INF
	for solid in foxy_platforms:
		if solid.size.x < ENEMY_SIZE.x:
			continue
		var nearest_x := clampf(world_x, solid.position.x, solid.position.x + solid.size.x)
		var distance := absf(world_x - nearest_x)
		if distance < best_distance:
			best_platform = solid
			best_distance = distance
	return best_platform


func _foxy_resolve_pizza_spawn_rect(candidate_rect: Rect2, rng: RandomNumberGenerator) -> Rect2:
	var blocking_platform := _foxy_first_platform_intersection(candidate_rect)
	if blocking_platform.size == Vector2.ZERO:
		return candidate_rect
	var above_rect := Rect2(
		Vector2(candidate_rect.position.x, blocking_platform.position.y - PIZZA_SIZE.y - FOXY_PICKUP_BLOCK_OFFSET),
		PIZZA_SIZE
	)
	var below_rect := Rect2(
		Vector2(candidate_rect.position.x, blocking_platform.position.y + blocking_platform.size.y + FOXY_PICKUP_BLOCK_OFFSET),
		PIZZA_SIZE
	)
	var candidates: Array[Rect2] = []
	if _foxy_is_valid_pizza_rect(above_rect):
		candidates.append(above_rect)
	if _foxy_is_valid_pizza_rect(below_rect):
		candidates.append(below_rect)
	if not candidates.is_empty():
		return candidates[rng.randi_range(0, candidates.size() - 1)]
	var fallback_platform := _foxy_platform_for_x(candidate_rect.position.x + (candidate_rect.size.x * 0.5))
	if fallback_platform.size == Vector2.ZERO:
		fallback_platform = _nearest_foxy_platform_for_x(candidate_rect.position.x + (candidate_rect.size.x * 0.5))
	if fallback_platform.size != Vector2.ZERO:
		var fallback_rect := Rect2(
			Vector2(candidate_rect.position.x, fallback_platform.position.y - PIZZA_SIZE.y - FOXY_PICKUP_BLOCK_OFFSET),
			PIZZA_SIZE
		)
		if _foxy_is_valid_pizza_rect(fallback_rect):
			return fallback_rect
	return candidate_rect


func _foxy_first_platform_intersection(rect: Rect2) -> Rect2:
	for solid in foxy_platforms:
		if rect.intersects(solid):
			return solid
	return Rect2()


func _foxy_is_valid_pizza_rect(rect: Rect2) -> bool:
	if rect.position.y < ARCADE_SAFE_TOP:
		return false
	if rect.position.y + rect.size.y > _foxy_ground_y() - 6.0:
		return false
	return _foxy_first_platform_intersection(rect).size == Vector2.ZERO


func _foxy_player_rect() -> Rect2:
	return Rect2(foxy_pos, PLAYER_SIZE)


func _foxy_hazard_rect() -> Rect2:
	return _inset_rect(_foxy_player_rect(), FOXY_PLAYER_HAZARD_INSET)


func _foxy_enemy_hazard_rect(enemy_rect: Rect2) -> Rect2:
	return _inset_rect(enemy_rect, FOXY_ENEMY_HAZARD_INSET)


func _inset_rect(rect: Rect2, inset: Vector2) -> Rect2:
	var inset_x := minf(inset.x, rect.size.x * 0.45)
	var inset_y := minf(inset.y, rect.size.y * 0.45)
	var applied_inset := Vector2(inset_x, inset_y)
	return Rect2(rect.position + applied_inset, rect.size - (applied_inset * 2.0))


func _is_foxy_jump_key(keycode: int) -> bool:
	return keycode == KEY_SPACE or keycode == KEY_UP or keycode == KEY_W


func _is_foxy_dash_key(keycode: int) -> bool:
	return keycode == KEY_SHIFT


func _start_foxy_jump() -> void:
	foxy_velocity.y = FOXY_JUMP_SPEED
	foxy_on_ground = false
	foxy_coyote_timer = 0.0
	foxy_jump_buffer_timer = 0.0
	foxy_jump_hold_timer = FOXY_JUMP_HOLD_TIME
	foxy_jump_cut_queued = false
	foxy_air_anim_time = 0.0
	foxy_landing_anim_time = 0.0
	_play_foxy_sfx("jump")


func _can_foxy_dash() -> bool:
	if foxy_dash_cooldown > 0.0:
		return false
	return foxy_on_ground or not foxy_air_dash_used


func _start_foxy_dash(input_axis: float) -> void:
	var dash_direction := foxy_facing
	if absf(input_axis) > 0.01:
		dash_direction = signf(input_axis)
	foxy_dash_direction = dash_direction
	foxy_facing = dash_direction
	foxy_dash_timer = FOXY_DASH_DURATION
	foxy_dash_cooldown = FOXY_DASH_COOLDOWN
	foxy_dash_anim_time = 0.0
	foxy_dash_hold_until_ground = not foxy_on_ground
	if not foxy_on_ground:
		foxy_air_dash_used = true
	_play_foxy_sfx("dash")


func _reset_foxy_jump_state() -> void:
	jump_queued = false
	dash_queued = false
	foxy_coyote_timer = 0.0
	foxy_jump_buffer_timer = 0.0
	foxy_jump_hold_timer = 0.0
	foxy_jump_cut_queued = false
	foxy_jump_held = false
	foxy_dash_timer = 0.0
	foxy_dash_cooldown = 0.0
	foxy_dash_anim_time = -1.0
	foxy_dash_direction = foxy_facing
	foxy_dash_hold_until_ground = false
	foxy_air_dash_used = false


func _update_take_cake(delta: float) -> void:
	time_left = max(time_left - delta, 0.0)
	if time_left <= 0.0:
		failed = true
		return
	_move_player(delta, 220.0, Rect2(80.0, 150.0, 1000.0, 430.0))
	car_x += 250.0 * delta
	if car_x > VIEW_W + 120.0:
		car_x = -160.0
	if Rect2(car_x, 584.0, 118.0, 36.0).has_point(player_pos):
		failed = true
		return
	for i in range(targets.size()):
		var target: Dictionary = targets[i]
		if bool(target.get("served", false)):
			continue
		target["patience"] = max(float(target.get("patience", 1.0)) - (0.018 * delta), 0.0)
		targets[i] = target
		if float(target["patience"]) <= 0.0:
			failed = true
	if interact_queued:
		var target_index := _nearest_target_index(74.0)
		if target_index >= 0:
			var selected: Dictionary = targets[target_index]
			selected["served"] = true
			targets[target_index] = selected
	if _all_targets_flag("served"):
		completed = true


func _move_player(delta: float, speed: float, bounds: Rect2) -> void:
	var dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		dir.x += 1.0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		dir.y += 1.0
	if dir.length_squared() > 0.0:
		player_pos += dir.normalized() * speed * delta
	player_pos.x = clampf(player_pos.x, bounds.position.x, bounds.position.x + bounds.size.x)
	player_pos.y = clampf(player_pos.y, bounds.position.y, bounds.position.y + bounds.size.y)


func _nearest_target_index(max_distance: float) -> int:
	var best_index := -1
	var best_distance := max_distance
	for i in range(targets.size()):
		var target: Dictionary = targets[i]
		var target_pos: Vector2 = target["pos"]
		var distance := player_pos.distance_to(target_pos)
		if distance <= best_distance:
			best_index = i
			best_distance = distance
	return best_index


func _all_targets_flag(flag_name: String) -> bool:
	for target in targets:
		if not bool(target.get(flag_name, false)):
			return false
	return true


func _return_to_menu() -> void:
	_stop_foxy_theme()
	get_tree().change_scene_to_file(MENU_SCENE)


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), COLOR_BLACK, true)
	if mode_id == "foxy_go":
		_draw_foxy_arcade()
	else:
		_draw_legacy_minigame()


func _draw_legacy_minigame() -> void:
	_draw_grid()
	match mode_id:
		"take_cake":
			_draw_take_cake()
		_:
			_draw_give_gifts()
	_draw_overlay_text()


func _draw_foxy_arcade() -> void:
	if foxy_ending_phase == 3:
		_draw_foxy_static()
		return
	_draw_foxy_screen()
	_draw_foxy_monitor_lines()
	if arcade_texture != null:
		draw_texture_rect(arcade_texture, Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), false, COLOR_WHITE)
	if foxy_ending_phase == 2:
		_draw_foxy_jumpscare()
		return
	if failed:
		_draw_text("menubt", Vector2(640.0, 322.0), GameState.t("minigame_failed"), COLOR_RED, 1.0, HALIGN_CENTER, VALIGN_MIDDLE)
		_draw_text("footer", Vector2(640.0, 374.0), "SPACE / ENTER", COLOR_GRAY, 1.0, HALIGN_CENTER, VALIGN_TOP)


func _draw_foxy_screen() -> void:
	_draw_game_rect(Rect2(Vector2.ZERO, ARCADE_SCREEN_RECT.size), Color(0.02, 0.02, 0.035, 1.0), true)
	_draw_foxy_background()
	_draw_foxy_level_1_decors()
	_draw_foxy_level_2_decors()

	for solid in foxy_platforms:
		_draw_foxy_platform(solid)
	for pizza in foxy_pizzas:
		if bool(pizza.get("collected", false)):
			continue
		_draw_world_pizza(pizza["rect"])
	for enemy in foxy_enemies:
		if bool(enemy.get("alive", true)) or bool(enemy.get("dying", false)):
			_draw_world_enemy(enemy)
	_draw_world_goal()
	if foxy_level == 3 and foxy_pos.x > foxy_world_length - 900.0:
		_draw_dead_children()
	_draw_world_foxy(_foxy_player_rect())
	_draw_foxy_hud()


func _draw_foxy_monitor_lines() -> void:
	if cctv_lines_texture == null:
		return
	draw_texture_rect(cctv_lines_texture, ARCADE_SCREEN_RECT, false, Color(1.0, 1.0, 1.0, 0.5))


func _draw_foxy_background() -> void:
	if _draw_foxy_level_1_background():
		return
	if _draw_foxy_level_2_background():
		return
	var sky_top := Color(0.03, 0.07, 0.16, 1.0).lerp(Color(0.16, 0.04, 0.06, 1.0), float(foxy_level) / 3.0)
	_draw_game_rect(Rect2(0.0, 0.0, ARCADE_SCREEN_RECT.size.x, ARCADE_SCREEN_RECT.size.y), sky_top, true)
	var hill_color := Color(0.05, 0.18, 0.13, 1.0).lerp(Color(0.12, 0.03, 0.05, 1.0), float(foxy_level) / 3.0)
	for hill_index in range(9):
		var hill_x := (float(hill_index) * 180.0) - fmod(foxy_camera_x * 0.18, 180.0)
		_draw_game_rect(Rect2(hill_x, 342.0 + (float(hill_index % 2) * 24.0), 160.0, 102.0), hill_color, true)
	if foxy_level == 3:
		var cove_x := 80.0 - foxy_camera_x
		_draw_game_rect(Rect2(cove_x, FOXY_GROUND_Y - 120.0, 92.0, 120.0), Color(0.28, 0.02, 0.02, 1.0), true)
		_draw_game_rect(Rect2(cove_x + 12.0, FOXY_GROUND_Y - 104.0, 68.0, 88.0), COLOR_BLACK, true)


func _draw_foxy_platform(solid: Rect2) -> void:
	if _draw_foxy_level_1_platform(solid):
		return
	if _draw_foxy_level_2_platform(solid):
		return
	_draw_world_rect(solid, Color(0.27, 0.15, 0.08, 1.0), true)
	_draw_world_rect(Rect2(solid.position, Vector2(solid.size.x, 8.0)), Color(0.54, 0.32, 0.12, 1.0), true)


func _draw_foxy_level_1_background() -> bool:
	if foxy_level != 0:
		return false
	if foxy_level_1_textures.is_empty():
		return false
	_draw_game_rect(Rect2(0.0, 0.0, ARCADE_SCREEN_RECT.size.x, ARCADE_SCREEN_RECT.size.y), Color(0.28, 0.50, 0.80, 1.0), true)
	_draw_foxy_level_1_bg_layer("bg1", 0.015, COLOR_WHITE)
	_draw_foxy_level_1_bg_layer("bg2", 0.045, COLOR_WHITE)
	_draw_foxy_level_1_bg_layer("bg3", 0.10, COLOR_WHITE)
	return true


func _draw_foxy_level_1_bg_layer(texture_key: String, scroll_factor: float, color: Color) -> void:
	var texture: Texture2D = foxy_level_1_textures.get(texture_key, null)
	if texture == null:
		return
	var texture_dimensions := texture.get_size()
	if texture_dimensions.x <= 0.0 or texture_dimensions.y <= 0.0:
		return
	var draw_dimensions := texture_dimensions * FOXY_LEVEL_1_BG_SCALE
	var draw_y := 0.0
	var scroll_offset := fmod(foxy_camera_x * scroll_factor, draw_dimensions.x)
	var draw_x := -scroll_offset
	while draw_x > 0.0:
		draw_x -= draw_dimensions.x
	while draw_x < ARCADE_SCREEN_RECT.size.x:
		_draw_game_texture_rect(texture, Rect2(draw_x, draw_y, draw_dimensions.x, draw_dimensions.y), false, color)
		draw_x += draw_dimensions.x


func _draw_foxy_level_1_platform(solid: Rect2) -> bool:
	if foxy_level != 0:
		return false
	var tileset: Texture2D = foxy_level_1_textures.get("tileset", null)
	if tileset == null:
		return false
	var grass_top_source := Rect2(0.0, 0.0, FOXY_LEVEL_1_TILE_SOURCE_SIZE, FOXY_LEVEL_1_TILE_SOURCE_SIZE)
	var dirt_body_source := Rect2(16.0, 16.0, FOXY_LEVEL_1_TILE_SOURCE_SIZE, FOXY_LEVEL_1_TILE_SOURCE_SIZE)
	var stone_source := Rect2(80.0, 0.0, FOXY_LEVEL_1_TILE_SOURCE_SIZE, FOXY_LEVEL_1_TILE_SOURCE_SIZE)
	if solid.size.y <= 40.0:
		var stone_rect := Rect2(solid.position.x - 5.0, solid.position.y - 4.0, solid.size.x + 10.0, 38.0)
		_draw_world_rect(stone_rect, Color(0.06, 0.06, 0.08, 1.0), true)
		_draw_world_tiled_texture_region(tileset, stone_rect, stone_source, FOXY_LEVEL_1_TILE_DRAW_SIZE)
		return true
	var visual_solid := Rect2(solid.position, Vector2(solid.size.x, maxf(solid.size.y, ARCADE_SCREEN_RECT.size.y - solid.position.y)))
	_draw_world_rect(visual_solid, Color(0.12, 0.07, 0.05, 1.0), true)
	var top_rect := Rect2(solid.position.x, solid.position.y, solid.size.x, FOXY_LEVEL_1_TILE_DRAW_SIZE)
	var body_y := solid.position.y + FOXY_LEVEL_1_TILE_DRAW_SIZE
	var body_height := maxf(visual_solid.size.y - FOXY_LEVEL_1_TILE_DRAW_SIZE, 0.0)
	if body_height > 0.0:
		var body_rect := Rect2(solid.position.x, body_y, solid.size.x, body_height)
		_draw_world_tiled_texture_region(tileset, body_rect, dirt_body_source, FOXY_LEVEL_1_TILE_DRAW_SIZE)
	_draw_world_tiled_texture_region(tileset, top_rect, grass_top_source, FOXY_LEVEL_1_TILE_DRAW_SIZE)
	return true


func _draw_foxy_level_1_decors() -> void:
	if foxy_level != 0:
		return
	var decor_texture: Texture2D = foxy_level_1_textures.get("decors", null)
	if decor_texture == null:
		return
	var decor_defs := [
		{"source": Rect2(0.0, 0.0, 80.0, 112.0), "x": 205.0, "repeat": 2850.0, "limit": 4},
		{"source": Rect2(96.0, 58.0, 64.0, 32.0), "x": 450.0, "repeat": 1480.0, "limit": 7},
		{"source": Rect2(176.0, 48.0, 48.0, 64.0), "x": 780.0, "repeat": 2450.0, "limit": 4},
	]
	for decor_def in decor_defs:
		var source_rect: Rect2 = decor_def["source"]
		var draw_dimensions := source_rect.size * FOXY_LEVEL_1_DECOR_SCALE
		for decor_index in range(int(decor_def["limit"])):
			var anchor_x := float(decor_def["x"]) + (float(decor_index) * float(decor_def["repeat"]))
			var support := _foxy_platform_for_x(anchor_x)
			if support.size == Vector2.ZERO or support.size.y <= 40.0:
				continue
			var world_rect := Rect2(
					Vector2(anchor_x - (draw_dimensions.x * 0.5), support.position.y - draw_dimensions.y + 4.0),
					draw_dimensions
			)
			_draw_world_texture_region(decor_texture, world_rect, source_rect)


func _draw_foxy_level_2_background() -> bool:
	if foxy_level != 1:
		return false
	var tileset: Texture2D = foxy_level_2_textures.get("tileset", null)
	if tileset == null:
		return false
	_draw_game_rect(Rect2(0.0, 0.0, ARCADE_SCREEN_RECT.size.x, ARCADE_SCREEN_RECT.size.y), Color(0.01, 0.07, 0.09, 1.0), true)
	var back_wall_source := Rect2(48.0, 16.0, FOXY_LEVEL_2_TILE_SOURCE_SIZE, FOXY_LEVEL_2_TILE_SOURCE_SIZE)
	var far_wall_source := Rect2(64.0, 16.0, FOXY_LEVEL_2_TILE_SOURCE_SIZE, FOXY_LEVEL_2_TILE_SOURCE_SIZE)
	for wall_index in range(8):
		var wall_x := (float(wall_index) * 128.0) - fmod(foxy_camera_x * 0.06, 128.0) - 36.0
		var wall_width := 46.0 + (float(wall_index % 3) * 18.0)
		_draw_game_rect(Rect2(wall_x, 68.0, wall_width, ARCADE_SCREEN_RECT.size.y - 68.0), Color(0.00, 0.13, 0.16, 0.62), true)
		_draw_game_tiled_texture_region(tileset, Rect2(wall_x, 68.0, wall_width, ARCADE_SCREEN_RECT.size.y - 68.0), back_wall_source, FOXY_LEVEL_2_TILE_DRAW_SIZE, Color(0.28, 0.58, 0.62, 0.30))
	for ledge_index in range(7):
		var ledge_x := (float(ledge_index) * 170.0) - fmod(foxy_camera_x * 0.12, 170.0) - 60.0
		var ledge_y := 126.0 + (float(ledge_index % 4) * 43.0)
		_draw_game_tiled_texture_region(tileset, Rect2(ledge_x, ledge_y, 96.0, 36.0), far_wall_source, FOXY_LEVEL_2_TILE_DRAW_SIZE, Color(0.22, 0.48, 0.55, 0.32))
	var water_y := _foxy_ground_y() + 82.0
	_draw_game_rect(Rect2(0.0, water_y, ARCADE_SCREEN_RECT.size.x, ARCADE_SCREEN_RECT.size.y - water_y), Color(0.28, 0.03, 0.30, 0.82), true)
	return true


func _draw_foxy_level_2_platform(solid: Rect2) -> bool:
	if foxy_level != 1:
		return false
	var tileset: Texture2D = foxy_level_2_textures.get("tileset", null)
	if tileset == null:
		return false
	var ground_top_source := Rect2(0.0, 0.0, FOXY_LEVEL_2_TILE_SOURCE_SIZE, FOXY_LEVEL_2_TILE_SOURCE_SIZE)
	var ground_body_source := Rect2(16.0, 16.0, FOXY_LEVEL_2_TILE_SOURCE_SIZE, FOXY_LEVEL_2_TILE_SOURCE_SIZE)
	var stone_source := Rect2(112.0, 0.0, FOXY_LEVEL_2_TILE_SOURCE_SIZE, FOXY_LEVEL_2_TILE_SOURCE_SIZE)
	if solid.size.y <= 40.0:
		var stone_rect := Rect2(solid.position.x - 6.0, solid.position.y - 5.0, solid.size.x + 12.0, 40.0)
		_draw_world_rect(stone_rect, Color(0.00, 0.05, 0.07, 1.0), true)
		_draw_world_tiled_texture_region(tileset, stone_rect, stone_source, FOXY_LEVEL_2_TILE_DRAW_SIZE)
		return true
	var visual_solid := Rect2(solid.position, Vector2(solid.size.x, maxf(solid.size.y, ARCADE_SCREEN_RECT.size.y - solid.position.y)))
	_draw_world_rect(visual_solid, Color(0.01, 0.06, 0.06, 1.0), true)
	var top_rect := Rect2(solid.position.x, solid.position.y, solid.size.x, FOXY_LEVEL_2_TILE_DRAW_SIZE)
	var body_y := solid.position.y + FOXY_LEVEL_2_TILE_DRAW_SIZE
	var body_height := maxf(visual_solid.size.y - FOXY_LEVEL_2_TILE_DRAW_SIZE, 0.0)
	if body_height > 0.0:
		var body_rect := Rect2(solid.position.x, body_y, solid.size.x, body_height)
		_draw_world_tiled_texture_region(tileset, body_rect, ground_body_source, FOXY_LEVEL_2_TILE_DRAW_SIZE)
	_draw_world_tiled_texture_region(tileset, top_rect, ground_top_source, FOXY_LEVEL_2_TILE_DRAW_SIZE)
	return true


func _draw_foxy_level_2_decors() -> void:
	if foxy_level != 1:
		return
	var ground_y := _foxy_ground_y()
	var wall_light: Texture2D = foxy_level_2_textures.get("wall_light", null)
	if wall_light != null:
		for light_index in range(6):
			var light_x := 520.0 + (float(light_index) * 1460.0)
			_draw_world_texture_region(wall_light, Rect2(light_x, ground_y - 218.0, 88.0, 88.0), Rect2(0.0, 0.0, 32.0, 32.0), Color(0.75, 1.0, 0.95, 0.82))
	var lamp_texture: Texture2D = foxy_level_2_textures.get("lamp", null)
	if lamp_texture != null:
		for lamp_index in range(7):
			var lamp_x := 340.0 + (float(lamp_index) * 1260.0)
			_draw_world_texture_region(lamp_texture, Rect2(lamp_x, ground_y - 48.0, 44.0, 44.0), Rect2(0.0, 0.0, 16.0, 16.0))
	var plant_top: Texture2D = foxy_level_2_textures.get("plant_top", null)
	var plant_bottom: Texture2D = foxy_level_2_textures.get("plant_bottom", null)
	if plant_top != null and plant_bottom != null:
		for plant_index in range(8):
			var plant_x := 680.0 + (float(plant_index) * 980.0)
			_draw_world_texture_region(plant_bottom, Rect2(plant_x, ground_y - 44.0, 44.0, 44.0), Rect2(0.0, 0.0, 16.0, 16.0), Color(0.72, 1.0, 0.70, 0.88))
			_draw_world_texture_region(plant_top, Rect2(plant_x, ground_y - 66.0, 44.0, 22.0), Rect2(0.0, 0.0, 16.0, 8.0), Color(0.72, 1.0, 0.70, 0.88))
	var spore_texture: Texture2D = foxy_level_2_textures.get("sporeplant", null)
	if spore_texture != null:
		for spore_index in range(6):
			var spore_x := 1040.0 + (float(spore_index) * 1320.0)
			_draw_world_texture_region(spore_texture, Rect2(spore_x, ground_y - 42.0, 44.0, 44.0), Rect2(0.0, 0.0, 16.0, 16.0))
	var sludge_texture: Texture2D = foxy_level_2_textures.get("sludge", null)
	if sludge_texture != null:
		for sludge_index in range(8):
			var sludge_x := 820.0 + (float(sludge_index) * 1120.0)
			_draw_world_texture_region(sludge_texture, Rect2(sludge_x, ground_y - 22.0, 44.0, 44.0), Rect2(0.0, 0.0, 16.0, 16.0), Color(0.82, 1.0, 0.85, 0.86))


func _draw_foxy_hud() -> void:
	var left_x := ARCADE_SAFE_LEFT
	var right_x := ARCADE_SCREEN_RECT.size.x - ARCADE_SAFE_RIGHT
	var top_y := ARCADE_SAFE_TOP
	var footer_y := ARCADE_SCREEN_RECT.size.y - ARCADE_SAFE_BOTTOM
	_draw_game_text("footer", Vector2(left_x, top_y), "FOXY GO! GO! GO!", COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_TOP)
	_draw_game_text("footer", Vector2(left_x, top_y + 22.0), "LVL " + str(foxy_level + 1) + "/" + str(FOXY_LEVEL_COUNT), COLOR_GRAY, 1.0, HALIGN_LEFT, VALIGN_TOP)
	_draw_game_text("footer", Vector2(right_x, top_y), str(int(ceil(time_left))), COLOR_YELLOW, 1.0, HALIGN_RIGHT, VALIGN_TOP)
	_draw_game_text("footer", Vector2(right_x, top_y + 22.0), "PIZZA " + str(foxy_pizza_count), COLOR_YELLOW, 1.0, HALIGN_RIGHT, VALIGN_TOP)
	_draw_game_text("footer", Vector2(left_x, footer_y), "A/D MOVE   SPACE JUMP   SHIFT DASH   R RESET   ESC EXIT", COLOR_GRAY, 1.0, HALIGN_LEFT, VALIGN_TOP)


func _draw_world_foxy(world_rect: Rect2) -> void:
	var texture := _foxy_current_texture()
	if texture != null:
		var sprite_local_rect := _world_to_game_rect(world_rect)
		var feet_pos := sprite_local_rect.position + Vector2(sprite_local_rect.size.x * 0.5, sprite_local_rect.size.y)
		var sprite_blink_alpha := 1.0
		if foxy_hurt_cooldown > 0.0:
			sprite_blink_alpha = 0.35 if int(elapsed * 18.0) % 2 == 0 else 1.0
		_draw_game_texture_feet(texture, feet_pos, FOXY_SPRITE_DRAW_SIZE, foxy_facing < 0.0, Color(1.0, 1.0, 1.0, sprite_blink_alpha))
		return
	var fallback_local_rect := _world_to_game_rect(world_rect)
	var fallback_blink_alpha := 1.0
	if foxy_hurt_cooldown > 0.0:
		fallback_blink_alpha = 0.3 if int(elapsed * 18.0) % 2 == 0 else 1.0
	var body_color := Color(COLOR_RED.r, COLOR_RED.g, COLOR_RED.b, fallback_blink_alpha)
	_draw_game_rect(fallback_local_rect, body_color, true)
	_draw_game_rect(Rect2(fallback_local_rect.position + Vector2(23.0, 9.0), Vector2(24.0, 11.0)), COLOR_YELLOW, true)
	_draw_game_rect(Rect2(fallback_local_rect.position + Vector2(9.0, 12.0), Vector2(5.0, 5.0)), COLOR_BLACK, true)
	_draw_game_rect(Rect2(fallback_local_rect.position + Vector2(-8.0, 16.0), Vector2(12.0, 28.0)), Color(0.45, 0.04, 0.02, fallback_blink_alpha), true)


func _draw_world_enemy(enemy: Dictionary) -> void:
	var world_rect: Rect2 = enemy["rect"]
	var enemy_kind := str(enemy.get("kind", "walker"))
	var texture := _foxy_enemy_current_texture(enemy)
	var local_rect := _world_to_game_rect(world_rect)
	if local_rect.position.x > ARCADE_SCREEN_RECT.size.x + FOXY_ENEMY_SPRITE_DRAW_SIZE.x or local_rect.position.x + local_rect.size.x < -FOXY_ENEMY_SPRITE_DRAW_SIZE.x:
		return
	if texture != null:
		var feet_pos := local_rect.position + Vector2(local_rect.size.x * 0.5, local_rect.size.y)
		_draw_game_texture_feet(texture, feet_pos, FOXY_ENEMY_SPRITE_DRAW_SIZE, float(enemy.get("dir", 1.0)) < 0.0, COLOR_WHITE)
		return
	var body_color := Color(0.78, 0.06, 0.05, 1.0) if enemy_kind == "hopper" else Color(0.12, 0.42, 0.72, 1.0)
	_draw_game_rect(local_rect, body_color, true)
	_draw_game_rect(Rect2(local_rect.position + Vector2(8.0, 10.0), Vector2(6.0, 6.0)), COLOR_WHITE, true)
	_draw_game_rect(Rect2(local_rect.position + Vector2(27.0, 10.0), Vector2(6.0, 6.0)), COLOR_WHITE, true)
	if enemy_kind == "hopper":
		_draw_game_rect(Rect2(local_rect.position + Vector2(9.0, local_rect.size.y - 8.0), Vector2(9.0, 5.0)), COLOR_BLACK, true)
		_draw_game_rect(Rect2(local_rect.position + Vector2(24.0, local_rect.size.y - 8.0), Vector2(9.0, 5.0)), COLOR_BLACK, true)


func _draw_world_pizza(world_rect: Rect2) -> void:
	var pizza_texture: Texture2D = foxy_item_textures.get("pizza", null)
	if pizza_texture != null:
		var center := world_rect.position + (world_rect.size * 0.5)
		_draw_world_texture_rect(pizza_texture, Rect2(center - (FOXY_PIZZA_DRAW_SIZE * 0.5), FOXY_PIZZA_DRAW_SIZE))
		return
	var local_rect := _world_to_game_rect(world_rect)
	_draw_game_rect(local_rect, COLOR_YELLOW, true)
	_draw_game_rect(Rect2(local_rect.position + Vector2(3.0, 3.0), Vector2(5.0, 5.0)), COLOR_RED, true)
	_draw_game_rect(Rect2(local_rect.position + Vector2(13.0, 9.0), Vector2(5.0, 5.0)), COLOR_RED, true)


func _draw_world_goal() -> void:
	var exit_texture: Texture2D = foxy_item_textures.get("exit", null)
	if exit_texture != null:
		var exit_rect := Rect2(
			Vector2(foxy_goal_rect.position.x + (foxy_goal_rect.size.x * 0.5) - (FOXY_EXIT_DRAW_SIZE.x * 0.5), foxy_goal_rect.position.y + foxy_goal_rect.size.y - FOXY_EXIT_DRAW_SIZE.y),
			FOXY_EXIT_DRAW_SIZE
		)
		_draw_world_texture_rect(exit_texture, exit_rect)
		return
	var local_rect := _world_to_game_rect(foxy_goal_rect)
	var goal_color := Color(0.95, 0.82, 0.22, 1.0) if foxy_level < 3 else Color(0.36, 0.0, 0.0, 1.0)
	_draw_game_rect(local_rect, goal_color, false)
	_draw_game_text("footer", local_rect.position + Vector2(local_rect.size.x * 0.5, -24.0), "EXIT", goal_color, 1.0, HALIGN_CENTER, VALIGN_TOP)


func _draw_dead_children() -> void:
	var base_x := foxy_world_length - 430.0
	for child_index in range(5):
		var child_rect := Rect2(base_x + (float(child_index) * 62.0), FOXY_GROUND_Y - 36.0, 38.0, 22.0)
		_draw_world_rect(child_rect, Color(0.45, 0.45, 0.45, 1.0), true)
		_draw_world_rect(Rect2(child_rect.position + Vector2(3.0, 18.0), Vector2(28.0, 5.0)), COLOR_RED, true)


func _draw_foxy_jumpscare() -> void:
	if foxy_jumpscare_frames.is_empty():
		draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), COLOR_BLACK, true)
		return
	var frame_index := clampi(int(floor(foxy_ending_time * 30.0)), 0, foxy_jumpscare_frames.size() - 1)
	var scare_texture: Texture2D = foxy_jumpscare_frames[frame_index]
	var draw_scale := Vector2(2.0, 2.0)
	var draw_size := scare_texture.get_size() * draw_scale
	var draw_pos := Vector2((VIEW_W - draw_size.x) * 0.5, (VIEW_H - draw_size.y) * 0.5)
	draw_texture_rect(scare_texture, Rect2(draw_pos, draw_size), false, COLOR_WHITE)


func _draw_foxy_static() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), COLOR_BLACK, true)
	if cctv_noise_frames.is_empty():
		for noise_index in range(620):
			var noise_x := randf_range(0.0, VIEW_W)
			var noise_y := randf_range(0.0, VIEW_H)
			var noise_value := randf_range(0.18, 0.95)
			draw_rect(Rect2(noise_x, noise_y, randf_range(2.0, 9.0), randf_range(2.0, 8.0)), Color(noise_value, noise_value, noise_value, 1.0), true)
		return
	var cctv_noise_index := int(floor(foxy_ending_time * 30.0)) % cctv_noise_frames.size()
	var static_alpha: float = clamp(1.0 - (foxy_ending_time / 2.0), 0.15, 1.0)
	draw_texture_rect(cctv_noise_frames[cctv_noise_index], Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), false, Color(1.0, 1.0, 1.0, static_alpha))


func _draw_world_rect(world_rect: Rect2, color: Color, filled: bool) -> void:
	var local_rect := _world_to_game_rect(world_rect)
	if local_rect.position.x > ARCADE_SCREEN_RECT.size.x or local_rect.position.x + local_rect.size.x < 0.0:
		return
	_draw_game_rect(local_rect, color, filled)


func _draw_world_texture_rect(texture: Texture2D, world_rect: Rect2, color: Color = COLOR_WHITE) -> void:
	var local_rect := _world_to_game_rect(world_rect)
	if local_rect.position.x > ARCADE_SCREEN_RECT.size.x or local_rect.position.x + local_rect.size.x < 0.0:
		return
	_draw_game_texture_rect(texture, local_rect, false, color)


func _draw_world_texture_region(texture: Texture2D, world_rect: Rect2, source_rect: Rect2, color: Color = COLOR_WHITE) -> void:
	var local_rect := _world_to_game_rect(world_rect)
	if local_rect.position.x > ARCADE_SCREEN_RECT.size.x or local_rect.position.x + local_rect.size.x < 0.0:
		return
	_draw_game_texture_region(texture, local_rect, source_rect, color)


func _draw_world_tiled_texture_region(texture: Texture2D, world_rect: Rect2, source_rect: Rect2, tile_draw_size: float, color: Color = COLOR_WHITE) -> void:
	if tile_draw_size <= 0.0:
		return
	var end_x := world_rect.position.x + world_rect.size.x
	var end_y := world_rect.position.y + world_rect.size.y
	var tile_y := world_rect.position.y
	while tile_y < end_y:
		var draw_height := minf(tile_draw_size, end_y - tile_y)
		var source_height := source_rect.size.y * (draw_height / tile_draw_size)
		var tile_x := world_rect.position.x
		while tile_x < end_x:
			var draw_width := minf(tile_draw_size, end_x - tile_x)
			var source_width := source_rect.size.x * (draw_width / tile_draw_size)
			_draw_world_texture_region(
				texture,
				Rect2(tile_x, tile_y, draw_width, draw_height),
				Rect2(source_rect.position, Vector2(source_width, source_height)),
				color
			)
			tile_x += tile_draw_size
		tile_y += tile_draw_size


func _draw_game_tiled_texture_region(texture: Texture2D, local_rect: Rect2, source_rect: Rect2, tile_draw_size: float, color: Color = COLOR_WHITE) -> void:
	if tile_draw_size <= 0.0:
		return
	var end_x := local_rect.position.x + local_rect.size.x
	var end_y := local_rect.position.y + local_rect.size.y
	var tile_y := local_rect.position.y
	while tile_y < end_y:
		var draw_height := minf(tile_draw_size, end_y - tile_y)
		var source_height := source_rect.size.y * (draw_height / tile_draw_size)
		var tile_x := local_rect.position.x
		while tile_x < end_x:
			var draw_width := minf(tile_draw_size, end_x - tile_x)
			var source_width := source_rect.size.x * (draw_width / tile_draw_size)
			_draw_game_texture_region(
				texture,
				Rect2(tile_x, tile_y, draw_width, draw_height),
				Rect2(source_rect.position, Vector2(source_width, source_height)),
				color
			)
			tile_x += tile_draw_size
		tile_y += tile_draw_size


func _load_foxy_sprite_frames() -> void:
	foxy_sprite_frames.clear()
	for state_name in FOXY_ANIM_FRAME_COUNTS.keys():
		var frames := []
		var frame_count := int(FOXY_ANIM_FRAME_COUNTS[state_name])
		for frame_index in range(frame_count):
			var texture: Texture2D = load(FOXY_SPRITE_BASE_PATH + "/" + str(state_name) + "/" + str(frame_index + 1) + ".png")
			if texture != null:
				frames.append(texture)
			if not frames.is_empty():
				foxy_sprite_frames[state_name] = frames


func _load_foxy_enemy_sprite_frames() -> void:
	foxy_enemy_sprite_frames.clear()
	for sprite_name in FOXY_ENEMY_ANIM_FRAME_COUNTS.keys():
		var sprite_states := {}
		var frame_counts: Dictionary = FOXY_ENEMY_ANIM_FRAME_COUNTS[sprite_name]
		for state_name in frame_counts.keys():
			var frames := []
			var frame_count := int(frame_counts[state_name])
			for frame_index in range(frame_count):
				var texture: Texture2D = load(FOXY_ENEMY_SPRITE_BASE_PATH + "/" + str(sprite_name) + "/" + str(state_name) + "/" + str(frame_index + 1) + ".png")
				if texture != null:
					frames.append(texture)
			if not frames.is_empty():
				sprite_states[state_name] = frames
		if not sprite_states.is_empty():
			foxy_enemy_sprite_frames[sprite_name] = sprite_states


func _load_foxy_item_textures() -> void:
	foxy_item_textures.clear()
	foxy_level_1_textures.clear()
	foxy_level_2_textures.clear()
	var item_paths := {
		"pizza": FOXY_ITEM_BASE_PATH + "/pizza/1.png",
		"exit": FOXY_ITEM_BASE_PATH + "/exit/1.png",
	}
	for item_key in item_paths.keys():
		var item_path := str(item_paths[item_key])
		if ResourceLoader.exists(item_path):
			foxy_item_textures[item_key] = load(item_path)
	var level_1_paths := {
		"bg1": FOXY_LEVEL_1_BASE_PATH + "/BG1.png",
		"bg2": FOXY_LEVEL_1_BASE_PATH + "/BG2.png",
		"bg3": FOXY_LEVEL_1_BASE_PATH + "/BG3.png",
		"tileset": FOXY_LEVEL_1_BASE_PATH + "/Tileset.png",
		"decors": FOXY_LEVEL_1_BASE_PATH + "/Decors.png",
	}
	for level_1_key in level_1_paths.keys():
		var level_1_path := str(level_1_paths[level_1_key])
		if ResourceLoader.exists(level_1_path):
			foxy_level_1_textures[level_1_key] = load(level_1_path)
	var level_2_paths := {
		"tileset": FOXY_LEVEL_2_BASE_PATH + "/TrapmoorTileset_v03.png",
		"wall_light": FOXY_LEVEL_2_BASE_PATH + "/Sprites/WallLight32x32Spritesheet.png",
		"lamp": FOXY_LEVEL_2_BASE_PATH + "/Sprites/lamp.png",
		"plant_top": FOXY_LEVEL_2_BASE_PATH + "/Sprites/TallPlantTop.png",
		"plant_bottom": FOXY_LEVEL_2_BASE_PATH + "/Sprites/TallPlantBottom.png",
		"sporeplant": FOXY_LEVEL_2_BASE_PATH + "/Sprites/sporeplant.png",
		"sludge": FOXY_LEVEL_2_BASE_PATH + "/Sprites/sludge.png",
	}
	for level_2_key in level_2_paths.keys():
		var level_2_path := str(level_2_paths[level_2_key])
		if ResourceLoader.exists(level_2_path):
			foxy_level_2_textures[level_2_key] = load(level_2_path)


func _load_numbered_texture_frames(base_path: String, max_count: int) -> Array[Texture2D]:
	var frames: Array[Texture2D] = []
	for frame_index in range(max_count):
		var path := base_path + "_" + str(frame_index) + ".png"
		if not ResourceLoader.exists(path):
			break
		var texture: Texture2D = load(path)
		if texture != null:
			frames.append(texture)
	return frames


func _setup_foxy_jumpscare_audio() -> void:
	var stream: AudioStream = load(FOXY_JUMPSCARE_SOUND_PATH)
	if stream == null:
		return
	foxy_jumpscare_player = AudioStreamPlayer.new()
	foxy_jumpscare_player.stream = stream
	foxy_jumpscare_player.volume_db = GameState.volume_db(GameState.mastervol)
	add_child(foxy_jumpscare_player)


func _setup_foxy_audio() -> void:
	foxy_theme_player = _make_foxy_audio("foxy_go_theme", FOXY_THEME_PATH, "music", FOXY_THEME_VOLUME_OFFSET_DB)
	if foxy_theme_player != null:
		foxy_theme_player.finished.connect(_on_foxy_theme_finished)
	for key in FOXY_SFX_VOLUME_OFFSETS.keys():
		var sfx_key := str(key)
		var path := "%s/%s.ogg" % [FOXY_SFX_BASE_PATH, sfx_key]
		foxy_sfx_players[sfx_key] = _make_foxy_audio("foxy_go_" + sfx_key, path, "sfx", float(FOXY_SFX_VOLUME_OFFSETS[sfx_key]))


func _make_foxy_audio(player_name: String, path: String, volume_group: String, volume_offset_db: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.name = player_name
	if ResourceLoader.exists(path):
		player.stream = load(path)
	player.set_meta("volume_group", volume_group)
	player.set_meta("volume_offset_db", volume_offset_db)
	_refresh_foxy_audio_player(player)
	add_child(player)
	return player


func _refresh_foxy_audio_player(player: AudioStreamPlayer) -> void:
	var volume_group := str(player.get_meta("volume_group", "sfx"))
	var volume_percent := GameState.musicvol if volume_group == "music" else GameState.mastervol
	if volume_percent <= 0:
		player.volume_db = -80.0
		return
	player.volume_db = GameState.volume_db(volume_percent) + float(player.get_meta("volume_offset_db", 0.0))


func _play_foxy_theme() -> void:
	if foxy_theme_player == null or foxy_theme_player.stream == null:
		return
	_refresh_foxy_audio_player(foxy_theme_player)
	foxy_theme_player.stream_paused = false
	if foxy_theme_resume_position > 0.0:
		foxy_theme_player.play(foxy_theme_resume_position)
		return
	foxy_theme_player.stop()
	foxy_theme_player.play()


func _pause_foxy_theme_for_level_clear() -> void:
	if foxy_theme_player == null:
		return
	if foxy_theme_player.playing:
		foxy_theme_resume_position = maxf(foxy_theme_player.get_playback_position(), 0.0)
		foxy_theme_player.stream_paused = true


func _stop_foxy_theme() -> void:
	if foxy_theme_player != null:
		foxy_theme_player.stream_paused = false
		foxy_theme_player.stop()
	foxy_theme_resume_position = 0.0


func _on_foxy_theme_finished() -> void:
	if mode_id != "foxy_go" or completed or failed or foxy_ending_phase > 0 or foxy_level_clear_next >= 0:
		return
	foxy_theme_resume_position = 0.0
	_play_foxy_theme()


func _play_foxy_sfx(key: String) -> void:
	if not foxy_sfx_players.has(key):
		return
	var player: AudioStreamPlayer = foxy_sfx_players[key]
	if player.stream == null:
		return
	_refresh_foxy_audio_player(player)
	player.stop()
	player.play()


func _foxy_current_texture() -> Texture2D:
	if foxy_level_clear_next >= 0:
		return _foxy_frame_clamped("win", int(floor(foxy_level_clear_time * float(FOXY_ANIM_SPEEDS["win"]))))
	if failed:
		return _foxy_frame_clamped("dead", int(floor(foxy_death_anim_time * float(FOXY_ANIM_SPEEDS["dead"]))))
	if foxy_hurt_cooldown > 0.0:
		var hurt_time: float = maxf(1.0 - foxy_hurt_cooldown, 0.0)
		return _foxy_frame_clamped("dead", int(floor(hurt_time * float(FOXY_ANIM_SPEEDS["dead"]))))
	if foxy_landing_anim_time > 0.0:
		return _foxy_frame_clamped("fall", 1)
	if foxy_dash_anim_time >= 0.0 and (foxy_dash_timer > 0.0 or foxy_dash_hold_until_ground):
		return _foxy_dash_texture()
	if not foxy_on_ground:
		if foxy_velocity.y < 0.0:
			return _foxy_jump_texture()
		return _foxy_frame_clamped("fall", 0)
	if absf(foxy_velocity.x) > 4.0:
		return _foxy_frame("run", int(floor(elapsed * float(FOXY_ANIM_SPEEDS["run"]))))
	return _foxy_frame("idle", int(floor(elapsed * float(FOXY_ANIM_SPEEDS["idle"]))))


func _foxy_jump_texture() -> Texture2D:
	if foxy_air_anim_time < FOXY_JUMP_START_FRAME_TIME:
		return _foxy_frame_clamped("jump", 0)
	if foxy_air_anim_time < FOXY_JUMP_RISE_FRAME_TIME:
		return _foxy_frame_clamped("jump", 1)
	return _foxy_frame_clamped("jump", 2)


func _foxy_enemy_current_texture(enemy: Dictionary) -> Texture2D:
	var sprite_name := str(enemy.get("sprite", "enemy_wolf"))
	if bool(enemy.get("dying", false)):
		return _foxy_enemy_frame_clamped(sprite_name, "deading", int(floor(float(enemy.get("death_anim_time", 0.0)) * float(FOXY_ENEMY_ANIM_SPEEDS["deading"]))))
	if sprite_name == "enemy_kao":
		if float(enemy.get("landing_anim_time", 0.0)) > 0.0:
			return _foxy_enemy_frame_clamped(sprite_name, "fall", 1)
		var enemy_rect: Rect2 = enemy["rect"]
		var base_y := float(enemy.get("base_y", enemy_rect.position.y))
		if enemy_rect.position.y < base_y - 0.01:
			if float(enemy.get("vel_y", 0.0)) < 0.0:
				return _foxy_enemy_jump_texture(sprite_name, float(enemy.get("air_anim_time", 0.0)))
			return _foxy_enemy_frame_clamped(sprite_name, "fall", 0)
		return _foxy_enemy_frame_clamped(sprite_name, "jump", 0)
	return _foxy_enemy_frame(sprite_name, "run", int(floor(elapsed * float(FOXY_ENEMY_ANIM_SPEEDS["run"]))))


func _foxy_enemy_jump_texture(sprite_name: String, air_anim_time: float) -> Texture2D:
	if air_anim_time < FOXY_JUMP_START_FRAME_TIME:
		return _foxy_enemy_frame_clamped(sprite_name, "jump", 0)
	if air_anim_time < FOXY_JUMP_RISE_FRAME_TIME:
		return _foxy_enemy_frame_clamped(sprite_name, "jump", 1)
	return _foxy_enemy_frame_clamped(sprite_name, "jump", 2)


func _foxy_dash_texture() -> Texture2D:
	return _foxy_frame_clamped("dash", int(floor(foxy_dash_anim_time * float(FOXY_ANIM_SPEEDS["dash"]))))


func _foxy_frame(state_name: String, frame_index: int) -> Texture2D:
	var frames: Array = foxy_sprite_frames.get(state_name, [])
	if frames.is_empty() and state_name != "idle":
		frames = foxy_sprite_frames.get("idle", [])
	if frames.is_empty():
		return null
	return frames[wrapi(frame_index, 0, frames.size())]


func _foxy_frame_clamped(state_name: String, frame_index: int) -> Texture2D:
	var frames: Array = foxy_sprite_frames.get(state_name, [])
	if frames.is_empty() and state_name != "idle":
		frames = foxy_sprite_frames.get("idle", [])
	if frames.is_empty():
		return null
	return frames[clampi(frame_index, 0, frames.size() - 1)]


func _foxy_enemy_frame(sprite_name: String, state_name: String, frame_index: int) -> Texture2D:
	var sprite_states: Dictionary = foxy_enemy_sprite_frames.get(sprite_name, {})
	var frames: Array = sprite_states.get(state_name, [])
	if frames.is_empty():
		return null
	return frames[wrapi(frame_index, 0, frames.size())]


func _foxy_enemy_frame_clamped(sprite_name: String, state_name: String, frame_index: int) -> Texture2D:
	var sprite_states: Dictionary = foxy_enemy_sprite_frames.get(sprite_name, {})
	var frames: Array = sprite_states.get(state_name, [])
	if frames.is_empty():
		return null
	return frames[clampi(frame_index, 0, frames.size() - 1)]


func _world_to_game_rect(world_rect: Rect2) -> Rect2:
	return Rect2(Vector2(world_rect.position.x - foxy_camera_x, world_rect.position.y), world_rect.size)


func _draw_game_rect(local_rect: Rect2, color: Color, filled: bool) -> void:
	draw_rect(Rect2(ARCADE_SCREEN_RECT.position + local_rect.position, local_rect.size), color, filled)


func _draw_game_texture_feet(texture: Texture2D, local_feet_pos: Vector2, draw_size: Vector2, flipped: bool, color: Color) -> void:
	var local_rect := Rect2(local_feet_pos - Vector2(draw_size.x * 0.5, draw_size.y), draw_size)
	_draw_game_texture_rect(texture, local_rect, flipped, color)


func _draw_game_texture_rect(texture: Texture2D, local_rect: Rect2, flipped: bool, color: Color) -> void:
	var screen_rect := Rect2(ARCADE_SCREEN_RECT.position + local_rect.position, local_rect.size)
	if flipped:
		draw_set_transform(screen_rect.position + Vector2(screen_rect.size.x, 0.0), 0.0, Vector2(-1.0, 1.0))
		draw_texture_rect(texture, Rect2(Vector2.ZERO, screen_rect.size), false, color)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_texture_rect(texture, screen_rect, false, color)


func _draw_game_texture_region(texture: Texture2D, local_rect: Rect2, source_rect: Rect2, color: Color = COLOR_WHITE) -> void:
	draw_texture_rect_region(texture, Rect2(ARCADE_SCREEN_RECT.position + local_rect.position, local_rect.size), source_rect, color)


func _draw_game_text(font_key: String, local_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int) -> void:
	_draw_text(font_key, ARCADE_SCREEN_RECT.position + local_pos, text, color, alpha, halign, valign)


func _draw_grid() -> void:
	for grid_x in range(0, int(VIEW_W), 64):
		draw_line(Vector2(float(grid_x), 128.0), Vector2(float(grid_x), 620.0), Color(0.08, 0.08, 0.08, 1.0), 1.0)
	for grid_y in range(128, 621, 64):
		draw_line(Vector2(40.0, float(grid_y)), Vector2(1120.0, float(grid_y)), Color(0.08, 0.08, 0.08, 1.0), 1.0)


func _draw_give_gifts() -> void:
	for target in targets:
		var target_pos: Vector2 = target["pos"]
		_draw_child(target_pos, bool(target["life"]))
		if bool(target["gift"]):
			_draw_gift(target_pos + Vector2(-28.0, 42.0))
		if bool(target["life"]):
			_draw_mask(target_pos + Vector2(-16.0, -54.0))
	_draw_puppet(player_pos)
	var label := "GIVE GIFTS" if phase == 0 else "GIVE LIFE"
	_draw_text("menubt", Vector2(640.0, 116.0), label, COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP)


func _draw_take_cake() -> void:
	draw_rect(Rect2(54.0, 584.0, VIEW_W - 108.0, 36.0), Color(0.11, 0.11, 0.11, 1.0), true)
	draw_rect(Rect2(car_x, 584.0, 118.0, 36.0), COLOR_PURPLE, true)
	draw_rect(Rect2(car_x + 12.0, 574.0, 70.0, 18.0), COLOR_PURPLE, true)
	for target in targets:
		var target_pos: Vector2 = target["pos"]
		var served := bool(target["served"])
		_draw_child(target_pos, served)
		if served:
			_draw_cake(target_pos + Vector2(-18.0, 42.0))
		else:
			var patience := float(target["patience"])
			draw_rect(Rect2(target_pos + Vector2(-24.0, 56.0), Vector2(48.0 * patience, 6.0)), COLOR_RED.lerp(COLOR_GREEN, patience), true)
	_draw_freddy(player_pos)
	_draw_text("menubt", Vector2(640.0, 116.0), "TAKE CAKE", COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(1040.0, 116.0), str(int(ceil(time_left))), COLOR_YELLOW, 1.0, HALIGN_RIGHT, VALIGN_TOP)


func _draw_overlay_text() -> void:
	_draw_text("cnsmall", Vector2(64.0, 42.0), _active_title(), COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("footer", Vector2(64.0, 670.0), GameState.t("minigame_controls"), COLOR_GRAY, 1.0, HALIGN_LEFT, VALIGN_TOP)
	if completed or failed:
		var label := GameState.t("minigame_complete") if completed else GameState.t("minigame_failed")
		var color := COLOR_GREEN if completed else COLOR_RED
		draw_rect(Rect2(0.0, 0.0, VIEW_W, VIEW_H), Color(0.0, 0.0, 0.0, 0.55), true)
		_draw_text("menubt", Vector2(640.0, 314.0), label, color, 1.0, HALIGN_CENTER, VALIGN_MIDDLE)
		_draw_text("footer", Vector2(640.0, 376.0), "SPACE / ENTER", COLOR_GRAY, 1.0, HALIGN_CENTER, VALIGN_TOP)


func _active_title() -> String:
	for i in range(GameState.minigame_count()):
		if str(GameState.minigame_preset(i).get("id", "")) == mode_id:
			return GameState.minigame_title(i)
	return GameState.t("minigames_title")


func _draw_child(center_pos: Vector2, revived: bool) -> void:
	var body_color := Color(0.75, 0.75, 0.75, 1.0) if revived else Color(0.36, 0.36, 0.36, 1.0)
	draw_rect(Rect2(center_pos + Vector2(-14.0, -24.0), Vector2(28.0, 28.0)), body_color, true)
	draw_rect(Rect2(center_pos + Vector2(-18.0, 6.0), Vector2(36.0, 42.0)), body_color, true)


func _draw_puppet(center_pos: Vector2) -> void:
	draw_rect(Rect2(center_pos + Vector2(-14.0, -40.0), Vector2(28.0, 36.0)), COLOR_WHITE, true)
	draw_rect(Rect2(center_pos + Vector2(-22.0, -2.0), Vector2(44.0, 62.0)), COLOR_PURPLE, true)
	draw_rect(Rect2(center_pos + Vector2(-8.0, -28.0), Vector2(5.0, 5.0)), COLOR_BLACK, true)
	draw_rect(Rect2(center_pos + Vector2(3.0, -28.0), Vector2(5.0, 5.0)), COLOR_BLACK, true)


func _draw_freddy(center_pos: Vector2) -> void:
	var brown := Color(0.45, 0.24, 0.10, 1.0)
	draw_rect(Rect2(center_pos + Vector2(-18.0, -34.0), Vector2(36.0, 34.0)), brown, true)
	draw_rect(Rect2(center_pos + Vector2(-24.0, 2.0), Vector2(48.0, 58.0)), brown, true)
	draw_rect(Rect2(center_pos + Vector2(-10.0, -50.0), Vector2(20.0, 14.0)), COLOR_BLACK, true)
	_draw_cake(center_pos + Vector2(28.0, -12.0))


func _draw_gift(top_left: Vector2) -> void:
	draw_rect(Rect2(top_left, Vector2(36.0, 28.0)), COLOR_YELLOW, true)
	draw_rect(Rect2(top_left + Vector2(15.0, 0.0), Vector2(6.0, 28.0)), COLOR_RED, true)
	draw_rect(Rect2(top_left + Vector2(0.0, 11.0), Vector2(36.0, 6.0)), COLOR_RED, true)


func _draw_mask(top_left: Vector2) -> void:
	draw_rect(Rect2(top_left, Vector2(32.0, 24.0)), COLOR_WHITE, true)
	draw_rect(Rect2(top_left + Vector2(7.0, 8.0), Vector2(5.0, 5.0)), COLOR_BLACK, true)
	draw_rect(Rect2(top_left + Vector2(20.0, 8.0), Vector2(5.0, 5.0)), COLOR_BLACK, true)


func _draw_cake(top_left: Vector2) -> void:
	draw_rect(Rect2(top_left, Vector2(38.0, 20.0)), Color(0.95, 0.62, 0.72, 1.0), true)
	draw_rect(Rect2(top_left + Vector2(0.0, 14.0), Vector2(38.0, 6.0)), Color(0.55, 0.25, 0.12, 1.0), true)


func _register_vector_font(font_key: String, size: int, line_step: int) -> void:
	font_data[font_key] = {"size": size, "line_step": line_step}


func _draw_text(font_key: String, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int) -> void:
	if not font_data.has(font_key) or fallback_font == null:
		return
	var data: Dictionary = font_data[font_key]
	var lines := text.split("\n")
	var line_step := float(data["line_step"])
	var base_font_size := float(data["size"])
	var visual_font_size := base_font_size + ((line_step - base_font_size) * 0.25)
	var font_size := int(max(round(visual_font_size), 8.0))
	var ascent := fallback_font.get_ascent(font_size)
	var total_height := line_step * lines.size()
	var start := screen_pos
	if valign == VALIGN_MIDDLE:
		start.y -= total_height * 0.5
	var text_color := Color(color.r, color.g, color.b, color.a * alpha)
	for line_index in range(lines.size()):
		var text_line := str(lines[line_index])
		var line_width := fallback_font.get_string_size(text_line, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
		var text_x := start.x
		if halign == HALIGN_CENTER:
			text_x -= line_width * 0.5
		elif halign == HALIGN_RIGHT:
			text_x -= line_width
		var baseline := start.y + (float(line_index) * line_step) + ascent
		draw_string(fallback_font, Vector2(text_x, baseline), text_line, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, text_color)
