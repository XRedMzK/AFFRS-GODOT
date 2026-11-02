extends SceneTree

const NIGHT_SCENE := "res://scenes/night/NightScene.tscn"
const DEFAULT_FRAMES := 720
const DEFAULT_WARMUP_FRAMES := 120
const TARGET_DT := 1.0 / 60.0
const SCENARIOS := ["office_idle", "office_stress", "cctv_map", "cctv_disabled", "story6_auto"]

var frames := DEFAULT_FRAMES
var warmup_frames := DEFAULT_WARMUP_FRAMES
var selected_scenarios: Array = []


func _init() -> void:
	_run.call_deferred()


func _run() -> void:
	_parse_args()
	var game_state: Variant = root.get_node("/root/GameState")
	_apply_perf_options(game_state)
	print("PERF_BENCH_START frames=%d warmup=%d display=%s" % [frames, warmup_frames, DisplayServer.get_name()])
	for scenario in selected_scenarios:
		await _run_scenario(game_state, scenario)
	print("PERF_BENCH_DONE")
	quit(0)


func _parse_args() -> void:
	selected_scenarios = SCENARIOS.duplicate()
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with("--frames="):
			frames = max(int(arg.get_slice("=", 1)), 1)
		elif arg.begins_with("--warmup="):
			warmup_frames = max(int(arg.get_slice("=", 1)), 0)
		elif arg.begins_with("--scenario="):
			var value := arg.get_slice("=", 1).strip_edges()
			if value != "" and value != "all":
				selected_scenarios.clear()
				for scenario in value.split(",", false):
					var scenario_name := str(scenario).strip_edges()
					if SCENARIOS.has(scenario_name):
						selected_scenarios.append(scenario_name)
	if selected_scenarios.is_empty():
		selected_scenarios = SCENARIOS.duplicate()


func _apply_perf_options(game_state: Variant) -> void:
	Engine.max_fps = 0
	game_state.start_story_night(6)
	game_state.mastervol = 0
	game_state.musicvol = 0
	game_state.fullscreen = false
	game_state.vsync = false
	game_state.antialiasing = 0
	game_state.upscaler = 0
	game_state.performance_mode = false
	game_state.particles = true
	game_state.perspective = true
	game_state.radar = false
	game_state.hiderewards = false
	game_state.phone_guy_voice = "en"


func _run_scenario(game_state: Variant, scenario: String) -> void:
	game_state.start_story_night(6)
	game_state.radar = scenario == "cctv_map"
	game_state.particles = scenario != "cctv_map"
	game_state.perspective = scenario != "cctv_map"
	var packed: PackedScene = load(NIGHT_SCENE)
	var night: Variant = packed.instantiate()
	root.add_child(night)
	await process_frame
	Engine.max_fps = 0
	_configure_common(night)
	_configure_scenario(night, scenario)
	night.perf_profile_start()
	for i in range(warmup_frames):
		_stabilize_scenario(night, scenario, i)
		await process_frame
	night.perf_profile_reset()
	var start_us := Time.get_ticks_usec()
	for i in range(frames):
		_stabilize_scenario(night, scenario, i)
		await process_frame
	var elapsed_us := Time.get_ticks_usec() - start_us
	var rows: Array = night.perf_profile_snapshot()
	_print_scenario_result(scenario, elapsed_us, rows)
	night.perf_profile_stop()
	night.set_process(false)
	night.queue_free()
	await process_frame


func _configure_common(night: Variant) -> void:
	night.scene_entry_fade_duration = 0.0
	night.scene_entry_fade_elapsed = 0.0
	night.phone_call_state = night.PHONE_CALL_OFF
	night.is_dead = false
	night.is_game_over = false
	night.is_night_complete = false
	night.is_power_empty = false
	night.power_out_started = false
	night.scare_ready = false
	night.scare_unit.clear()
	night.night_power = min(night.night_power, night.night_limit * 0.3)
	night.night_time = min(night.night_time, night.night_goal * 0.45)
	for ai in night.ai_units:
		ai["active"] = false
		ai["move"] = -999999.0


func _configure_scenario(night: Variant, scenario: String) -> void:
	match scenario:
		"office_idle":
			_configure_office_idle(night)
		"office_stress":
			_configure_office_stress(night)
		"cctv_map":
			_configure_cctv_map(night)
		"cctv_disabled":
			_configure_cctv_disabled(night)
		"story6_auto":
			_configure_story6_auto(night)


func _configure_office_idle(night: Variant) -> void:
	night.night_state = night.STATE_OFFICE
	night.current_view = night.VIEW_NONE
	night.view_light_held = false
	night.hallucination_is_active = false
	night.hallucination_activity = 0
	night.blackout_alpha = 0.0
	night._reset_dust_particles()


func _configure_office_stress(night: Variant) -> void:
	night.night_state = night.STATE_OFFICE
	night.current_view = night.VIEW_FRONT
	night.looking_at = 13
	night.view_light_held = true
	night.blackout_alpha = 0.45
	night.hallucination_is_active = true
	night.hallucination_activity = 999999
	night.hallucination_whole = false
	night.tx_anim_time = 0.5
	night.gf_overlay_time = 1.0
	night.night_toxic = night.night_lung * 0.85
	night._reset_dust_particles()
	_set_ai(night, "ai_tf", "office", 8)
	_set_ai(night, "ai_wf", "office", 8)
	_set_ai(night, "ai_wb", "office", 8)
	_set_ai(night, "ai_wc", "office", 8)
	_set_ai(night, "ai_tb", "officeclose", 8)
	_set_ai(night, "ai_tc", "officeclose", 8)
	_set_ai(night, "ai_tx", "officetx", 8)
	night.ai_by_id["ai_tb"]["commit_time"] = 40.0
	night.ai_by_id["ai_tc"]["commit_time"] = 40.0


func _configure_cctv_map(night: Variant) -> void:
	night.night_state = night.STATE_CCTV
	night.current_cam = 7
	night.looking_at = 7
	night.cctv_map_alpha = 1.0
	night.cctv_noise_alpha = 0.35
	night.cctv_cam_transition = 0.12
	night.cctv_disabled_timer = 0.0
	night.cctv_light_held = true
	var rooms := ["showstage", "dininghall", "prizecorner", "mainhall", "kitchen", "kidscove", "gamearea", "westpartyroom", "eastpartyroom", "frontclose", "left"]
	var index := 0
	for ai in night.ai_units:
		ai["active"] = true
		ai["difficulty"] = 10
		night._set_ai_room(ai, rooms[index % rooms.size()])
		index += 1
	night._set_ai_room(night.ai_by_id["ai_bb"], "gamearea")
	night.ai_by_id["ai_bb"]["active"] = true


func _configure_cctv_disabled(night: Variant) -> void:
	night.night_state = night.STATE_CCTV
	night.current_cam = 5
	night.looking_at = 5
	night.cctv_map_alpha = 1.0
	night.cctv_noise_alpha = 0.85
	night.cctv_cam_transition = 0.2
	night.cctv_disabled_timer = 999999.0
	night.cctv_disabled_source = "bb"


func _configure_story6_auto(night: Variant) -> void:
	night.night_state = night.STATE_OFFICE
	night.current_view = night.VIEW_NONE
	night.view_light_held = false
	night._reset_night()
	night.scene_entry_fade_duration = 0.0
	night.phone_call_state = night.PHONE_CALL_OFF


func _set_ai(night: Variant, ai_id: String, room_name: String, difficulty: int) -> void:
	var ai: Dictionary = night.ai_by_id[ai_id]
	ai["active"] = true
	ai["difficulty"] = difficulty
	ai["move"] = -999999.0
	night._set_ai_room(ai, room_name)


func _stabilize_scenario(night: Variant, scenario: String, frame_index: int) -> void:
	night.is_dead = false
	night.is_game_over = false
	night.is_night_complete = false
	night.scene_change_queued = false
	night.scare_ready = false
	night.scare_unit.clear()
	night.phone_call_state = night.PHONE_CALL_OFF
	match scenario:
		"office_stress":
			night.night_state = night.STATE_OFFICE
			night.current_view = night.VIEW_FRONT
			night.view_light_held = true
			night.hallucination_is_active = true
			night.hallucination_activity = 999999
			night.blackout_alpha = 0.45
			night.tx_anim_time = fmod(float(frame_index) / 60.0, 1.5)
		"cctv_map":
			night.night_state = night.STATE_CCTV
			night.current_cam = 7
			night.looking_at = 7
			night.cctv_map_alpha = 1.0
			night.cctv_light_held = true
			night.cctv_cam_transition = 0.12
		"cctv_disabled":
			night.night_state = night.STATE_CCTV
			night.current_cam = 5
			night.looking_at = 5
			night.cctv_disabled_timer = 999999.0
			night.cctv_cam_transition = 0.2
		"story6_auto":
			if night.is_dead or night.is_game_over:
				night.is_dead = false
				night.is_game_over = false
				night.scare_ready = false


func _print_scenario_result(scenario: String, elapsed_us: int, rows: Array) -> void:
	var frame_avg_ms := (float(elapsed_us) / 1000.0) / float(frames)
	print("PERF_SCENARIO name=%s frames=%d wall_avg_ms=%.4f wall_total_ms=%.2f" % [scenario, frames, frame_avg_ms, float(elapsed_us) / 1000.0])
	var limit: int = mini(rows.size(), 18)
	for i in range(limit):
		var row: Dictionary = rows[i]
		print("PERF_ROW scenario=%s rank=%02d label=%s calls=%d total_ms=%.4f avg_us=%.2f max_us=%.2f" % [
			scenario,
			i + 1,
			str(row["label"]),
			int(row["calls"]),
			float(row["total_us"]) / 1000.0,
			float(row["avg_us"]),
			float(row["max_us"]),
		])
