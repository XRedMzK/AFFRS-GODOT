extends Node2D

const NIGHT_DRAW_LAYER_SCRIPT := preload("res://scripts/night/NightDrawLayer.gd")
const NIGHT_AI_DATA := preload("res://scripts/night/NightAIData.gd")
const PANORAMA_SHADER := preload("res://shaders/panorama_canvas.gdshader")
const UPSCALE_2D_SHADER := preload("res://shaders/upscale_2d.gdshader")

const VIEW_W := 1280.0
const VIEW_H := 720.0
const ROOM_W := 1700.0
const ROOM_H := 820.0
const CAMERA_Y := 50.0
const CAMERA_MIN_X := 50.0
const CAMERA_MAX_X := 370.0
const CAMERA_START_X := 220.0
const TARGET_FPS := 60.0
const DUST_SPAWN_POSITION := Vector2(416.0, 128.0)
const DUST_SPAWN_SIZE := Vector2(932.0, 298.0)

const LAYER_WORLD := 0
const LAYER_DUST := 1
const LAYER_DESK := 2
const LAYER_CLOSE := 3
const LAYER_LIGHT := 4
const LAYER_MASK := 5
const LAYER_HALLUCINATION_NORMAL := 6
const LAYER_HALLUCINATION_ADD := 7
const LAYER_GF := 8
const LAYER_UI := 9

const STATE_TRANSITION := 0
const STATE_OFFICE := 1
const STATE_CCTV := 2
const STATE_MASK := 3
const PHONE_CALL_OFF := 0
const PHONE_CALL_PENDING := 1
const PHONE_CALL_RINGING := 2
const PHONE_CALL_TALKING := 3
const PHONE_CALL_DONE := 4
const PHONE_CALL_MUTED := 5

const VIEW_NONE := -1
const VIEW_LEFT := 0
const VIEW_FRONT := 1
const VIEW_RIGHT := 2
const MOBILE_TOP_HOVER := Rect2(320.0, 0.0, 640.0, 104.0)
const MOBILE_BOTTOM_HOVER := Rect2(320.0, 616.0, 640.0, 104.0)
const MOBILE_BUTTON_SCALE := Vector2(1.28, 1.35)
const MOBILE_CAM_ACTION_GROW := 16.0
const MOBILE_CCTV_MAP_SCALE := 1.10

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_GRAY := Color(0.5, 0.5, 0.5, 1.0)
const COLOR_YELLOW := Color(1.0, 1.0, 0.0, 1.0)
const COLOR_RED := Color(1.0, 0.0, 0.0, 1.0)
const COLOR_BLACK := Color(0.0, 0.0, 0.0, 1.0)
const COLOR_LAMP := Color(230.0 / 255.0, 1.0, 234.0 / 255.0, 1.0)
const COLOR_CAM_UNSELECTED := Color(53.0 / 255.0, 33.0 / 255.0, 19.0 / 255.0, 1.0)
const COLOR_CAM_HOVER := Color(130.0 / 255.0, 102.0 / 255.0, 59.0 / 255.0, 1.0)
const COLOR_CAM_SELECTED := Color(1.0, 216.0 / 255.0, 0.0, 1.0)
const EMPTY_ROOM_DETAIL := ["empty", -4.0, "walk", 99, 0, 0, 1]

const HALLUCINATION_CHANCE_CHANGE := 0.5
const HALLUCINATION_CHANCE_PALCHOP := 0.01
const HALLUCINATION_CHANCE_EMPTY := 0.35
const HALLUCINATION_CHANCE_WHOLE := 0.25
const HALLUCINATION_CHANCE_RANDOM := 0.1
const DIRECTOR_CHAOS_THRESHOLD := 35.0
const DIRECTOR_RECOVERY_SECONDS := 4.5
const DIRECTOR_HIGH_RISK_WINDOW_SECONDS := 4.5
const DIRECTOR_DELAY_SECONDS := 2.5
const DIRECTOR_STABLE_NOW_GRACE_SECONDS := 0.45
const DIRECTOR_CHAOS_NOW_GRACE_SECONDS := 0.25
const DIRECTOR_NO_ERROR_SECONDS := 8.0
const DIRECTOR_CAMERA_IDLE_SECONDS := 18.0
const DIRECTOR_VIEW_IDLE_SECONDS := 18.0
const DIRECTOR_FOXY_NEGLECT_SECONDS := 8.0
const DIRECTOR_FOXY_NEGLECT_COOLDOWN_SECONDS := 7.0
const DIRECTOR_FRONT_FLASH_SPAM_SECONDS := 1.5
const DIRECTOR_POWER_LOW_PERCENT := 30.0
const DIRECTOR_POWER_CRITICAL_PERCENT := 15.0
const DIRECTOR_TOXIC_HIGH_RATIO := 0.70

const HALIGN_LEFT := 0
const HALIGN_CENTER := 1
const HALIGN_RIGHT := 2
const VALIGN_TOP := 0
const VALIGN_MIDDLE := 1

const TOP_HOVER := Rect2(385.0, 0.0, 480.0, 60.0)
const BOTTOM_HOVER := Rect2(385.0, 660.0, 480.0, 60.0)
const HONK_WORLD_RECT := Rect2(1104.0, 278.0, 14.0, 14.0)
const CAM_LIGHT_RECT := Rect2(1080.0, 611.0, 156.0, 63.0)
const MUSIC_BOX_RECT := Rect2(560.0, 112.0, 156.0, 63.0)
const MUTE_CALL_RECT := Rect2(41.0, 166.0, 112.0, 32.0)
const CCTV_MAP_POS := Vector2(820.0, 375.0)
const CCTV_MAP_SCALE := Vector2(2.0, 2.0)
const CCTV_MAP_YOU_POS := Vector2(926.0, 645.0)
const CCTV_MAP_YOU_MARKER_POS := Vector2(937.0, 668.0)
const CCTV_MAP_CAM_NAME_POS := Vector2(1235.0, 335.0)

const VIEW_RECTS := [
	Rect2(0.0, 320.0, 385.0, 500.0),
	Rect2(668.0, 145.0, 362.0, 445.0),
	Rect2(1312.0, 320.0, 388.0, 500.0),
]

const VIEW_DRAW_DATA := [
	{"frames": "left", "camera_goal": 0.0, "looking": 12, "draw_pos": Vector2(0.0, 284.0), "flash": "left", "flash_pos": Vector2(0.0, 310.0)},
	{"frames": "front", "camera_goal": 210.0, "looking": 13, "draw_pos": Vector2(679.0, 170.0), "flash": "front", "flash_pos": Vector2(642.0, 203.0)},
	{"frames": "right", "camera_goal": 420.0, "looking": 14, "draw_pos": Vector2(1275.0, 285.0), "flash": "right", "flash_pos": Vector2(1232.0, 308.0)},
]

var cam_buttons := [
	{"cam": 5, "rect": Rect2(842.0, 385.0, 60.0, 74.0)},
	{"cam": 4, "rect": Rect2(914.0, 415.0, 154.0, 44.0)},
	{"cam": 0, "rect": Rect2(1136.0, 375.0, 99.0, 41.0)},
	{"cam": 6, "rect": Rect2(842.0, 469.0, 60.0, 73.0)},
	{"cam": 7, "rect": Rect2(986.0, 469.0, 82.0, 73.0)},
	{"cam": 2, "rect": Rect2(1080.0, 469.0, 90.0, 72.0)},
	{"cam": 1, "rect": Rect2(1180.0, 481.0, 56.0, 72.0)},
	{"cam": 8, "rect": Rect2(820.0, 551.0, 82.0, 48.0)},
	{"cam": 9, "rect": Rect2(986.0, 551.0, 82.0, 48.0)},
	{"cam": 3, "rect": Rect2(1080.0, 551.0, 90.0, 48.0)},
]

var cam_data := [
	{"name": "Show Stage", "name_key": "cam_show_stage", "label": "CAM\n01", "light": false},
	{"name": "Backstage", "name_key": "cam_backstage", "label": "CAM\n02", "light": false},
	{"name": "Dining Hall", "name_key": "cam_dining_hall", "label": "CAM\n03", "light": true},
	{"name": "Prize Corner", "name_key": "cam_prize_corner", "label": "CAM\n04", "light": true},
	{"name": "Main Hall", "name_key": "cam_main_hall", "label": "CAM\n05", "light": true},
	{"name": "Kitchen", "name_key": "cam_kitchen", "label": "CAM\n06", "light": false},
	{"name": "Kids Cove", "name_key": "cam_kids_cove", "label": "CAM\n07", "light": true},
	{"name": "Game Area", "name_key": "cam_game_area", "label": "CAM\n08", "light": true},
	{"name": "West Party Room", "name_key": "cam_west_party", "label": "CAM\n09", "light": true},
	{"name": "East Party Room", "name_key": "cam_east_party", "label": "CAM\n10", "light": true},
]

var office_texture: Texture2D
var lamp_texture: Texture2D
var flash_left_texture: Texture2D
var flash_front_texture: Texture2D
var flash_right_texture: Texture2D
var flash_icon_texture: Texture2D
var button_cam_texture: Texture2D
var button_mask_texture: Texture2D
var mask_overlay_texture: Texture2D
var toxicity_texture: Texture2D
var beta_notice_texture: Texture2D
var cctv_lines_texture: Texture2D
var cctv_map_texture: Texture2D
var cctv_watch_texture: Texture2D
var table_texture: Texture2D
var one_px_texture: Texture2D
var dust_texture: Texture2D

var view_frames := {}
var fan_frames: Array[Texture2D] = []
var flippanel_frames: Array[Texture2D] = []
var flipmask_frames: Array[Texture2D] = []
var cctv_bg_frames: Array[Texture2D] = []
var cctv_ol_frames: Array[Texture2D] = []
var cctv_noise_frames: Array[Texture2D] = []
var cctv_indicator_frames: Array[Texture2D] = []
var over_character_frames: Array[Texture2D] = []
var scare_frames := {}
var inoffice_textures := {}
var cctv_shake_frames := {}
var cctv_shake_origins := {}
var view_shake_frames := {}
var view_shake_origins := {}
var inoffice_close_frames: Array[Texture2D] = []
var hallucination_frames: Array[Texture2D] = []
var radar_icons := {}
var inoffice_frames := {}

var font_data := {}
var text_width_cache := {}
var text_layout_cache := {}
var fallback_font: FontFile
var pixelmix_fallback_font: FontFile
var audio_players := {}
var world_layer: Node2D
var light_layer: Node2D
var dust_layer: Node2D
var desk_layer: Node2D
var close_layer: Node2D
var mask_layer: Node2D
var ui_layer: Node2D
var hallucination_normal_layer: Node2D
var hallucination_add_layer: Node2D
var gf_layer: Node2D
var panorama_copy: BackBufferCopy
var panorama_rect: ColorRect
var panorama_material: ShaderMaterial
var active_canvas: CanvasItem
var render_viewport: SubViewport
var render_root: Node2D
var render_output: TextureRect
var render_material: ShaderMaterial
var applied_render_scale := -1.0
var applied_upscaler := -1

var camx := CAMERA_START_X
var camera_mode := 0
var camera_goal := -1.0
var night_state := STATE_OFFICE
var previous_state := STATE_OFFICE
var transition_name := ""
var transition_elapsed := 0.0
var transition_duration := 0.22

var elapsed := 0.0
var fog_alpha := 1.0
var fog_soft_target := 1.0
var fog_hard_target := 1.0
var fog_variance := 0.5

var current_cam := 4
var cctv_map_alpha := 0.2
var cctv_cam_transition := 0.0
var cctv_noise_alpha := 0.1
var cctv_noise_target := 0.1
var cctv_light_held := false
var music_box_held := false

var current_view := VIEW_NONE
var view_light_held := false
var looking_at := 15
var view_scare_used := [false, false, false]

var cctv_hover_latched := false
var mask_hover_latched := false
var mask_yoffset := 0.0
var mask_y_direction := 1.0
var mask_y_speed := 0.0
var mask_y_acceleration := 0.0

var night_time := 0.0
var night_goal := 1.0
var night_power := 0.0
var night_limit := 1.0
var night_usage := 1
var night_toxic := 0.0
var night_lung := 1.0
var t_more_usage := 0.0
var is_power_empty := false
var power_out_started := false
var power_out_timer := 0.0
var is_mask_too_much := false
var is_night_complete := false
var story_applied_hour_index := -1
var time_names := ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM"]
var room_details: Array = []
var room_detail_by_name := {}
var ai_units: Array = []
var ai_by_id := {}
var view_disabled_timer := 0.0
var cctv_disabled_timer := 0.0
var cctv_disabled_source := ""
var cctv_disabled_cam := -1
var blackout_timer := 0.0
var blackout_alpha := 0.0
var scare_ready := false
var scare_unit: Dictionary = {}
var scare_time := 0.0
var scare_delay := 0.0
var is_dead := false
var is_game_over := false
var jumpscare_time := 0.0
var game_over_time := 0.0
var last_killer := ""
var bb_laugh_timer := 0.0
var bb_power_debt := 0.0
var tx_anim_time := -1.0
var gf_overlay_time := -1.0
var hallucination_is_active := false
var hallucination_activity := 0
var hallucination_step_accumulator := 0.0
var hallucination_roomclock := 0
var hallucination_frame := 0
var hallucination_whole := false
var hallucination_draw_scale := 1.0
var dust_particles := []
var tb_close_x := 1328.0
var tc_close_x := -624.0
var scene_entry_fade_duration := 0.0
var scene_entry_fade_elapsed := 0.0
var scene_change_queued := false
var phone_call_state := PHONE_CALL_OFF
var director_chaos := 0.0
var director_recovery := 0.0
var director_recent_kill_risk := 0.0
var director_state := "stable"
var director_high_risk_window := 0.0
var director_high_risk_count := 0
var director_camera_idle := 0.0
var director_view_idle := 0.0
var director_front_idle := 0.0
var director_front_flash_hold := 0.0
var director_no_error_timer := 0.0
var director_foxy_neglect_cooldown := 0.0
var director_low_power_armed := true
var director_toxic_armed := true
var director_forced_grace := 0.0
var perf_profile_enabled := false
var perf_profile_totals := {}


func _ready() -> void:
	GameState.apply_options()
	_load_assets()
	_setup_audio()
	_setup_render_backend()
	_setup_layers()
	_reset_night()
	GameState.finish_scene_transition()
	scene_entry_fade_duration = GameState.consume_scene_entry_fade_seconds()
	scene_entry_fade_elapsed = 0.0
	_sync_panorama_layer()
	if DisplayServer.get_name() != "headless":
		_play_loop("track")
		_play_loop("fan")


func _exit_tree() -> void:
	for player in audio_players.values():
		if player == null:
			continue
		player.stop()
		player.stream = null
	audio_players.clear()
	font_data.clear()
	view_frames.clear()
	fan_frames.clear()
	flippanel_frames.clear()
	flipmask_frames.clear()
	cctv_bg_frames.clear()
	cctv_ol_frames.clear()
	cctv_noise_frames.clear()
	cctv_indicator_frames.clear()
	over_character_frames.clear()
	scare_frames.clear()
	inoffice_textures.clear()
	inoffice_frames.clear()
	cctv_shake_frames.clear()
	cctv_shake_origins.clear()
	view_shake_frames.clear()
	view_shake_origins.clear()
	inoffice_close_frames.clear()
	hallucination_frames.clear()
	radar_icons.clear()
	dust_particles.clear()
	text_width_cache.clear()
	text_layout_cache.clear()
	if panorama_rect != null:
		panorama_rect.material = null
	panorama_material = null
	fallback_font = null
	pixelmix_fallback_font = null
	active_canvas = null
	if render_output != null:
		render_output.material = null
		render_output.texture = null
	render_material = null
	render_viewport = null
	render_root = null
	render_output = null


func perf_profile_start() -> void:
	perf_profile_enabled = true
	perf_profile_reset()


func perf_profile_stop() -> void:
	perf_profile_enabled = false


func perf_profile_reset() -> void:
	perf_profile_totals.clear()


func perf_profile_snapshot() -> Array:
	var rows := []
	for label in perf_profile_totals.keys():
		var data: Dictionary = perf_profile_totals[label]
		var calls := int(data.get("calls", 0))
		if calls <= 0:
			continue
		var total_us := float(data.get("total_us", 0.0))
		rows.append({
			"label": str(label),
			"calls": calls,
			"total_us": total_us,
			"avg_us": total_us / float(calls),
			"max_us": float(data.get("max_us", 0.0)),
		})
	rows.sort_custom(func(a, b): return float(a["total_us"]) > float(b["total_us"]))
	return rows


func _perf_tick() -> int:
	return Time.get_ticks_usec()


func _perf_record(label: String, elapsed_us: int) -> void:
	if elapsed_us < 0:
		return
	var data: Dictionary = perf_profile_totals.get(label, {"total_us": 0.0, "calls": 0, "max_us": 0.0})
	var elapsed_float := float(elapsed_us)
	data["total_us"] = float(data["total_us"]) + elapsed_float
	data["calls"] = int(data["calls"]) + 1
	data["max_us"] = max(float(data["max_us"]), elapsed_float)
	perf_profile_totals[label] = data


func _perf_end(label: String, start_us: int) -> void:
	_perf_record(label, Time.get_ticks_usec() - start_us)


func _process(delta: float) -> void:
	var frame_scale: float = clamp(delta * TARGET_FPS, 0.0, 4.0)
	elapsed += delta
	if perf_profile_enabled:
		_process_profiled(delta, frame_scale)
		return
	_update_scene_entry_fade(delta)
	_update_phone_call()
	_sync_render_backend()
	if is_dead:
		_update_jumpscare(delta, frame_scale)
		_sync_panorama_layer()
		_queue_draw_layers()
		return
	if is_game_over:
		game_over_time += delta
		_sync_panorama_layer()
		_queue_draw_layers()
		return
	_update_transition(delta)
	_update_camera(frame_scale)
	_update_inputs(frame_scale)
	_update_resources(frame_scale)
	_update_story_director(frame_scale)
	_update_ai(frame_scale)
	_update_scare(frame_scale)
	_update_mask(frame_scale)
	_update_dust(frame_scale)
	_update_close_office_anims(frame_scale)
	_update_hallucination(frame_scale)
	_update_cctv(frame_scale)
	_update_power_out(frame_scale)
	_update_night_audio_state()
	_update_gf_overlay(delta)
	_update_fog(frame_scale)
	_sync_panorama_layer()
	_queue_draw_layers()


func _process_profiled(delta: float, frame_scale: float) -> void:
	var frame_start := _perf_tick()
	var step_start := _perf_tick()
	_update_scene_entry_fade(delta)
	_perf_end("update.scene_entry_fade", step_start)
	step_start = _perf_tick()
	_update_phone_call()
	_perf_end("update.phone_call", step_start)
	step_start = _perf_tick()
	_sync_render_backend()
	_perf_end("update.render_backend_sync", step_start)
	if is_dead:
		step_start = _perf_tick()
		_update_jumpscare(delta, frame_scale)
		_perf_end("update.jumpscare", step_start)
		step_start = _perf_tick()
		_sync_panorama_layer()
		_perf_end("update.panorama_sync", step_start)
		step_start = _perf_tick()
		_queue_draw_layers()
		_perf_end("update.queue_draw_layers", step_start)
		_perf_end("frame.update_total", frame_start)
		return
	if is_game_over:
		step_start = _perf_tick()
		game_over_time += delta
		_perf_end("update.game_over_time", step_start)
		step_start = _perf_tick()
		_sync_panorama_layer()
		_perf_end("update.panorama_sync", step_start)
		step_start = _perf_tick()
		_queue_draw_layers()
		_perf_end("update.queue_draw_layers", step_start)
		_perf_end("frame.update_total", frame_start)
		return
	step_start = _perf_tick()
	_update_transition(delta)
	_perf_end("update.transition", step_start)
	step_start = _perf_tick()
	_update_camera(frame_scale)
	_perf_end("update.camera", step_start)
	step_start = _perf_tick()
	_update_inputs(frame_scale)
	_perf_end("update.inputs", step_start)
	step_start = _perf_tick()
	_update_resources(frame_scale)
	_perf_end("update.resources", step_start)
	step_start = _perf_tick()
	_update_story_director(frame_scale)
	_perf_end("update.story_director", step_start)
	step_start = _perf_tick()
	_update_ai(frame_scale)
	_perf_end("update.ai", step_start)
	step_start = _perf_tick()
	_update_scare(frame_scale)
	_perf_end("update.scare", step_start)
	step_start = _perf_tick()
	_update_mask(frame_scale)
	_perf_end("update.mask", step_start)
	step_start = _perf_tick()
	_update_dust(frame_scale)
	_perf_end("update.dust", step_start)
	step_start = _perf_tick()
	_update_close_office_anims(frame_scale)
	_perf_end("update.close_office_anims", step_start)
	step_start = _perf_tick()
	_update_hallucination(frame_scale)
	_perf_end("update.hallucination", step_start)
	step_start = _perf_tick()
	_update_cctv(frame_scale)
	_perf_end("update.cctv", step_start)
	step_start = _perf_tick()
	_update_power_out(frame_scale)
	_perf_end("update.power_out", step_start)
	step_start = _perf_tick()
	_update_night_audio_state()
	_perf_end("update.night_audio_state", step_start)
	step_start = _perf_tick()
	_update_gf_overlay(delta)
	_perf_end("update.gf_overlay", step_start)
	step_start = _perf_tick()
	_update_fog(frame_scale)
	_perf_end("update.fog", step_start)
	step_start = _perf_tick()
	_sync_panorama_layer()
	_perf_end("update.panorama_sync", step_start)
	step_start = _perf_tick()
	_queue_draw_layers()
	_perf_end("update.queue_draw_layers", step_start)
	_perf_end("frame.update_total", frame_start)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/menu/MenuScene.tscn")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_handle_left_pressed(event.position)
		else:
			_release_hold_inputs()


func _draw_to_layer(draw_kind: int, canvas_item: CanvasItem) -> void:
	active_canvas = canvas_item
	if perf_profile_enabled:
		var draw_start := _perf_tick()
		match draw_kind:
			LAYER_WORLD:
				_draw_world_layer()
			LAYER_LIGHT:
				_draw_light_layer()
			LAYER_DUST:
				_draw_dust_layer()
			LAYER_DESK:
				_draw_desk_layer()
			LAYER_CLOSE:
				_draw_close_layer()
			LAYER_MASK:
				_draw_mask_layer()
			LAYER_HALLUCINATION_NORMAL:
				_draw_hallucination_layer(false)
			LAYER_HALLUCINATION_ADD:
				_draw_hallucination_layer(true)
			LAYER_GF:
				_draw_gf_layer()
			LAYER_UI:
				_draw_ui_layer()
		_perf_end(_perf_draw_layer_label(draw_kind), draw_start)
	else:
		match draw_kind:
			LAYER_WORLD:
				_draw_world_layer()
			LAYER_LIGHT:
				_draw_light_layer()
			LAYER_DUST:
				_draw_dust_layer()
			LAYER_DESK:
				_draw_desk_layer()
			LAYER_CLOSE:
				_draw_close_layer()
			LAYER_MASK:
				_draw_mask_layer()
			LAYER_HALLUCINATION_NORMAL:
				_draw_hallucination_layer(false)
			LAYER_HALLUCINATION_ADD:
				_draw_hallucination_layer(true)
			LAYER_GF:
				_draw_gf_layer()
			LAYER_UI:
				_draw_ui_layer()
	active_canvas = null


func _perf_draw_layer_label(draw_kind: int) -> String:
	match draw_kind:
		LAYER_WORLD:
			return "draw.layer.world"
		LAYER_LIGHT:
			return "draw.layer.light"
		LAYER_DUST:
			return "draw.layer.dust"
		LAYER_DESK:
			return "draw.layer.desk"
		LAYER_CLOSE:
			return "draw.layer.close"
		LAYER_MASK:
			return "draw.layer.mask"
		LAYER_HALLUCINATION_NORMAL:
			return "draw.layer.hallucination_normal"
		LAYER_HALLUCINATION_ADD:
			return "draw.layer.hallucination_add"
		LAYER_GF:
			return "draw.layer.gf"
		LAYER_UI:
			return "draw.layer.ui"
	return "draw.layer.unknown"


func _setup_layers() -> void:
	world_layer = _make_layer("WorldLayer", LAYER_WORLD, false)
	dust_layer = _make_layer("DustLayer", LAYER_DUST, false)
	desk_layer = _make_layer("DeskLayer", LAYER_DESK, false)
	close_layer = _make_layer("CloseOfficeLayer", LAYER_CLOSE, false)
	light_layer = _make_layer("LightLayer", LAYER_LIGHT, true)
	panorama_copy = BackBufferCopy.new()
	panorama_copy.name = "PanoramaBackBufferCopy"
	panorama_copy.copy_mode = BackBufferCopy.COPY_MODE_DISABLED
	(render_root if render_root != null else self).add_child(panorama_copy)
	panorama_rect = ColorRect.new()
	panorama_rect.name = "PanoramaLayer"
	panorama_rect.position = Vector2.ZERO
	panorama_rect.size = Vector2(VIEW_W, VIEW_H)
	panorama_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panorama_material = ShaderMaterial.new()
	panorama_material.shader = PANORAMA_SHADER
	panorama_material.set_shader_parameter("stretch", 0.3)
	panorama_material.set_shader_parameter("compress", 1.2)
	panorama_rect.material = panorama_material
	(render_root if render_root != null else self).add_child(panorama_rect)
	mask_layer = _make_layer("MaskLayer", LAYER_MASK, false)
	hallucination_normal_layer = _make_layer("HallucinationNormalLayer", LAYER_HALLUCINATION_NORMAL, false)
	hallucination_add_layer = _make_layer("HallucinationAddLayer", LAYER_HALLUCINATION_ADD, true)
	gf_layer = _make_layer("GoldenFreddyLayer", LAYER_GF, false)
	ui_layer = _make_layer("UILayer", LAYER_UI, false)


func _setup_render_backend() -> void:
	render_viewport = SubViewport.new()
	render_viewport.name = "RenderViewport"
	render_viewport.disable_3d = true
	render_viewport.transparent_bg = false
	render_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(render_viewport)

	render_root = Node2D.new()
	render_root.name = "RenderRoot"
	render_viewport.add_child(render_root)

	render_output = TextureRect.new()
	render_output.name = "RenderOutput"
	render_output.mouse_filter = Control.MOUSE_FILTER_IGNORE
	render_output.position = Vector2.ZERO
	render_output.size = Vector2(VIEW_W, VIEW_H)
	render_output.stretch_mode = TextureRect.STRETCH_SCALE
	render_output.texture = render_viewport.get_texture()
	add_child(render_output)

	render_material = ShaderMaterial.new()
	render_material.shader = UPSCALE_2D_SHADER
	_sync_render_backend()


func _sync_render_backend() -> void:
	if render_viewport == null or render_root == null or render_output == null:
		return
	var render_scale := GameState.upscaler_render_scale()
	if is_equal_approx(render_scale, applied_render_scale) and applied_upscaler == GameState.upscaler:
		return
	applied_render_scale = render_scale
	applied_upscaler = GameState.upscaler
	var render_size := Vector2i(max(1, int(round(VIEW_W * render_scale))), max(1, int(round(VIEW_H * render_scale))))
	render_viewport.size = render_size
	render_root.scale = Vector2(render_scale, render_scale)
	render_output.position = Vector2.ZERO
	render_output.size = Vector2(VIEW_W, VIEW_H)
	render_output.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR if render_scale < 1.0 else CanvasItem.TEXTURE_FILTER_NEAREST
	if render_scale < 1.0:
		render_material.set_shader_parameter("sharpness", GameState.upscaler_sharpness())
		render_output.material = render_material
	else:
		render_output.material = null


func _sync_panorama_layer() -> void:
	var enabled: bool = GameState.perspective_enabled() and night_state != STATE_CCTV and not is_game_over and not is_dead
	if panorama_copy != null:
		panorama_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT if enabled else BackBufferCopy.COPY_MODE_DISABLED
	if panorama_rect != null:
		panorama_rect.visible = enabled


func _make_layer(layer_name: String, draw_kind: int, additive: bool) -> Node2D:
	var layer := NIGHT_DRAW_LAYER_SCRIPT.new()
	layer.name = layer_name
	layer.night = self
	layer.draw_kind = draw_kind
	if additive:
		var layer_material := CanvasItemMaterial.new()
		layer_material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		layer.material = layer_material
	(render_root if render_root != null else self).add_child(layer)
	return layer


func _queue_draw_layers() -> void:
	for layer in [world_layer, dust_layer, desk_layer, close_layer, light_layer, mask_layer, hallucination_normal_layer, hallucination_add_layer, gf_layer, ui_layer]:
		if layer != null:
			layer.queue_redraw()


func _load_assets() -> void:
	office_texture = _load_sprite("sprt_office_0")
	lamp_texture = _load_sprite("sprt_lamp_0")
	flash_left_texture = _load_sprite("sprt_flashleft_0")
	flash_front_texture = _load_sprite("sprt_flashfront_0")
	flash_right_texture = _load_sprite("sprt_flashright_0")
	flash_icon_texture = _load_sprite("sprt_flashlight_0")
	button_cam_texture = _load_sprite("sprt_buttoncam_0")
	button_mask_texture = _load_sprite("sprt_buttonmask_0")
	mask_overlay_texture = _load_sprite("sprt_maskoverlay_0")
	toxicity_texture = _load_sprite("sprt_toxicity_0")
	beta_notice_texture = _load_sprite("sprt_betabuildnotice_0")
	cctv_lines_texture = _load_sprite("sprt_cctv_lines_0")
	cctv_map_texture = _load_sprite("sprt_cctv_map_0")
	cctv_watch_texture = _load_sprite("sprt_cctv_watch_0")
	table_texture = _load_sprite("sprt_table_0")
	one_px_texture = _load_sprite("sprt_1px_0")
	dust_texture = _load_sprite("sprt_dust_0")

	fan_frames = _load_frames("sprt_fan")
	view_frames["left"] = _load_frames("sprt_viewleft")
	view_frames["front"] = _load_frames("sprt_viewfront")
	view_frames["right"] = _load_frames("sprt_viewright")
	flippanel_frames = _load_frames("sprt_flippanel")
	flipmask_frames = _load_frames("sprt_flipmask")
	cctv_bg_frames = _load_frames("sprt_cctv_bg")
	cctv_ol_frames = _load_frames("sprt_cctv_ol")
	cctv_noise_frames = _load_frames("sprt_cctv_noise")
	cctv_indicator_frames = _load_frames("sprt_cctv_indicators")
	over_character_frames = _load_frames("sprt_over_character")
	for office_name in ["sprt_inoffice_tf", "sprt_inoffice_wf", "sprt_inoffice_wb", "sprt_inoffice_wc", "sprt_inoffice_gf", "sprt_inoffice_bb"]:
		var frames := _load_frames(office_name)
		if not frames.is_empty():
			inoffice_frames[office_name] = frames
			inoffice_textures[office_name] = frames[0]
	inoffice_frames["sprt_inoffice_tx"] = _load_frames("sprt_inoffice_tx")
	inoffice_close_frames = _load_frames("sprt_inoffice_close")
	hallucination_frames = _load_frames("sprt_hallucination")
	_load_cctv_shakes()
	_load_view_shakes()
	_load_radar_icons()

	_register_vector_font("pixelmix", 12, 16)
	_register_vector_font("pixelmixbold", 12, 16)
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	pixelmix_fallback_font = load("res://assets/gm/fonts/font_pixelmix.ttf")


func _load_sprite(sprite_name: String) -> Texture2D:
	var path := _gm_sprite_path(sprite_name)
	if not ResourceLoader.exists(path):
		return null
	return load(path)


func _load_frames(prefix: String) -> Array[Texture2D]:
	var frames: Array[Texture2D] = []
	var frame_index := 0
	while true:
		var path := _gm_sprite_path("%s_%d" % [prefix, frame_index])
		if not ResourceLoader.exists(path):
			break
		frames.append(load(path))
		frame_index += 1
	return frames


func _gm_sprite_path(sprite_name: String) -> String:
	var svg_path := "res://assets/gm/sprites/%s.svg" % sprite_name
	if ResourceLoader.exists(svg_path):
		return svg_path
	return "res://assets/gm/sprites/%s.png" % sprite_name


func _get_scare_frames(sprite_name: String) -> Array:
	if sprite_name == "":
		return []
	if not scare_frames.has(sprite_name):
		scare_frames[sprite_name] = _load_frames(sprite_name)
	return scare_frames.get(sprite_name, [])


func _load_cctv_shakes() -> void:
	var shake_specs := {
		11: {"sprite": "sprt_shake_03_wb", "origin": Vector2(-861.0, -43.0)},
		14: {"sprite": "sprt_shake_03_wc", "origin": Vector2(-104.0, -95.0)},
		16: {"sprite": "sprt_shake_04_wc", "origin": Vector2(-540.0, 0.0)},
		18: {"sprite": "sprt_shake_04_wf", "origin": Vector2(-264.0, 0.0)},
		20: {"sprite": "sprt_shake_05_wb", "origin": Vector2(-638.0, 0.0)},
		22: {"sprite": "sprt_shake_05_wf", "origin": Vector2(-324.0, -88.0)},
		33: {"sprite": "sprt_shake_08_wc", "origin": Vector2(-501.0, -41.0)},
		34: {"sprite": "sprt_shake_08_wf", "origin": Vector2(-825.0, 0.0)},
		38: {"sprite": "sprt_shake_09_wb", "origin": Vector2(-177.0, -30.0)},
		41: {"sprite": "sprt_shake_10_wc", "origin": Vector2(-790.0, 0.0)},
	}
	for overlay_index in shake_specs:
		var spec: Dictionary = shake_specs[overlay_index]
		var frames := _load_frames(str(spec["sprite"]))
		if not frames.is_empty():
			cctv_shake_frames[int(overlay_index)] = frames
			cctv_shake_origins[int(overlay_index)] = spec["origin"]


func _load_view_shakes() -> void:
	var shake_specs := {
		1: {"sprite": "sprt_shake_13_wx1", "origin": Vector2(-804.0, -326.0)},
		3: {"sprite": "sprt_shake_13_wx2", "origin": Vector2(-810.0, -296.0)},
		5: {"sprite": "sprt_shake_13_wb", "origin": Vector2(-721.0, -240.0)},
		6: {"sprite": "sprt_shake_13_wf", "origin": Vector2(-921.0, -216.0)},
	}
	for overlay_index in shake_specs:
		var spec: Dictionary = shake_specs[overlay_index]
		var frames := _load_frames(str(spec["sprite"]))
		if not frames.is_empty():
			view_shake_frames[int(overlay_index)] = frames
			view_shake_origins[int(overlay_index)] = spec["origin"]


func _load_radar_icons() -> void:
	var icon_specs := {
		"ai_tf": "sprt_dude_tf",
		"ai_tb": "sprt_dude_tb",
		"ai_tc": "sprt_dude_tc",
		"ai_tx": "sprt_dude_tx",
		"ai_bb": "sprt_dude_bb",
		"ai_wf": "sprt_dude_wf",
		"ai_wb": "sprt_dude_wb",
		"ai_wc": "sprt_dude_wc",
		"ai_wx": "sprt_dude_wx",
		"ai_gf": "sprt_dude_gf",
		"ai_pp": "sprt_dude_pp",
	}
	for ai_id in icon_specs:
		var frames := _load_frames(icon_specs[ai_id])
		if not frames.is_empty():
			radar_icons[ai_id] = frames


func _setup_audio() -> void:
	_make_audio("track", "res://assets/gm/sounds/soun_track_night.wav", GameState.musicvol, true)
	_make_audio("fan", "res://assets/gm/sounds/soun_fan.wav", GameState.mastervol, true)
	_make_audio("monitor_up", "res://assets/gm/sounds/soun_monitorup.wav", GameState.mastervol, false)
	_make_audio("monitor_down", "res://assets/gm/sounds/soun_monitordown.wav", GameState.mastervol, false)
	_make_audio("cctv_loading", "res://assets/gm/sounds/soun_cctvloading.wav", GameState.mastervol, false)
	_make_audio("change_cam", "res://assets/gm/sounds/soun_changecam.wav", GameState.mastervol, false)
	_make_audio("cctv_recording", "res://assets/gm/sounds/soun_cctvrecording.wav", GameState.mastervol, true)
	_make_audio("mask_on", "res://assets/gm/sounds/soun_maskon.wav", GameState.mastervol, false)
	_make_audio("mask_off", "res://assets/gm/sounds/soun_maskoff.wav", GameState.mastervol, false)
	_make_audio("breath", "res://assets/gm/sounds/soun_deepbreaths.wav", GameState.mastervol, true)
	_make_audio("cam_switch", "res://assets/gm/sounds/soun_select.wav", GameState.mastervol, false)
	_make_audio("cam_noise", "res://assets/gm/sounds/soun_cutcctv.wav", GameState.mastervol, false)
	_make_audio("light_buzz", "res://assets/gm/sounds/soun_lightbuzz.wav", GameState.mastervol, true)
	_make_audio("fail", "res://assets/gm/sounds/soun_selectfail.wav", GameState.mastervol, false)
	_make_audio("honk", "res://assets/gm/sounds/soun_honk.wav", GameState.mastervol, false)
	_make_audio("music_box", "res://assets/gm/sounds/soun_musicbox.wav", GameState.mastervol, true)
	_make_audio("freddy_musicbox", "res://assets/gm/sounds/soun_musicbox.wav", 20, true)
	_make_audio("lifepush", "res://assets/gm/sounds/soun_lifepush.wav", GameState.mastervol, false)
	_make_audio("lifedrain", "res://assets/gm/sounds/soun_lifedrain.wav", GameState.mastervol, true)
	_make_audio("hallucination", "res://assets/gm/sounds/soun_hallucination.wav", GameState.mastervol, true)
	if DisplayServer.get_name() != "headless":
		_prime_paused_loop("hallucination")
	_make_audio("prizecornerbg", "res://assets/gm/sounds/soun_prizecornerbg.wav", GameState.mastervol, true)
	_make_audio("puppetout", "res://assets/gm/sounds/soun_puppetout.wav", GameState.mastervol, true)
	_make_audio("manglestatic", "res://assets/gm/sounds/soun_manglestatic.wav", GameState.mastervol, true)
	_make_audio("viewscare", "res://assets/gm/sounds/soun_viewscare.wav", GameState.mastervol, false)
	_make_audio("static_fail", "res://assets/gm/sounds/soun_staticfail.wav", GameState.mastervol, false)
	_make_audio("inoffice", "res://assets/gm/sounds/soun_inoffice.wav", GameState.mastervol, false)
	_make_audio("staring", "res://assets/gm/sounds/soun_staring.wav", GameState.mastervol, true)
	_make_audio("scare_toy", "res://assets/gm/sounds/soun_scare_toy.wav", GameState.mastervol, false)
	_make_audio("scare_toyglitch", "res://assets/gm/sounds/soun_scare_toyglitch.wav", GameState.mastervol, false)
	_make_audio("scare_withered", "res://assets/gm/sounds/soun_scare_withered.wav", GameState.mastervol, false)
	_make_audio("scare_phantom", "res://assets/gm/sounds/soun_scare_phantom.wav", GameState.mastervol, false)
	_make_audio("scare_baby", "res://assets/gm/sounds/soun_scare_baby.wav", GameState.mastervol, false)
	_make_audio("mangle_in", "res://assets/gm/sounds/soun_manglein.wav", GameState.mastervol, false)
	for i in range(1, 7):
		_make_audio("walk_toy%d" % i, "res://assets/gm/sounds/soun_walk_toy%d.wav" % i, GameState.mastervol, false)
		_make_audio("walk_withered%d" % i, "res://assets/gm/sounds/soun_walk_withered%d.wav" % i, GameState.mastervol, false)
	for i in range(1, 4):
		_make_audio("walk_vent%d" % i, "res://assets/gm/sounds/soun_walk_vent%d.wav" % i, GameState.mastervol, false)
	_make_audio("bbhello", "res://assets/gm/sounds/soun_bbhello.wav", GameState.mastervol, false)
	_make_audio("bbhi", "res://assets/gm/sounds/soun_bbhi.wav", GameState.mastervol, false)
	_make_audio("bblaugh", "res://assets/gm/sounds/soun_bblaugh.wav", GameState.mastervol, false)
	_setup_phone_audio()


func _setup_phone_audio() -> void:
	if not GameState.is_story_mode():
		return
	_make_audio("phone_ringtone", "res://assets/phone_guy/ringtone.ogg", GameState.mastervol, false)
	_make_audio("phone_voice", GameState.phone_guy_monologue_path(GameState.story_night), GameState.mastervol, false)
	if audio_players.has("phone_ringtone"):
		var ringtone_player: AudioStreamPlayer = audio_players["phone_ringtone"]
		ringtone_player.finished.connect(_on_phone_ringtone_finished)
	if audio_players.has("phone_voice"):
		var voice_player: AudioStreamPlayer = audio_players["phone_voice"]
		voice_player.finished.connect(_on_phone_voice_finished)


func _make_audio(key: String, path: String, volume_percent: int, loops: bool) -> void:
	var player := AudioStreamPlayer.new()
	player.name = key
	if ResourceLoader.exists(path):
		player.stream = load(path)
	player.volume_db = GameState.volume_db(volume_percent)
	player.set_meta("loops", loops)
	player.finished.connect(_restart_audio.bind(player))
	add_child(player)
	audio_players[key] = player


func _restart_audio(player: AudioStreamPlayer) -> void:
	if is_instance_valid(player) and bool(player.get_meta("loops", false)):
		player.play()


func _play_once(key: String) -> void:
	if not audio_players.has(key):
		return
	var player: AudioStreamPlayer = audio_players[key]
	if player.stream != null:
		player.stop()
		player.play()


func _play_loop(key: String) -> void:
	if not audio_players.has(key):
		return
	var player: AudioStreamPlayer = audio_players[key]
	if player.stream == null:
		return
	player.stream_paused = false
	if not player.playing:
		player.play()


func _set_loop_gain(key: String, linear_gain: float) -> void:
	if not audio_players.has(key):
		return
	var player: AudioStreamPlayer = audio_players[key]
	if player.stream == null:
		return
	if linear_gain <= 0.0001:
		_stop_audio(key)
		return
	player.volume_db = linear_to_db(clamp(linear_gain, 0.0, 1.0))
	_play_loop(key)


func _prime_paused_loop(key: String) -> void:
	if not audio_players.has(key):
		return
	var player: AudioStreamPlayer = audio_players[key]
	if player.stream == null:
		return
	if not player.playing:
		player.play()
	player.stream_paused = true


func _pause_audio(key: String) -> void:
	if not audio_players.has(key):
		return
	var player: AudioStreamPlayer = audio_players[key]
	if player.playing:
		player.stream_paused = true


func _stop_audio(key: String) -> void:
	if not audio_players.has(key):
		return
	var player: AudioStreamPlayer = audio_players[key]
	player.stream_paused = false
	player.stop()


func _phone_player(key: String) -> AudioStreamPlayer:
	if not audio_players.has(key):
		return null
	return audio_players[key]


func _phone_call_ready() -> bool:
	var voice_player := _phone_player("phone_voice")
	return GameState.is_story_mode() and voice_player != null and voice_player.stream != null


func _update_phone_call() -> void:
	if phone_call_state != PHONE_CALL_PENDING:
		if (phone_call_state == PHONE_CALL_RINGING or phone_call_state == PHONE_CALL_TALKING) and (is_dead or is_game_over or is_night_complete):
			_stop_phone_call(false)
		return
	if DisplayServer.get_name() == "headless":
		phone_call_state = PHONE_CALL_DONE
		return
	if is_dead or is_game_over or is_night_complete:
		_stop_phone_call(false)
		return
	if scene_entry_fade_elapsed < scene_entry_fade_duration:
		return
	var ringtone_player := _phone_player("phone_ringtone")
	if ringtone_player != null and ringtone_player.stream != null:
		phone_call_state = PHONE_CALL_RINGING
		ringtone_player.stop()
		ringtone_player.play()
	else:
		_start_phone_monologue()


func _on_phone_ringtone_finished() -> void:
	if phone_call_state == PHONE_CALL_RINGING:
		_start_phone_monologue()


func _start_phone_monologue() -> void:
	var voice_player := _phone_player("phone_voice")
	if voice_player == null or voice_player.stream == null:
		phone_call_state = PHONE_CALL_DONE
		return
	phone_call_state = PHONE_CALL_TALKING
	voice_player.stop()
	voice_player.play()


func _on_phone_voice_finished() -> void:
	if phone_call_state == PHONE_CALL_TALKING:
		phone_call_state = PHONE_CALL_DONE


func _stop_phone_call(mark_muted := true) -> void:
	_stop_audio("phone_ringtone")
	_stop_audio("phone_voice")
	phone_call_state = PHONE_CALL_MUTED if mark_muted else PHONE_CALL_DONE


func _phone_call_button_visible() -> bool:
	return phone_call_state == PHONE_CALL_RINGING or phone_call_state == PHONE_CALL_TALKING


func _reset_night() -> void:
	night_time = 0.0
	if GameState.is_story_mode():
		night_goal = max(GameState.story_night_duration_seconds() * TARGET_FPS, TARGET_FPS)
	else:
		night_goal = max((360.0 + float(GameState.lvl_duration * 60)) * TARGET_FPS, TARGET_FPS)
	night_power = 0.0
	var power_capacity := float(GameState.lvl_battery + 100)
	night_limit = max((480.0 * TARGET_FPS * power_capacity) / 100.0, 1.0)
	is_power_empty = false
	if power_capacity <= 0.0:
		is_power_empty = true
	power_out_started = false
	power_out_timer = 0.0
	night_usage = 1
	night_toxic = 0.0
	night_lung = max((30.0 * TARGET_FPS) / ((float(GameState.lvl_toxic) + 3.0) / 3.0), 1.0)
	t_more_usage = 0.0
	is_mask_too_much = false
	is_night_complete = false
	night_state = STATE_OFFICE
	previous_state = STATE_OFFICE
	transition_name = ""
	current_cam = 4
	camx = CAMERA_START_X
	camera_mode = 0
	camera_goal = -1.0
	looking_at = 15
	view_scare_used = [false, false, false]
	room_details = NIGHT_AI_DATA.room_details()
	_rebuild_room_detail_lookup()
	if GameState.is_story_mode():
		ai_units = NIGHT_AI_DATA.make_units_from_levels(GameState.story_levels_for_hour(GameState.story_night, 0), true)
	else:
		ai_units = NIGHT_AI_DATA.make_units()
	ai_by_id.clear()
	for ai in ai_units:
		ai_by_id[str(ai["id"])] = ai
	view_disabled_timer = 0.0
	cctv_disabled_timer = 0.0
	cctv_disabled_source = ""
	cctv_disabled_cam = -1
	blackout_timer = 0.0
	blackout_alpha = 0.0
	scare_ready = false
	scare_unit.clear()
	scare_time = 0.0
	scare_delay = 0.0
	is_dead = false
	is_game_over = false
	jumpscare_time = 0.0
	game_over_time = 0.0
	last_killer = ""
	GameState.last_killer = ""
	GameState.last_death_context.clear()
	bb_laugh_timer = 0.0
	bb_power_debt = 0.0
	tx_anim_time = -1.0
	gf_overlay_time = -1.0
	_reset_story_director()
	_stop_audio("staring")
	story_applied_hour_index = -1
	hallucination_is_active = false
	hallucination_activity = 0
	hallucination_step_accumulator = 0.0
	hallucination_roomclock = 0
	hallucination_frame = 0
	hallucination_whole = false
	hallucination_draw_scale = 1.0
	_reset_dust_particles()
	tb_close_x = 1328.0
	tc_close_x = -624.0
	scene_change_queued = false
	phone_call_state = PHONE_CALL_PENDING if _phone_call_ready() else PHONE_CALL_OFF
	_sync_story_ai_levels(true)
	if is_power_empty:
		_start_power_out()


func _update_transition(delta: float) -> void:
	if night_state != STATE_TRANSITION:
		return
	transition_elapsed += delta
	if transition_elapsed < transition_duration:
		return
	match transition_name:
		"cctv_on":
			night_state = STATE_CCTV
			previous_state = STATE_CCTV
			camera_mode = 0
			camera_goal = -1.0
			looking_at = current_cam
			_clear_cctv_disabled(false)
			cctv_cam_transition = 0.18
			cctv_noise_alpha = 0.6
			_play_once("cctv_loading")
			_play_once("change_cam")
		"cctv_off":
			night_state = STATE_OFFICE
			previous_state = STATE_OFFICE
			camera_mode = 0
			camera_goal = -1.0
			looking_at = 15
		"mask_on":
			night_state = STATE_MASK
			previous_state = STATE_MASK
			_play_loop("breath")
		"mask_off":
			night_state = STATE_OFFICE
			previous_state = STATE_OFFICE
			_stop_audio("breath")
	transition_name = ""
	transition_elapsed = 0.0


func _start_transition(transition_key: String) -> void:
	if night_state == STATE_TRANSITION or is_night_complete:
		return
	previous_state = night_state
	night_state = STATE_TRANSITION
	transition_name = transition_key
	transition_elapsed = 0.0
	transition_duration = 0.22 if transition_key.begins_with("mask") else 0.20
	match transition_key:
		"cctv_on":
			cctv_hover_latched = true
			looking_at = -4
			_play_once("monitor_up")
			_release_flashlight()
		"cctv_off":
			cctv_hover_latched = true
			looking_at = -4
			_play_once("monitor_down")
			_clear_cctv_disabled(false)
			cctv_light_held = false
			music_box_held = false
			_stop_audio("light_buzz")
			_stop_audio("music_box")
		"mask_on":
			mask_hover_latched = true
			looking_at = -4
			_play_once("mask_on")
			_release_flashlight()
		"mask_off":
			mask_hover_latched = true
			looking_at = -4
			_play_once("mask_off")
			_stop_audio("breath")


func _update_camera(frame_scale: float) -> void:
	if night_state == STATE_CCTV:
		return
	if camera_mode == 1 and camera_goal >= 0.0:
		var goal: float = clamp(camera_goal, CAMERA_MIN_X, CAMERA_MAX_X)
		var auto_step: float = (abs(goal - camx) * 0.05 + 1.0) * frame_scale
		camx = move_toward(camx, goal, auto_step)
		if is_equal_approx(camx, goal):
			camera_goal = -1.0
	elif night_state == STATE_OFFICE or night_state == STATE_MASK:
		var mouse_x: float = _mouse_screen().x
		var turn: float = 0.0
		if mouse_x <= 600.0 or mouse_x >= VIEW_W - 600.0:
			turn = floor((abs(mouse_x - (VIEW_W * 0.5)) - 15.0) * 0.05)
			turn = clamp(turn, 0.0, 20.0)
			if mouse_x < VIEW_W * 0.5:
				turn = -turn
		camx += turn * frame_scale
	camx = clamp(camx, CAMERA_MIN_X, CAMERA_MAX_X)


func _update_inputs(_frame_scale: float) -> void:
	var mouse := _mouse_screen()
	var top_rect := _top_control_rect()
	var bottom_rect := _bottom_control_rect()
	if not bottom_rect.has_point(mouse):
		cctv_hover_latched = false
	if mouse.y > top_rect.position.y + top_rect.size.y:
		mask_hover_latched = false

	if GameState.uses_touch_controls():
		if night_state == STATE_MASK and is_mask_too_much:
			_start_transition("mask_off")
	else:
		if night_state == STATE_OFFICE and not is_power_empty:
			if bottom_rect.has_point(mouse) and not cctv_hover_latched:
				_start_transition("cctv_on")
			elif top_rect.has_point(mouse) and not mask_hover_latched and not is_mask_too_much:
				_start_transition("mask_on")
		elif night_state == STATE_CCTV:
			if bottom_rect.has_point(mouse) and not cctv_hover_latched:
				_start_transition("cctv_off")
		elif night_state == STATE_MASK:
			if (top_rect.has_point(mouse) and not mask_hover_latched) or is_mask_too_much:
				_start_transition("mask_off")

	if view_light_held:
		_update_view_hold()
	if night_state == STATE_CCTV:
		_update_cctv_hold(mouse)
	else:
		cctv_light_held = false
		music_box_held = false
		_stop_audio("music_box")


func _handle_left_pressed(screen_pos: Vector2) -> void:
	if _phone_call_button_visible() and MUTE_CALL_RECT.has_point(screen_pos):
		_stop_phone_call(true)
		return
	if GameState.uses_touch_controls() and _handle_touch_state_button(screen_pos):
		return
	if night_state == STATE_OFFICE:
		var world_pos := _screen_to_world(screen_pos)
		if HONK_WORLD_RECT.has_point(world_pos):
			_play_once("honk")
			return
		if is_power_empty:
			if _view_index_at(world_pos) != VIEW_NONE:
				_play_once("fail")
			return
		var view_index := _view_index_at(world_pos)
		if view_index != VIEW_NONE:
			_start_view_light(view_index)
	elif night_state == STATE_CCTV:
		for button in cam_buttons:
			var rect := _camera_button_rect(button)
			if rect.has_point(screen_pos):
				var next_cam := int(button["cam"])
				if next_cam != current_cam:
					current_cam = next_cam
					looking_at = current_cam
					_clear_cctv_disabled(false)
					cctv_cam_transition = 0.18
					cctv_noise_alpha = 0.6
					_play_once("cam_switch")
				return
		if _current_cam_has_light() and _camera_light_rect().has_point(screen_pos) and not is_power_empty:
			cctv_light_held = true
			_play_loop("light_buzz")
		elif GameState.mod_music and current_cam == 3 and _music_box_rect().has_point(screen_pos):
			music_box_held = true
			_play_loop("music_box")


func _handle_touch_state_button(screen_pos: Vector2) -> bool:
	var top_rect := _top_control_rect()
	var bottom_rect := _bottom_control_rect()
	if night_state == STATE_OFFICE:
		if not is_power_empty and bottom_rect.has_point(screen_pos):
			_start_transition("cctv_on")
			return true
		if not is_mask_too_much and top_rect.has_point(screen_pos):
			_start_transition("mask_on")
			return true
	elif night_state == STATE_CCTV and bottom_rect.has_point(screen_pos):
		_start_transition("cctv_off")
		return true
	elif night_state == STATE_MASK and top_rect.has_point(screen_pos):
		_start_transition("mask_off")
		return true
	return false


func _release_hold_inputs() -> void:
	_release_flashlight()
	cctv_light_held = false
	music_box_held = false
	_stop_audio("light_buzz")
	_stop_audio("music_box")


func _start_view_light(view_index: int) -> void:
	current_view = view_index
	view_light_held = true
	looking_at = int(VIEW_DRAW_DATA[view_index]["looking"])
	camera_mode = 1
	camera_goal = float(VIEW_DRAW_DATA[view_index]["camera_goal"])
	_play_loop("light_buzz")
	if not GameState.babyscare:
		_try_view_scare(view_index)


func _update_view_hold() -> void:
	if current_view == VIEW_NONE:
		_release_flashlight()
		return
	var mouse_world := _screen_to_world(_mouse_screen())
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or is_power_empty or view_disabled_timer > 0.0 or not VIEW_RECTS[current_view].has_point(mouse_world):
		_release_flashlight()


func _release_flashlight() -> void:
	if view_light_held:
		view_light_held = false
		current_view = VIEW_NONE
		looking_at = 15
		camera_mode = 0
		camera_goal = -1.0
	_stop_audio("light_buzz")


func _update_cctv_hold(mouse: Vector2) -> void:
	if cctv_light_held:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or not _camera_light_rect().has_point(mouse) or not _current_cam_has_light() or is_power_empty or cctv_disabled_timer > 0.0:
			cctv_light_held = false
			_stop_audio("light_buzz")
	if music_box_held:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or not _music_box_rect().has_point(mouse) or current_cam != 3 or not GameState.mod_music:
			music_box_held = false
			_stop_audio("music_box")


func _view_index_at(world_pos: Vector2) -> int:
	for i in range(VIEW_RECTS.size()):
		if VIEW_RECTS[i].has_point(world_pos):
			return i
	return VIEW_NONE


func _mobile_grow_rect(rect: Rect2, grow_amount: float) -> Rect2:
	if not GameState.uses_touch_controls():
		return rect
	return rect.grow(grow_amount)


func _cctv_map_scale() -> float:
	return MOBILE_CCTV_MAP_SCALE if GameState.uses_touch_controls() else 1.0


func _scale_cctv_map_pos(pos: Vector2) -> Vector2:
	var map_scale_factor := _cctv_map_scale()
	return CCTV_MAP_POS + ((pos - CCTV_MAP_POS) * map_scale_factor)


func _scale_cctv_map_rect(rect: Rect2) -> Rect2:
	var map_scale_factor := _cctv_map_scale()
	return Rect2(_scale_cctv_map_pos(rect.position), rect.size * map_scale_factor)


func _camera_button_rect(button: Dictionary) -> Rect2:
	var rect: Rect2 = button["rect"]
	return _scale_cctv_map_rect(rect)


func _camera_light_rect() -> Rect2:
	return _mobile_grow_rect(CAM_LIGHT_RECT, MOBILE_CAM_ACTION_GROW)


func _music_box_rect() -> Rect2:
	return _mobile_grow_rect(MUSIC_BOX_RECT, MOBILE_CAM_ACTION_GROW)


func _update_resources(frame_scale: float) -> void:
	if is_night_complete:
		return

	var usage_speed: float = (float(GameState.lvl_usage) + 3.0) / 3.0
	var usage_amount: float = floor((t_more_usage / (360.0 / usage_speed)) * 3.0)
	if _is_flash_active() and usage_amount < 4.0:
		t_more_usage += frame_scale * usage_speed
	elif not _is_flash_active() and t_more_usage > 0.0:
		t_more_usage = max(t_more_usage - (frame_scale / usage_speed), 0.0)
	if GameState.lvl_usage == -2:
		night_usage = 0
	else:
		var flash_usage := 1.0 if _is_flash_active() else 0.0
		night_usage = int(clamp(1.0 + flash_usage + usage_amount, 1.0, float(GameState.lvl_usage + 4)))

	if night_state == STATE_MASK and night_toxic < night_lung and GameState.lvl_toxic != -2:
		night_toxic += frame_scale * ((float(GameState.lvl_toxic) + 3.0) / 3.0)
	if night_state == STATE_MASK and night_toxic >= night_lung:
		night_toxic = 30.0 * TARGET_FPS
		is_mask_too_much = true
	if night_state != STATE_MASK and night_toxic > 0.0 and not GameState.mod_perma:
		var recovery_bonus := 1.0 if not is_mask_too_much else 0.0
		night_toxic = max(night_toxic - frame_scale * (1.0 + recovery_bonus), 0.0)
	if is_mask_too_much and night_toxic <= 0.0:
		is_mask_too_much = false

	if not GameState.mod_music:
		night_time = min(night_time + frame_scale, night_goal)
	elif music_box_held:
		night_time = min(night_time + (2.1 * frame_scale), night_goal)
	elif night_time > 0.0:
		night_time = max(night_time - (0.2 * frame_scale), 0.0)
	_sync_story_ai_levels()

	if not is_power_empty and night_power < night_limit:
		night_power += (20.0 if (GameState.lvl_usage == 2 and _is_flash_active()) else float(night_usage)) * frame_scale
	if not is_power_empty and night_power > 0.0 and night_usage < 2 and GameState.mod_auto:
		night_power = clamp(night_power - (10.0 * frame_scale), 0.0, night_limit)
	if not is_power_empty and night_power >= night_limit:
		night_power = night_limit
		_start_power_out()

	if night_time >= night_goal:
		is_night_complete = true
		_change_scene_deferred("res://scenes/night/SixAMScene.tscn")


func _start_power_out() -> void:
	if power_out_started:
		return
	is_power_empty = true
	power_out_started = true
	power_out_timer = 0.0
	_release_hold_inputs()
	_stop_audio("track")
	_stop_audio("fan")
	_stop_audio("cctv_recording")
	_stop_audio("music_box")
	_stop_audio("light_buzz")
	_stop_audio("staring")
	_stop_audio("prizecornerbg")
	_stop_audio("puppetout")
	_stop_audio("manglestatic")
	_play_once("static_fail")
	if night_state == STATE_CCTV:
		_start_transition("cctv_off")


func _current_hour_index() -> int:
	return int(clamp(floor(night_time / (night_goal / 6.0)), 0.0, 6.0))


func _reset_story_director() -> void:
	director_chaos = 0.0
	director_recovery = 0.0
	director_recent_kill_risk = 0.0
	director_state = "stable"
	director_high_risk_window = 0.0
	director_high_risk_count = 0
	director_camera_idle = 0.0
	director_view_idle = 0.0
	director_front_idle = 0.0
	director_front_flash_hold = 0.0
	director_no_error_timer = 0.0
	director_foxy_neglect_cooldown = 0.0
	director_low_power_armed = true
	director_toxic_armed = true
	director_forced_grace = 0.0


func _story_director_enabled() -> bool:
	return GameState.is_story_mode()


func _update_story_director(frame_scale: float) -> void:
	if not _story_director_enabled() or is_dead or is_game_over or is_night_complete:
		return
	director_recovery = max(director_recovery - frame_scale, 0.0)
	director_recent_kill_risk = max(director_recent_kill_risk - frame_scale, 0.0)
	director_high_risk_window = max(director_high_risk_window - frame_scale, 0.0)
	director_foxy_neglect_cooldown = max(director_foxy_neglect_cooldown - frame_scale, 0.0)
	director_forced_grace = max(director_forced_grace - frame_scale, 0.0)
	if director_high_risk_window <= 0.0:
		director_high_risk_count = 0

	if night_state == STATE_CCTV:
		director_camera_idle = 0.0
	else:
		director_camera_idle += frame_scale
	if view_light_held and current_view != VIEW_NONE:
		director_view_idle = 0.0
	else:
		director_view_idle += frame_scale
	if view_light_held and current_view == VIEW_FRONT:
		director_front_idle = 0.0
		director_front_flash_hold += frame_scale
	else:
		director_front_idle += frame_scale
		director_front_flash_hold = 0.0
	if director_front_flash_hold > DIRECTOR_FRONT_FLASH_SPAM_SECONDS * TARGET_FPS:
		t_more_usage += 0.35 * frame_scale

	if director_camera_idle >= DIRECTOR_CAMERA_IDLE_SECONDS * TARGET_FPS:
		_director_add_chaos(6.0)
		director_camera_idle = 0.0
	if director_view_idle >= DIRECTOR_VIEW_IDLE_SECONDS * TARGET_FPS:
		_director_add_chaos(6.0)
		director_view_idle = 0.0

	var power_percent := _power_percent_remaining()
	if director_low_power_armed and power_percent <= DIRECTOR_POWER_LOW_PERCENT:
		_director_add_chaos(10.0)
		director_low_power_armed = false
	elif not director_low_power_armed and power_percent > DIRECTOR_POWER_LOW_PERCENT + 15.0:
		director_low_power_armed = true

	var toxic_ratio := _toxicity_ratio()
	if director_toxic_armed and toxic_ratio >= DIRECTOR_TOXIC_HIGH_RATIO:
		_director_add_chaos(10.0)
		director_toxic_armed = false
	elif not director_toxic_armed and toxic_ratio < 0.45:
		director_toxic_armed = true

	_update_director_foxy_neglect()
	director_no_error_timer += frame_scale
	if director_no_error_timer >= DIRECTOR_NO_ERROR_SECONDS * TARGET_FPS:
		_director_add_chaos(-5.0)
		director_no_error_timer = 0.0
	_director_refresh_state()


func _update_director_foxy_neglect() -> void:
	var foxy: Dictionary = ai_by_id.get("ai_wx", {})
	if foxy.is_empty() or not bool(foxy.get("active", false)) or int(foxy.get("difficulty", 0)) <= 0:
		return
	var room_name := str(foxy.get("in", ""))
	var details := _room_detail(room_name)
	var near_front := int(floor(float(details[1]))) == 13 or room_name == "frontclose" or room_name == "frontwx" or room_name == "you"
	if near_front and director_front_idle >= DIRECTOR_FOXY_NEGLECT_SECONDS * TARGET_FPS and director_foxy_neglect_cooldown <= 0.0:
		_director_add_chaos(15.0)
		director_recent_kill_risk = max(director_recent_kill_risk, 3.0 * TARGET_FPS)
		director_foxy_neglect_cooldown = DIRECTOR_FOXY_NEGLECT_COOLDOWN_SECONDS * TARGET_FPS


func _director_add_chaos(amount: float) -> void:
	if not _story_director_enabled():
		return
	director_chaos = clamp(director_chaos + amount, 0.0, 100.0)
	if amount > 0.0:
		director_no_error_timer = 0.0
	_director_refresh_state()


func _director_start_recovery(chaos_drop: float) -> void:
	if not _story_director_enabled():
		return
	_director_add_chaos(-abs(chaos_drop))
	director_recovery = max(director_recovery, DIRECTOR_RECOVERY_SECONDS * TARGET_FPS)
	director_recent_kill_risk = 0.0
	_director_refresh_state()


func _director_now_grace_frames() -> float:
	var seconds := DIRECTOR_CHAOS_NOW_GRACE_SECONDS if director_state == "chaos" else DIRECTOR_STABLE_NOW_GRACE_SECONDS
	var frames := seconds * TARGET_FPS
	if night_state == STATE_TRANSITION:
		frames += max(transition_duration - transition_elapsed, 0.0) * TARGET_FPS
	return frames


func _director_start_forced_grace() -> void:
	if not _story_director_enabled():
		return
	director_forced_grace = max(director_forced_grace, _director_now_grace_frames())


func _director_refresh_state() -> void:
	if director_recovery > 0.0:
		director_state = "recovery"
	elif director_chaos >= DIRECTOR_CHAOS_THRESHOLD:
		director_state = "chaos"
	else:
		director_state = "stable"


func _power_percent_remaining() -> float:
	var total_power: int = max(GameState.lvl_battery + 100, 1)
	if night_limit <= 0.0:
		return 0.0
	var power_amount: float = clamp(float(total_power) - floor((night_power * float(total_power)) / night_limit), 0.0, float(total_power))
	return (100.0 * power_amount) / float(total_power)


func _toxicity_ratio() -> float:
	if night_lung <= 0.0:
		return 0.0
	return clamp(night_toxic / night_lung, 0.0, 1.0)


func _director_step_ai_delay(ai: Dictionary, frame_scale: float) -> bool:
	if not _story_director_enabled():
		return false
	var delay := float(ai.get("director_delay", 0.0))
	if delay <= 0.0:
		return false
	ai["director_delay"] = max(delay - frame_scale, 0.0)
	return true


func _director_delay_ai(ai: Dictionary, seconds: float) -> void:
	if not _story_director_enabled():
		return
	ai["director_delay"] = max(float(ai.get("director_delay", 0.0)), seconds * TARGET_FPS)


func _director_move_bonus(ai: Dictionary, details: Array) -> float:
	if not _story_director_enabled():
		return 0.0
	var ai_id := str(ai.get("id", ""))
	if ai_id == "ai_wx" and int(floor(float(details[1]))) == 13 and director_front_idle >= DIRECTOR_FOXY_NEGLECT_SECONDS * TARGET_FPS:
		return 0.35
	if ["ai_wf", "ai_wb", "ai_wc"].has(ai_id) and director_camera_idle >= DIRECTOR_CAMERA_IDLE_SECONDS * TARGET_FPS:
		return 0.25
	if director_state == "chaos" and not ["ai_tx", "ai_pp"].has(ai_id):
		return 0.10
	return 0.0


func _director_try_commit_window(ai: Dictionary, frame_scale: float, mask_down: bool) -> bool:
	if not _story_director_enabled():
		return false
	var window := _director_commit_window_frames(ai)
	if window <= 0.0:
		return false
	var room_name := str(ai.get("in", ""))
	if room_name != "office" and room_name != "officeclose":
		return false
	if str(ai.get("commit_room", "")) != room_name:
		ai["commit_room"] = room_name
		ai["commit_time"] = 0.0
		ai["commit_locked"] = false
		ai["commit_success"] = false
	if bool(ai.get("commit_locked", false)):
		return false
	ai["commit_time"] = float(ai.get("commit_time", 0.0)) + frame_scale
	var toy_scan := _director_is_toy_office_ai(ai)
	var commit_success := bool(ai.get("commit_success", false))
	if mask_down and bool(ai.get("maskable", false)):
		commit_success = true
		ai["commit_success"] = true
	if commit_success:
		_play_if_stopped("inoffice")
		if toy_scan:
			ai["staretime"] = float(ai.get("staretime", 0.0)) + frame_scale
			if float(ai["staretime"]) >= float(ai.get("starenotice", 3.0 * TARGET_FPS)) and not mask_down:
				ai["maskable"] = false
			if float(ai["staretime"]) >= _director_commit_success_visual_frames(ai, window):
				if bool(ai.get("maskable", false)) and mask_down:
					_director_deter_office_ai(ai, 8.0)
				else:
					ai["commit_locked"] = true
					ai["commit_success"] = false
					ai["maskable"] = false
					return false
			return true
		if float(ai["commit_time"]) >= _director_commit_success_visual_frames(ai, window):
			_director_deter_office_ai(ai, 8.0)
		return true
	if float(ai["commit_time"]) < window:
		_play_if_stopped("inoffice")
		return true
	ai["commit_locked"] = true
	ai["maskable"] = false
	return false


func _director_is_toy_office_ai(ai: Dictionary) -> bool:
	return ["ai_tf", "ai_tb", "ai_tc"].has(str(ai.get("id", "")))


func _director_commit_window_frames(ai: Dictionary) -> float:
	var seconds := 0.0
	match str(ai.get("id", "")):
		"ai_tf":
			seconds = 1.25
		"ai_tb":
			seconds = 0.85
		"ai_tc":
			seconds = 1.10
		"ai_bb":
			seconds = 1.00
		_:
			return 0.0
	if director_state == "chaos":
		seconds -= 0.20
	elif director_recovery > 0.0:
		seconds += 0.20
	return max(seconds, 0.25) * TARGET_FPS


func _director_commit_success_visual_frames(ai: Dictionary, window: float) -> float:
	if _director_is_toy_office_ai(ai):
		return max(window, float(ai.get("starelimit", 6.0 * TARGET_FPS)))
	var seconds := 1.0
	match str(ai.get("id", "")):
		"ai_bb":
			seconds = 1.0
	return max(window, seconds * TARGET_FPS)


func _director_deter_office_ai(ai: Dictionary, chaos_drop: float) -> void:
	var walkpath: Array = ai.get("walkpath", [])
	var back_rooms := _array_at(walkpath, 3)
	if back_rooms.is_empty():
		back_rooms = [str(ai.get("start", "none"))]
	_play_random_group(str(ai.get("detersound_group", "")))
	_set_ai_room(ai, _choose_room(back_rooms))
	ai["staretime"] = 0.0
	ai["move"] = -float(ai.get("movedelay", 0.0))
	ai["lifetime"] = 0.0
	ai["freezetime"] = 0.0
	ai["commit_success"] = false
	_director_start_recovery(chaos_drop)


func _director_on_successful_pushback(ai: Dictionary) -> void:
	if not _story_director_enabled():
		return
	match str(ai.get("id", "")):
		"ai_wx":
			_director_start_recovery(12.0)
		"ai_wf", "ai_wb", "ai_wc":
			_director_start_recovery(10.0)
		"ai_tx":
			_director_start_recovery(8.0)


func _director_should_delay_advance(ai: Dictionary, next_room: String) -> bool:
	if not _story_director_enabled():
		return false
	var ai_id := str(ai.get("id", ""))
	if ["ai_tx", "ai_pp"].has(ai_id):
		return false
	if not _director_is_high_risk_room(ai_id, next_room):
		return false
	if _director_red_combo_blocked(ai_id, next_room):
		return true
	var allowed_count := 2 if director_state == "chaos" else 1
	if director_high_risk_window > 0.0 and director_high_risk_count >= allowed_count:
		return true
	if director_recovery > 0.0:
		return true
	return false


func _director_red_combo_blocked(ai_id: String, next_room: String) -> bool:
	var foxy: Dictionary = ai_by_id.get("ai_wx", {})
	var foxy_room := str(foxy.get("in", ""))
	var foxy_kill_ready := ai_id == "ai_wx" and next_room == "you"
	foxy_kill_ready = foxy_kill_ready or foxy_room == "frontclose" or foxy_room == "you"
	if _ai_in("ai_bb", "officesp") and _power_percent_remaining() <= DIRECTOR_POWER_CRITICAL_PERCENT and foxy_kill_ready:
		return true
	return false


func _director_is_high_risk_room(ai_id: String, room_name: String) -> bool:
	if room_name == "you":
		return true
	if ["office", "officeclose", "officesp", "officetx", "frontclose", "frontwx", "ventleft", "ventright"].has(room_name):
		return true
	return ai_id == "ai_wx" and room_name == "front"


func _director_on_room_changed(ai: Dictionary, old_room: String, new_room: String) -> void:
	if not _story_director_enabled():
		return
	ai["commit_room"] = new_room
	ai["commit_time"] = 0.0
	ai["commit_locked"] = false
	ai["commit_success"] = false
	if old_room == new_room:
		return
	var ai_id := str(ai.get("id", ""))
	if _director_is_high_risk_room(ai_id, new_room):
		_director_note_high_risk_advance()
	match ai_id:
		"ai_tf", "ai_tb", "ai_tc":
			if new_room == "office" or new_room == "officeclose":
				_director_add_chaos(8.0)
				director_recent_kill_risk = max(director_recent_kill_risk, 3.0 * TARGET_FPS)
		"ai_wf", "ai_wb", "ai_wc":
			if ["frontclose", "office", "ventleft", "ventright"].has(new_room):
				_director_add_chaos(10.0)
				director_recent_kill_risk = max(director_recent_kill_risk, 3.0 * TARGET_FPS)
		"ai_bb":
			if new_room == "officesp":
				_director_add_chaos(12.0)
				director_recent_kill_risk = max(director_recent_kill_risk, 3.0 * TARGET_FPS)
		"ai_tx":
			if new_room == "officetx":
				_director_add_chaos(10.0)
			elif old_room == "officetx":
				_director_start_recovery(8.0)


func _director_note_high_risk_advance() -> void:
	if director_high_risk_window <= 0.0:
		director_high_risk_count = 0
	director_high_risk_window = max(director_high_risk_window, DIRECTOR_HIGH_RISK_WINDOW_SECONDS * TARGET_FPS)
	director_high_risk_count += 1
	director_recent_kill_risk = max(director_recent_kill_risk, 2.0 * TARGET_FPS)


func _director_scare_delay(ai: Dictionary) -> float:
	var scaretype := str(ai.get("scaretype", "now"))
	if not _story_director_enabled():
		return 0.1 * TARGET_FPS if scaretype == "now" or GameState.mod_insta else randf_range(6.0, 14.0) * TARGET_FPS
	if scaretype == "now" or GameState.mod_insta:
		return _director_now_grace_frames()
	var min_seconds := 6.0
	var max_seconds := 14.0
	if director_state == "stable":
		min_seconds = 10.0
		max_seconds = 14.0
	elif director_state == "recovery":
		min_seconds = 12.0
		max_seconds = 16.0
	elif director_state == "chaos":
		min_seconds = 6.0
		max_seconds = 10.0
	return randf_range(min_seconds, max_seconds) * TARGET_FPS


func _death_primary_reason_key(killer: String) -> String:
	match killer:
		"ai_tf":
			return "gameover_tf"
		"ai_tb":
			return "gameover_tb"
		"ai_tc":
			return "gameover_tc"
		"ai_tx":
			return "gameover_tx_him"
		"ai_wf":
			return "gameover_wf"
		"ai_wb":
			return "gameover_wb"
		"ai_wc":
			return "gameover_wc"
		"ai_wx":
			return "gameover_wx"
		"ai_pp":
			return "gameover_pp"
	return "gameover_default"


func _death_secondary_reason_key(killer: String) -> String:
	if killer == "ai_pp" and night_limit > 0.0 and bb_power_debt >= night_limit * 0.08:
		return "gameover_secondary_bb_power"
	return ""


func _store_death_context() -> void:
	var secondary_reason := _death_secondary_reason_key(last_killer)
	GameState.last_death_context = {
		"killer": last_killer,
		"director_state": director_state,
		"chaos": int(round(director_chaos)),
		"power_percent": int(round(_power_percent_remaining())),
		"toxicity_percent": int(round(_toxicity_ratio() * 100.0)),
		"primary_reason": _death_primary_reason_key(last_killer),
		"secondary_reason": secondary_reason,
	}


func _sync_story_ai_levels(force: bool = false) -> void:
	if not GameState.is_story_mode():
		return
	var hour_index := _current_hour_index()
	if not force and hour_index == story_applied_hour_index:
		return
	story_applied_hour_index = hour_index
	var fresh_units: Array = NIGHT_AI_DATA.make_units_from_levels(GameState.story_levels_for_hour(GameState.story_night, hour_index), true)
	for fresh in fresh_units:
		var ai_id := str(fresh.get("id", ""))
		if not ai_by_id.has(ai_id):
			continue
		var ai: Dictionary = ai_by_id[ai_id]
		_apply_story_ai_data(ai, fresh)


func _apply_story_ai_data(ai: Dictionary, fresh: Dictionary) -> void:
	var old_difficulty := int(ai.get("difficulty", 0))
	var new_difficulty := int(fresh.get("difficulty", 0))
	var old_room := str(ai.get("in", fresh.get("start", "none")))
	var runtime_keys := ["id", "short", "start", "in", "target", "indetails", "walkpath", "move", "freezetime", "lifetime", "staretime", "looktime", "officevisible"]
	for key in fresh.keys():
		if runtime_keys.has(str(key)):
			continue
		ai[key] = fresh[key]
	ai["difficulty"] = new_difficulty
	ai["inmax"] = new_difficulty > 10
	ai["active"] = true
	ai["story_visible_inactive"] = new_difficulty <= 0
	if new_difficulty <= 0:
		_set_ai_room(ai, str(fresh.get("start", "none")))
		ai["move"] = 0.0
		ai["freezetime"] = 0.0
		ai["lifetime"] = 0.0
		ai["staretime"] = 0.0
	elif old_difficulty <= 0:
		_set_ai_room(ai, str(fresh.get("start", "none")))
		ai["move"] = float(fresh.get("move", 0.0))
		ai["freezetime"] = 0.0
		ai["lifetime"] = 0.0
		ai["staretime"] = 0.0
	else:
		_set_ai_room(ai, old_room)


func _update_ai(frame_scale: float) -> void:
	if is_night_complete or is_dead or is_game_over:
		return
	view_disabled_timer = max(view_disabled_timer - frame_scale, 0.0)
	var was_cctv_disabled := cctv_disabled_timer > 0.0
	cctv_disabled_timer = max(cctv_disabled_timer - frame_scale, 0.0)
	if was_cctv_disabled and cctv_disabled_timer <= 0.0 and night_state == STATE_CCTV:
		cctv_disabled_source = ""
		cctv_disabled_cam = -1
		cctv_cam_transition = max(cctv_cam_transition, 0.18)
		cctv_noise_alpha = max(cctv_noise_alpha, 0.9)
	for ai in ai_units:
		_step_ai(ai, frame_scale)
	_update_special_ai(frame_scale)
	_update_blackout(frame_scale)


func _step_ai(ai: Dictionary, frame_scale: float) -> void:
	if ai.is_empty() or not bool(ai.get("active", false)):
		return
	if GameState.is_story_mode() and int(ai.get("difficulty", 0)) <= 0:
		return
	if str(ai["in"]) == "you":
		_arm_scare(ai)
		return
	if _director_step_ai_delay(ai, frame_scale):
		return
	ai["move"] = float(ai["move"]) + frame_scale
	var details: Array = _room_detail(str(ai["in"]))
	var walkpath: Array = _walk_detail(ai, str(ai["in"]))
	ai["indetails"] = details
	ai["walkpath"] = walkpath
	ai["move"] = float(ai["move"]) + (_director_move_bonus(ai, details) * frame_scale)

	var in_id := int(floor(float(details[1])))
	var room_type := str(details[2])
	var in_walk := room_type == "walk"
	var in_view := room_type == "view"
	var is_looking_at := looking_at == in_id
	var is_flashing := _is_flash_active() and is_looking_at
	var is_frozen_look := is_looking_at and bool(ai["frozen_on_view"]) and in_walk
	var is_frozen_flash := is_flashing and bool(ai["frozen_on_flash"]) and in_walk
	var is_damaging := (bool(ai["damage_on_view"]) and is_looking_at) or (bool(ai["damage_on_flash"]) and is_flashing and (view_disabled_timer + cctv_disabled_timer) <= 0.0)

	if float(ai["freezetime"]) > 0.0 and not (is_frozen_look or is_frozen_flash):
		ai["freezetime"] = max(float(ai["freezetime"]) - frame_scale, 0.0)
	if is_frozen_look or is_frozen_flash:
		ai["freezetime"] = float(ai["freezelimit"])

	if float(ai["lifetime"]) > 0.0 and not is_damaging:
		ai["lifetime"] = max(float(ai["lifetime"]) - (0.5 * frame_scale), 0.0)
	if is_damaging:
		ai["lifetime"] = float(ai["lifetime"]) + frame_scale
	if float(ai["lifelimit"]) > 0.0 and float(ai["lifetime"]) >= float(ai["lifelimit"]):
		_push_ai_back(ai, is_looking_at, in_walk, in_view)
		return

	if in_view and night_state == STATE_MASK and bool(ai["fast_on_view"]):
		ai["move"] = float(ai["move"]) + frame_scale
	if room_type == "office":
		_step_office_ai(ai, frame_scale)
		return

	var should_move := (float(ai["move"]) >= float(ai["whenwalk"]) and in_walk) or (float(ai["move"]) >= float(ai["whenview"]) and in_view)
	if should_move:
		_move_ai_forward(ai, details, walkpath, is_damaging)


func _step_office_ai(ai: Dictionary, frame_scale: float) -> void:
	if is_dead:
		return
	var mask_down := night_state == STATE_MASK
	if _director_try_commit_window(ai, frame_scale, mask_down):
		return
	var is_staring := float(ai["staretime"]) > 0.0
	var move_chance := float(ai["staretime"]) >= float(ai["starelimit"])
	var notice_chance := float(ai["staretime"]) >= float(ai["starenotice"])
	var stare_chance := bool(ai["can_stare"]) and ((bool(ai["mask_wait"]) and mask_down) or (bool(ai["office_wait"]) and _is_blindspot()) or (not bool(ai["mask_wait"]) and not bool(ai["office_wait"])))
	if is_staring or (not is_staring and stare_chance):
		ai["staretime"] = float(ai["staretime"]) + frame_scale
		is_staring = true
	if is_staring and notice_chance and not mask_down:
		ai["maskable"] = false
	if (not bool(ai["must_stare"]) and not is_staring) or move_chance:
		var walkpath: Array = ai["walkpath"]
		var forward_rooms: Array = _array_at(walkpath, 2)
		var back_rooms: Array = _array_at(walkpath, 3)
		var deterred := bool(ai["maskable"]) and mask_down
		var next_room := _choose_room(back_rooms if deterred else forward_rooms)
		if deterred:
			_play_random_group(str(ai["detersound_group"]))
		_set_ai_room(ai, next_room)
		ai["staretime"] = 0.0
		ai["move"] = -float(ai["movedelay"])
		ai["lifetime"] = 0.0
		ai["freezetime"] = 0.0
	_play_if_stopped("inoffice")


func _push_ai_back(ai: Dictionary, is_looking_at: bool, in_walk: bool, in_view: bool) -> void:
	if is_looking_at and in_view:
		view_disabled_timer = max(view_disabled_timer, 10.0)
	if is_looking_at and in_walk:
		_disable_cctv(10.0, 0.18, 0.9)
	_play_random_group(str(ai["detersound_group"]))
	_play_once("lifepush")
	var next_room := str(ai["start"])
	if bool(ai["damage_push"]):
		var walkpath: Array = ai["walkpath"]
		next_room = _choose_room(_array_at(walkpath, 3))
	_set_ai_room(ai, next_room)
	ai["move"] = -float(ai["movedelay"])
	ai["lifetime"] = 0.0
	ai["freezetime"] = 0.0
	_director_on_successful_pushback(ai)


func _move_ai_forward(ai: Dictionary, details: Array, walkpath: Array, is_damaging: bool) -> void:
	var forward_rooms: Array = _array_at(walkpath, 2)
	var next_room := _choose_room(forward_rooms)
	var next_details: Array = _room_detail(next_room)
	var next_vacancy := _room_vacancy(next_room)
	var next_full := next_vacancy >= (1 if bool(ai["loner"]) else int(next_details[3]))
	var current_full := bool(ai["loner"]) and _room_vacancy(str(ai["in"])) > 1
	var same_room := str(ai["in"]) == next_room
	var frozen := float(ai["freezetime"]) > 0.0
	var staying := float(ai["perseverance"]) <= randf() and str(details[2]) != "view"
	var looked_cam := bool(ai["no_looked_cams"]) and int(floor(float(next_details[1]))) == looking_at and str(details[2]) != "view"
	var looked_view := bool(ai["no_looked_views"]) and int(floor(float(next_details[1]))) == looking_at and str(next_details[2]) == "view"
	if next_full or current_full or same_room or frozen or staying or looked_cam or looked_view or is_damaging:
		ai["move"] = 0.0
		return
	if _director_should_delay_advance(ai, next_room):
		_director_delay_ai(ai, DIRECTOR_DELAY_SECONDS)
		ai["move"] = 0.0
		return
	var current_id := int(floor(float(details[1])))
	var next_id := int(floor(float(next_details[1])))
	var current_type := str(details[2])
	var next_type := str(next_details[2])
	if looking_at == current_id or looking_at == next_id:
		if night_state == STATE_CCTV and (current_type == "walk" or next_type == "walk") and current_cam != 5 and cctv_disabled_timer <= 0.0:
			_disable_cctv(200.0, 0.18, 0.9)
		if night_state == STATE_OFFICE and (current_type == "view" or next_type == "view"):
			view_disabled_timer = max(view_disabled_timer, 20.0)
		_play_random_group(str(ai["movesound_group"]))
	if next_room.begins_with("vent") and night_state != STATE_CCTV:
		_play_random_group("vent")
	if next_id == 13 and night_state != STATE_CCTV:
		_play_random_group(str(ai["movesound_group"]))
	_set_ai_room(ai, next_room)
	ai["freezetime"] = 0.0
	ai["lifetime"] = 0.0
	ai["move"] = 0.0


func _disable_cctv(duration: float, transition_time: float, noise_alpha: float, source := "", source_cam := -1) -> void:
	var was_disabled: bool = cctv_disabled_timer > 0.0
	if duration >= cctv_disabled_timer:
		cctv_disabled_source = source
		cctv_disabled_cam = source_cam
	cctv_disabled_timer = max(cctv_disabled_timer, duration)
	cctv_cam_transition = max(cctv_cam_transition, transition_time)
	cctv_noise_alpha = max(cctv_noise_alpha, noise_alpha)
	if night_state == STATE_CCTV and not was_disabled:
		_play_once("cam_noise")
		_play_once("static_fail")


func _clear_cctv_disabled(with_transition: bool) -> void:
	if cctv_disabled_timer <= 0.0:
		cctv_disabled_source = ""
		cctv_disabled_cam = -1
		return
	cctv_disabled_timer = 0.0
	cctv_disabled_source = ""
	cctv_disabled_cam = -1
	cctv_light_held = false
	_stop_audio("light_buzz")
	if with_transition and night_state == STATE_CCTV:
		cctv_cam_transition = max(cctv_cam_transition, 0.18)
		cctv_noise_alpha = max(cctv_noise_alpha, 0.9)


func _set_ai_room(ai: Dictionary, room_name: String) -> void:
	var old_room := str(ai.get("in", ""))
	ai["in"] = room_name
	ai["indetails"] = _room_detail(room_name)
	ai["walkpath"] = _walk_detail(ai, room_name)
	_director_on_room_changed(ai, old_room, room_name)
	if room_name == "you":
		_arm_scare(ai)


func _update_special_ai(frame_scale: float) -> void:
	if tx_anim_time >= 0.0:
		tx_anim_time += frame_scale / TARGET_FPS
		if tx_anim_time > 1.65:
			tx_anim_time = -1.0
	_update_bb(frame_scale)
	_update_gf(frame_scale)
	_update_puppet(frame_scale)
	_update_mangle(frame_scale)
	_update_ambient_ai_audio()


func _update_power_out(frame_scale: float) -> void:
	if not power_out_started or is_dead or is_night_complete:
		return
	power_out_timer += frame_scale
	var puppet: Dictionary = ai_by_id.get("ai_pp", {})
	if puppet.is_empty() or not bool(puppet.get("active", false)):
		return
	if GameState.is_story_mode() and int(puppet.get("difficulty", 0)) <= 0:
		return
	var details: Array = _room_detail(str(puppet.get("in", "")))
	if str(details[2]) == "power" and power_out_timer >= 120.0:
		_set_ai_room(puppet, "offpath")
		puppet["move"] = 0.0
	elif str(puppet.get("in", "")) == "front" and power_out_timer >= 540.0:
		_set_ai_room(puppet, "you")


func _update_night_audio_state() -> void:
	if is_dead or is_game_over or is_night_complete or is_power_empty:
		_stop_audio("cctv_recording")
		_stop_audio("prizecornerbg")
		_stop_audio("puppetout")
		_stop_audio("manglestatic")
		_stop_audio("staring")
		return
	if night_state == STATE_CCTV:
		_play_loop("cctv_recording")
	else:
		_stop_audio("cctv_recording")


func _update_bb(frame_scale: float) -> void:
	var ai: Dictionary = ai_by_id.get("ai_bb", {})
	if ai.is_empty() or not bool(ai.get("active", false)):
		return
	if GameState.is_story_mode() and int(ai.get("difficulty", 0)) <= 0:
		return
	var details: Array = _room_detail(str(ai.get("in", "")))
	var bb_cam := int(floor(float(details[1])))
	var bb_on_current_cam := night_state == STATE_CCTV and bb_cam == current_cam and str(details[2]) != "special"
	if bb_on_current_cam:
		if cctv_disabled_source != "bb" or cctv_disabled_cam != current_cam or cctv_disabled_timer <= 1000.0:
			_disable_cctv(1280.0, 0.22, 1.0, "bb", current_cam)
			_director_add_chaos(4.0)
			var cam_choices := ["bbhello", "bbhi", "bblaugh"]
			_play_once(cam_choices[randi_range(0, cam_choices.size() - 1)])
	elif cctv_disabled_source == "bb":
		_clear_cctv_disabled(true)
	if str(ai["in"]) == "officesp":
		var bb_drain: float = min(10.0 * frame_scale, max(night_limit - night_power, 0.0))
		night_power = min(night_power + bb_drain, night_limit)
		bb_power_debt = min(bb_power_debt + bb_drain, night_limit)
		bb_laugh_timer += frame_scale
		if bb_laugh_timer >= 120.0:
			bb_laugh_timer = 0.0
			_play_once("bblaugh")


func _update_ambient_ai_audio() -> void:
	var wf: Dictionary = ai_by_id.get("ai_wf", {})
	var should_play_freddy := false
	if not wf.is_empty() and bool(wf.get("active", false)):
		var details: Array = _room_detail(str(wf.get("in", "")))
		var detail_id := int(floor(float(details[1])))
		if str(wf.get("in", "")) == "frontclose" or str(wf.get("in", "")) == "office" or str(wf.get("in", "")) == str(wf.get("target", "you")):
			should_play_freddy = true
		elif night_state == STATE_CCTV and current_cam != 1 and looking_at == detail_id:
			should_play_freddy = true
	if should_play_freddy:
		_play_loop("freddy_musicbox")
	else:
		_stop_audio("freddy_musicbox")
	if _is_shake_drain_active():
		_play_loop("lifedrain")
	else:
		_stop_audio("lifedrain")
	_update_original_ambient_loops()


func _update_original_ambient_loops() -> void:
	if is_dead or is_game_over or is_night_complete or is_power_empty:
		_stop_audio("prizecornerbg")
		_stop_audio("puppetout")
		_stop_audio("manglestatic")
		return

	var puppet: Dictionary = ai_by_id.get("ai_pp", {})
	var puppet_active := not puppet.is_empty() and bool(puppet.get("active", false))
	var prize_gain := 0.0
	if puppet_active and night_state == STATE_CCTV and current_cam == 3 and not music_box_held:
		prize_gain = float(GameState.mastervol) * 0.005
	_set_loop_gain("prizecornerbg", prize_gain)

	var puppet_gain := 0.0
	if puppet_active and str(puppet.get("in", "")) == "front":
		puppet_gain = float(GameState.mastervol) * 0.01
	_set_loop_gain("puppetout", puppet_gain)

	var mangle: Dictionary = ai_by_id.get("ai_tx", {})
	var mangle_gain := 0.0
	if not mangle.is_empty() and bool(mangle.get("active", false)):
		var details: Array = _room_detail(str(mangle.get("in", "")))
		var detail_id := int(floor(float(details[1])))
		if night_state == STATE_CCTV and not cctv_light_held and looking_at == detail_id:
			mangle_gain = max(mangle_gain, float(GameState.mastervol) * 0.002)
		if str(mangle.get("in", "")) == str(mangle.get("target", "you")):
			mangle_gain = max(mangle_gain, float(GameState.mastervol) * 0.004)
	_set_loop_gain("manglestatic", mangle_gain)


func _try_view_scare(view_index: int) -> void:
	if view_index < 0 or view_index >= view_scare_used.size() or view_disabled_timer > 0.0:
		return
	var scare_overlay_indices := {
		VIEW_LEFT: [1, 2, 3],
		VIEW_FRONT: [7, 8],
		VIEW_RIGHT: [1, 2, 3],
	}
	var looking_room := int(VIEW_DRAW_DATA[view_index]["looking"])
	var found := false
	var found_bb := false
	for ai in ai_units:
		if not bool(ai.get("active", false)):
			continue
		var details: Array = _room_detail(str(ai.get("in", "")))
		if int(floor(float(details[1]))) != looking_room:
			continue
		var walkpath: Array = _walk_detail(ai, str(ai.get("in", "")))
		var overlay_index := int(floor(float(walkpath[1])))
		if scare_overlay_indices.get(view_index, []).has(overlay_index):
			found = true
			found_bb = str(ai.get("id", "")) == "ai_bb"
			break
	if found:
		if not bool(view_scare_used[view_index]):
			view_scare_used[view_index] = true
			_play_once("viewscare")
			if found_bb:
				_play_once("bbhello" if randi_range(0, 1) == 0 else "bbhi")
	else:
		view_scare_used[view_index] = false


func _is_shake_drain_active() -> bool:
	if night_state == STATE_CCTV and cctv_light_held and cctv_disabled_timer <= 0.0:
		for ai in ai_units:
			if not bool(ai.get("active", false)):
				continue
			if int(ai.get("difficulty", 0)) <= 0:
				continue
			var details: Array = _room_detail(str(ai.get("in", "")))
			if int(floor(float(details[1]))) != current_cam:
				continue
			var walkpath: Array = _walk_detail(ai, str(ai.get("in", "")))
			if cctv_shake_frames.has(int(walkpath[1])):
				return true
	if night_state != STATE_CCTV and view_light_held and current_view == VIEW_FRONT and view_disabled_timer <= 0.0:
		for ai in ai_units:
			if not bool(ai.get("active", false)):
				continue
			if int(ai.get("difficulty", 0)) <= 0:
				continue
			var details: Array = _room_detail(str(ai.get("in", "")))
			if int(floor(float(details[1]))) != 13:
				continue
			var walkpath: Array = _walk_detail(ai, str(ai.get("in", "")))
			if view_shake_frames.has(int(walkpath[1])):
				return true
	return false


func _update_gf(frame_scale: float) -> void:
	var ai: Dictionary = ai_by_id.get("ai_gf", {})
	if ai.is_empty() or not bool(ai.get("active", false)):
		return
	if GameState.is_story_mode() and int(ai.get("difficulty", 0)) <= 0:
		return
	var gf_cooldown: float = max(float(ai.get("director_gf_cooldown", 0.0)) - frame_scale, 0.0)
	ai["director_gf_cooldown"] = gf_cooldown
	if is_mask_too_much or _ai_in("ai_bb", "officesp"):
		_set_ai_room(ai, "none")
		ai["move"] = 0.0
		ai["officevisible"] = false
		return
	var details: Array = _room_detail(str(ai["in"]))
	var room_type := str(details[2])
	var staring_view := room_type == "view" and int(floor(float(details[1]))) == looking_at
	var staring_office := room_type == "special" and night_state == STATE_OFFICE and bool(ai["officevisible"])
	var staring_mask := room_type == "special" and night_state == STATE_MASK and bool(ai["officevisible"])
	if staring_view or staring_office or staring_mask:
		_set_hallucination_activity(30)
		ai["looktime"] = float(ai["looktime"]) + frame_scale
	if float(ai["looktime"]) >= float(ai["looklimit"]):
		ai["looktime"] = 0.0
		if gf_cooldown <= 0.0:
			night_toxic = 30.0 * TARGET_FPS
			is_mask_too_much = true
			view_disabled_timer = max(view_disabled_timer, 20.0)
			_start_gf_overlay()
			_play_once("scare_baby" if GameState.babyscare else "scare_phantom")
			ai["director_gf_cooldown"] = 5.0 * TARGET_FPS
			_director_add_chaos(10.0)
	if room_type == "special" and not bool(ai["officevisible"]) and transition_name == "cctv_off":
		ai["officevisible"] = true
	if room_type == "special" and bool(ai["officevisible"]) and transition_name == "cctv_on":
		_set_ai_room(ai, "none")
		ai["move"] = 0.0
		ai["officevisible"] = false
	if str(ai["in"]) == "none":
		ai["looktime"] = 0.0


func _start_gf_overlay() -> void:
	gf_overlay_time = 0.0


func _update_gf_overlay(delta: float) -> void:
	if gf_overlay_time < 0.0:
		return
	gf_overlay_time += delta
	if gf_overlay_time >= 3.0:
		gf_overlay_time = -1.0


func _update_puppet(_frame_scale: float) -> void:
	var ai: Dictionary = ai_by_id.get("ai_pp", {})
	if ai.is_empty() or not bool(ai.get("active", false)):
		return
	if GameState.is_story_mode() and int(ai.get("difficulty", 0)) <= 0:
		return
	var details: Array = _room_detail(str(ai["in"]))
	if str(details[2]) == "power" and is_power_empty:
		if GameState.mod_insta:
			_set_ai_room(ai, "you")
		elif int(elapsed) != int(elapsed - get_process_delta_time()) and randf() < 0.15:
			_set_ai_room(ai, "offpath")


func _update_mangle(_frame_scale: float) -> void:
	var ai: Dictionary = ai_by_id.get("ai_tx", {})
	if ai.is_empty() or not bool(ai.get("active", false)):
		return
	if GameState.is_story_mode() and int(ai.get("difficulty", 0)) <= 0:
		return
	var details: Array = _room_detail(str(ai["in"]))
	if str(details[2]) == "mangle" and night_state == STATE_OFFICE and not is_dead:
		tx_anim_time = 0.0
		_play_once("mangle_in")
		_play_if_stopped("inoffice")
		_set_ai_room(ai, "you")


func _update_blackout(frame_scale: float) -> void:
	var should_blackout := false
	var full_blackout := false
	for ai in ai_units:
		if not bool(ai.get("active", false)):
			continue
		var details: Array = _room_detail(str(ai["in"]))
		if _office_pressure_active(ai, details):
			should_blackout = true
			if float(ai["staretime"]) < 20.0 or float(ai["staretime"]) > (float(ai["starelimit"]) - 40.0):
				full_blackout = true
	if should_blackout:
		blackout_timer = 180.0
		blackout_alpha = 1.0 if full_blackout else randf()
	elif blackout_timer > 0.0:
		blackout_timer = max(blackout_timer - frame_scale, 0.0)
		blackout_alpha = blackout_timer / 180.0
	else:
		blackout_alpha = 0.0
	_sync_staring_audio(should_blackout)


func _office_pressure_active(ai: Dictionary, details: Array) -> bool:
	if str(details[2]) != "office":
		return false
	if float(ai.get("staretime", 0.0)) > 0.0:
		return true
	return _director_office_commit_visual_active(ai)


func _director_office_commit_visual_active(ai: Dictionary) -> bool:
	if not _story_director_enabled():
		return false
	if not ["ai_tf", "ai_tb", "ai_tc", "ai_bb"].has(str(ai.get("id", ""))):
		return false
	var room_name := str(ai.get("in", ""))
	if room_name != "office" and room_name != "officeclose":
		return false
	return float(ai.get("commit_time", 0.0)) > 0.0 and not bool(ai.get("commit_locked", false))


func _sync_staring_audio(should_blackout: bool) -> void:
	if should_blackout and night_state != STATE_CCTV and not is_dead and not is_game_over and not is_night_complete:
		_play_loop("staring")
	else:
		_stop_audio("staring")


func _update_scare(frame_scale: float) -> void:
	if not scare_ready or scare_unit.is_empty() or is_dead:
		return
	var scaretype := str(scare_unit.get("scaretype", "now"))
	scare_time += frame_scale
	var trigger := false
	if scaretype == "now":
		if _story_director_enabled():
			trigger = scare_time >= scare_delay and director_forced_grace <= 0.0 and (night_state == STATE_OFFICE or _is_blindspot() or GameState.mod_insta)
		else:
			trigger = night_state == STATE_OFFICE or _is_blindspot() or GameState.mod_insta
	elif scare_time >= scare_delay:
		if _story_director_enabled() and director_forced_grace > 0.0:
			return
		if night_state == STATE_CCTV:
			_start_transition("cctv_off")
			_director_start_forced_grace()
			return
		elif night_state == STATE_MASK:
			_start_transition("mask_off")
			_director_start_forced_grace()
			return
		trigger = night_state == STATE_OFFICE or _is_blindspot()
	if trigger:
		_trigger_jumpscare()


func _arm_scare(ai: Dictionary) -> void:
	if scare_ready or is_dead or is_game_over:
		return
	scare_ready = true
	scare_unit = ai
	scare_time = 0.0
	scare_delay = _director_scare_delay(ai)
	if _story_director_enabled():
		director_recent_kill_risk = max(director_recent_kill_risk, 4.0 * TARGET_FPS)


func _trigger_jumpscare() -> void:
	if scare_unit.is_empty():
		return
	is_dead = true
	jumpscare_time = 0.0
	last_killer = str(scare_unit.get("id", ""))
	GameState.last_killer = last_killer
	_store_death_context()
	_release_hold_inputs()
	_stop_audio("track")
	_stop_audio("fan")
	_stop_audio("breath")
	_stop_audio("cctv_recording")
	_stop_audio("freddy_musicbox")
	_stop_audio("lifedrain")
	_stop_audio("hallucination")
	_stop_audio("staring")
	_stop_audio("prizecornerbg")
	_stop_audio("puppetout")
	_stop_audio("manglestatic")
	_play_once(str(scare_unit.get("scaresound", "scare_toy")))


func _update_jumpscare(delta: float, _frame_scale: float) -> void:
	jumpscare_time += delta
	if jumpscare_time >= 1.1:
		_change_scene_deferred("res://scenes/night/GameOverScene.tscn")


func _change_scene_deferred(path: String) -> void:
	if scene_change_queued:
		return
	scene_change_queued = true
	call_deferred("_change_scene_now", path)


func _change_scene_now(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _rebuild_room_detail_lookup() -> void:
	room_detail_by_name.clear()
	for room in room_details:
		room_detail_by_name[str(room[0])] = room


func _room_detail(room_name: String) -> Array:
	return room_detail_by_name.get(room_name, EMPTY_ROOM_DETAIL)


func _walk_detail(ai: Dictionary, room_name: String) -> Array:
	var walkmap: Array = ai.get("walkmap", [])
	for path in walkmap:
		if str(path[0]) == room_name:
			return path
	return ["empty", 0, [str(ai.get("start", "none"))], [str(ai.get("start", "none"))]]


func _room_vacancy(room_name: String) -> int:
	var vacancy := 0
	for ai in ai_units:
		if bool(ai.get("active", false)) and str(ai.get("in", "")) == room_name:
			vacancy += 1
	return vacancy


func _choose_room(rooms: Array) -> String:
	if rooms.is_empty():
		return "none"
	return str(rooms[randi_range(0, rooms.size() - 1)])


func _array_at(source: Array, index: int) -> Array:
	if source.size() <= index or not (source[index] is Array):
		return []
	return source[index]


func _ai_in(ai_id: String, room_name: String) -> bool:
	if not ai_by_id.has(ai_id):
		return false
	var ai: Dictionary = ai_by_id[ai_id]
	return bool(ai.get("active", false)) and str(ai.get("in", "")) == room_name


func _play_random_group(group_name: String) -> void:
	match group_name:
		"toy":
			_play_once("walk_toy%d" % randi_range(1, 6))
		"withered":
			_play_once("walk_withered%d" % randi_range(1, 6))
		"vent":
			_play_once("walk_vent%d" % randi_range(1, 3))
		"bb":
			var choices := ["bblaugh", "bbhi", "bbhello"]
			_play_once(choices[randi_range(0, choices.size() - 1)])


func _play_if_stopped(key: String) -> void:
	if not audio_players.has(key):
		return
	var player: AudioStreamPlayer = audio_players[key]
	if player.stream != null and not player.playing:
		player.play()


func _is_blindspot() -> bool:
	if night_state != STATE_TRANSITION:
		return false
	var progress: float = transition_elapsed / max(transition_duration, 0.001)
	if transition_name == "cctv_off":
		return progress > 0.70
	if transition_name == "mask_on":
		return progress > 0.45
	if transition_name == "mask_off":
		return progress > 0.75
	return false


func _update_mask(frame_scale: float) -> void:
	if night_state != STATE_MASK:
		return
	if mask_y_direction != 1.0 and mask_yoffset <= -1.0:
		mask_y_direction = 1.0
		mask_y_acceleration = 0.0
	if mask_y_direction != -1.0 and mask_yoffset >= 2.0:
		mask_y_direction = -1.0
		mask_y_acceleration = 0.0
	mask_y_speed += (0.001 + mask_y_acceleration) * mask_y_direction * frame_scale
	mask_y_speed = clamp(mask_y_speed, -1.0, 1.0)
	mask_yoffset += mask_y_speed * frame_scale
	if randf() < 0.4 and mask_y_acceleration < 2.0:
		mask_y_acceleration += 0.006 * frame_scale


func _reset_dust_particles() -> void:
	dust_particles.clear()
	if not GameState.particles_enabled() or dust_texture == null:
		return
	for i in range(10):
		_spawn_dust_particle()


func _spawn_dust_particle() -> void:
	var spawn_pos := DUST_SPAWN_POSITION + Vector2(randf() * DUST_SPAWN_SIZE.x, randf() * DUST_SPAWN_SIZE.y)
	dust_particles.append({
		"xbase": spawn_pos.x,
		"x": spawn_pos.x,
		"y": spawn_pos.y,
		"xarc": float(randi_range(3, 10)),
		"movespeedy": 0.02 + randf() * 0.5,
		"movespeedx": float(randi_range(25, 50)),
		"length": 0.0,
		"length_target": float(randi_range(6, 16)) * TARGET_FPS,
		"size": 0.2 + randf() * 0.5,
		"alpha_target": 0.05 + randf() * 0.6,
		"alpha": 0.0,
	})


func _update_dust(frame_scale: float) -> void:
	if not GameState.particles_enabled() or dust_texture == null:
		dust_particles.clear()
		return
	if dust_particles.is_empty():
		_reset_dust_particles()
	if randf() < frame_scale / 41.0:
		_spawn_dust_particle()
	for i in range(dust_particles.size() - 1, -1, -1):
		var particle: Dictionary = dust_particles[i]
		var length := float(particle["length"]) + frame_scale
		var length_target := float(particle["length_target"])
		if length > length_target:
			dust_particles.remove_at(i)
			continue
		particle["length"] = length
		particle["x"] = float(particle["xbase"]) + sin(length / float(particle["movespeedx"])) * float(particle["xarc"])
		particle["y"] = float(particle["y"]) + float(particle["movespeedy"]) * frame_scale
		var alpha_target := float(particle["alpha_target"])
		particle["alpha"] = alpha_target - clampf(abs(length - length_target * 0.5) / 400.0, 0.0, alpha_target)
		dust_particles[i] = particle


func _update_close_office_anims(frame_scale: float) -> void:
	var target_center := VIEW_W * 0.5
	var tb: Dictionary = ai_by_id.get("ai_tb", {})
	var tb_should_move := _should_close_anim_advance(tb)
	tb_close_x = _close_anim_next_x(tb_close_x, target_center, 1328.0, tb_should_move, frame_scale)
	var tc: Dictionary = ai_by_id.get("ai_tc", {})
	var tc_should_move := _should_close_anim_advance(tc)
	tc_close_x = _close_anim_next_x(tc_close_x, target_center - 650.0, -624.0, tc_should_move, frame_scale)


func _should_close_anim_advance(ai: Dictionary) -> bool:
	if ai.is_empty() or not bool(ai.get("active", false)):
		return false
	if str(ai.get("in", "")) != "officeclose":
		return false
	if blackout_alpha > 0.0 and float(ai.get("staretime", 0.0)) > 0.0:
		return true
	return _director_close_commit_visual_active(ai)


func _director_close_commit_visual_active(ai: Dictionary) -> bool:
	if not _story_director_enabled():
		return false
	if not ["ai_tb", "ai_tc"].has(str(ai.get("id", ""))):
		return false
	return float(ai.get("commit_time", 0.0)) > 0.0 and not bool(ai.get("commit_locked", false))


func _close_anim_next_x(current_x: float, target_x: float, start_x: float, should_move: bool, frame_scale: float) -> float:
	if not should_move:
		return move_toward(current_x, start_x, 24.0 * frame_scale)
	var distance: float = abs(target_x - current_x)
	var step_amount: float = clamp(distance * 0.015, 0.0, 4.0) * frame_scale
	return move_toward(current_x, target_x, step_amount)


func _update_hallucination(frame_scale: float) -> void:
	if hallucination_frames.is_empty() or is_game_over or is_night_complete:
		_pause_audio("hallucination")
		return
	hallucination_step_accumulator += frame_scale
	var step_count := int(floor(hallucination_step_accumulator))
	if step_count <= 0:
		_sync_hallucination_audio()
		return
	hallucination_step_accumulator -= float(step_count)
	for _i in range(step_count):
		_step_hallucination()


func _step_hallucination() -> void:
	hallucination_roomclock += 1
	hallucination_is_active = hallucination_activity > 0
	if hallucination_is_active:
		hallucination_activity -= 1
		if randf() < HALLUCINATION_CHANCE_CHANGE:
			_randomize_hallucination_frame()
	_sync_hallucination_audio()
	_step_hallucination_triggers()


func _step_hallucination_triggers() -> void:
	if is_dead:
		hallucination_activity = 0
		hallucination_is_active = false
		return
	var hour_interval := maxi(int(floor(night_goal / 6.0)), 1)
	if hallucination_roomclock % hour_interval == 0 and randf() < HALLUCINATION_CHANCE_RANDOM:
		_set_hallucination_activity(120)
	var second_interval := int(TARGET_FPS)
	if hallucination_roomclock % second_interval != 0:
		return
	var toxic_ratio: float = clamp(night_toxic / night_lung, 0.0, 1.0) if night_lung > 0.0 else 0.0
	if not GameState.mod_perma and (randf() + 0.1) < (toxic_ratio * 0.2):
		_set_hallucination_activity(60)
	if is_mask_too_much and randf() < 0.1:
		_set_hallucination_activity(60)


func _set_hallucination_activity(frame_count: int) -> void:
	if hallucination_frames.is_empty() or is_dead or is_game_over or is_night_complete:
		return
	hallucination_activity = maxi(frame_count, 0)


func _randomize_hallucination_frame() -> void:
	var image_amount := hallucination_frames.size()
	if image_amount <= 0:
		return
	var normal_max := maxi(image_amount - 2, 0)
	hallucination_frame = randi_range(0, normal_max)
	if randf() < HALLUCINATION_CHANCE_PALCHOP:
		hallucination_frame = image_amount - 1
	if randf() < HALLUCINATION_CHANCE_EMPTY:
		hallucination_frame = 0
	hallucination_whole = randf() < HALLUCINATION_CHANCE_WHOLE
	hallucination_draw_scale = 1.0 + randf() * 0.3


func _sync_hallucination_audio() -> void:
	if hallucination_is_active and not is_dead and not GameState.babyscare:
		_play_loop("hallucination")
	else:
		_pause_audio("hallucination")


func _update_cctv(frame_scale: float) -> void:
	var mouse := _mouse_screen()
	var map_target := 1.0 if mouse.x > 760.0 and mouse.y > 330.0 else 0.2
	cctv_map_alpha = move_toward(cctv_map_alpha, map_target, 0.08 * frame_scale)
	cctv_cam_transition = max(cctv_cam_transition - (frame_scale / TARGET_FPS), 0.0)
	if randf() < 0.03 * frame_scale:
		cctv_noise_target = 0.1 + randf() * 0.2
	cctv_noise_alpha = move_toward(cctv_noise_alpha, cctv_noise_target, 0.01 * frame_scale)


func _update_fog(frame_scale: float) -> void:
	if randf() < 0.03 * frame_scale:
		fog_soft_target = fog_hard_target - randf() * fog_variance
	fog_alpha = move_toward(fog_alpha, fog_soft_target, 0.002 * frame_scale)


func _draw_world_layer() -> void:
	if is_game_over:
		_canvas().draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), COLOR_BLACK, true)
		return
	if night_state == STATE_CCTV:
		_draw_cctv_screen()
	else:
		_draw_office_world()


func _draw_office_world() -> void:
	if office_texture != null:
		_draw_world_texture(office_texture, Vector2.ZERO, Vector2.ONE, COLOR_WHITE)
	_draw_inoffice_ai()
	if view_light_held and current_view != VIEW_NONE:
		_draw_view_light_world()


func _draw_dust_layer() -> void:
	if is_game_over or is_dead or night_state == STATE_CCTV or not GameState.particles_enabled() or dust_texture == null:
		return
	for particle in dust_particles:
		var particle_scale := Vector2.ONE * float(particle["size"])
		var draw_size := dust_texture.get_size() * particle_scale
		var screen_pos := Vector2(float(particle["x"]), float(particle["y"])) - Vector2(camx, CAMERA_Y) - draw_size * 0.5
		_canvas().draw_texture_rect(dust_texture, Rect2(screen_pos, draw_size), false, Color(1.0, 1.0, 1.0, float(particle["alpha"])))


func _draw_desk_layer() -> void:
	if is_game_over or is_dead or night_state == STATE_CCTV:
		return
	_draw_desk_world()


func _draw_close_layer() -> void:
	if is_game_over or is_dead or night_state == STATE_CCTV:
		return
	_draw_close_office_anims()


func _draw_desk_world() -> void:
	_draw_world_texture(table_texture, Vector2(643.0, 531.0), Vector2.ONE, COLOR_WHITE)
	if not fan_frames.is_empty():
		var fan_index: int = int(floor(elapsed * 30.0)) % fan_frames.size()
		_draw_world_texture(fan_frames[fan_index], Vector2(1055.0, 379.0), Vector2.ONE, COLOR_WHITE)


func _draw_view_light_world() -> void:
	var data: Dictionary = VIEW_DRAW_DATA[current_view]
	var frames: Array = view_frames.get(str(data["frames"]), [])
	if not frames.is_empty():
		_draw_world_texture(frames[0], data["draw_pos"], Vector2.ONE, COLOR_WHITE)
	for ai in ai_units:
		if not bool(ai.get("active", false)):
			continue
		var details: Array = _room_detail(str(ai.get("in", "")))
		if int(floor(float(details[1]))) != looking_at:
			continue
		var walkpath: Array = _walk_detail(ai, str(ai.get("in", "")))
		var overlay_index := int(walkpath[1])
		if overlay_index > 0 and overlay_index < frames.size():
			_draw_world_texture(frames[overlay_index], data["draw_pos"], Vector2.ONE, COLOR_WHITE)
		if current_view == VIEW_FRONT and view_shake_frames.has(overlay_index):
			var shake_frames: Array = view_shake_frames[overlay_index]
			if not shake_frames.is_empty():
				var shake_index := randi_range(0, shake_frames.size() - 1)
				var origin: Vector2 = view_shake_origins.get(overlay_index, Vector2.ZERO)
				var screen_pos := Vector2(-origin.x, -origin.y) - Vector2(camx, CAMERA_Y)
				_canvas().draw_texture(shake_frames[shake_index], screen_pos)


func _draw_light_layer() -> void:
	if is_game_over or is_dead or night_state == STATE_CCTV:
		return
	if lamp_texture != null and not is_power_empty:
		_draw_world_texture(lamp_texture, Vector2.ZERO, Vector2(2.0, 2.0), Color(COLOR_LAMP.r, COLOR_LAMP.g, COLOR_LAMP.b, fog_alpha))
	if view_light_held and current_view != VIEW_NONE and not is_power_empty:
		var data: Dictionary = VIEW_DRAW_DATA[current_view]
		var flash_texture := _flash_texture_for(str(data["flash"]))
		_draw_world_texture(flash_texture, data["flash_pos"], Vector2(2.0, 2.0), COLOR_WHITE)


func _draw_ui_layer() -> void:
	if is_game_over:
		return
	if night_state == STATE_TRANSITION:
		_draw_transition_overlay()
	_draw_status_ui()
	if night_state == STATE_OFFICE:
		_draw_office_buttons()
	elif night_state == STATE_CCTV:
		_draw_cctv_lower_button()
	elif night_state == STATE_MASK:
		_draw_mask_button()
	_draw_beta_notice()
	if is_night_complete:
		_canvas().draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), Color(0.0, 0.0, 0.0, 0.55), true)
		_draw_text("pixelmixbold", Vector2(VIEW_W * 0.5, 320.0), "6 AM", COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(4.0, 4.0))
	if blackout_alpha > 0.0 and night_state != STATE_CCTV:
		_canvas().draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), Color(0.0, 0.0, 0.0, clamp(blackout_alpha, 0.0, 1.0)), true)
	if is_dead:
		_draw_jumpscare()
	_draw_scene_entry_fade()


func _draw_gf_layer() -> void:
	if is_game_over or gf_overlay_time < 0.0:
		return
	_draw_gf_overlay()


func _draw_mask_layer() -> void:
	if is_game_over:
		return
	if night_state == STATE_MASK:
		_draw_mask_overlay()
	if night_state != STATE_CCTV:
		_draw_toxicity_overlay()


func _draw_transition_overlay() -> void:
	var progress: float = clamp(transition_elapsed / transition_duration, 0.0, 1.0)
	match transition_name:
		"cctv_on":
			_draw_flip_frames(flippanel_frames, progress, false)
		"cctv_off":
			_draw_flip_frames(flippanel_frames, progress, true)
		"mask_on":
			_draw_flip_frames(flipmask_frames, progress, false)
		"mask_off":
			_draw_flip_frames(flipmask_frames, progress, true)


func _draw_flip_frames(frames: Array[Texture2D], progress: float, reversed: bool) -> void:
	if frames.is_empty():
		return
	var frame_float := progress * float(frames.size() - 1)
	var frame_index := int(floor(frame_float))
	if reversed:
		frame_index = (frames.size() - 1) - frame_index
	frame_index = clamp(frame_index, 0, frames.size() - 1)
	_canvas().draw_texture_rect(frames[frame_index], Rect2(0.0, 0.0, VIEW_W, VIEW_H), false, COLOR_WHITE)


func _bb_power_hud_alert() -> bool:
	return _story_director_enabled() and bb_power_debt > 0.0 and _ai_in("ai_bb", "officesp")


func _bb_power_hud_jitter() -> Vector2:
	if not _bb_power_hud_alert():
		return Vector2.ZERO
	var intensity: float = clamp(bb_power_debt / max(night_limit * 0.08, 1.0), 0.0, 1.0)
	if int(floor(elapsed * 18.0)) % 2 != 0:
		return Vector2.ZERO
	return Vector2(randf_range(-2.0, 2.0) * intensity, randf_range(-1.0, 1.0) * intensity)


func _draw_status_ui() -> void:
	var time_index := _current_hour_index()
	var time_text: String = time_names[time_index]
	_draw_text("pixelmix", Vector2(1240.0, 40.0), GameState.story_night_title() + "\n" + time_text, COLOR_WHITE, 1.0, HALIGN_RIGHT, VALIGN_TOP, Vector2(1.5, 1.5))
	_draw_phone_call_button()
	if is_power_empty:
		if int(elapsed) % 2 == 0:
			_draw_screen_texture(flash_icon_texture, Vector2(40.0, 64.0), Vector2(3.0, 3.0), COLOR_WHITE)
		return

	var total_power: int = max(GameState.lvl_battery + 100, 1)
	var power_amount := int(clamp(float(total_power) - floor((night_power * float(total_power)) / night_limit), 0.0, float(total_power)))
	var power_percent: float = (100.0 * float(power_amount)) / float(total_power)
	var bar_color := COLOR_WHITE
	if power_amount < 50:
		bar_color = COLOR_YELLOW
	if power_amount < 25:
		bar_color = COLOR_RED
	var hud_jitter := _bb_power_hud_jitter()
	var power_text_color := COLOR_WHITE
	if _bb_power_hud_alert():
		power_text_color = Color(1.0, 0.82, 0.82, 1.0)
		bar_color = bar_color.lerp(COLOR_RED, 0.25)
	_draw_text("pixelmix", Vector2(41.0, 40.0) + hud_jitter, GameState.t("power") + ": " + str(power_amount) + "%", power_text_color, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE)
	_draw_screen_texture(flash_icon_texture, Vector2(40.0, 64.0) + hud_jitter, Vector2(3.0, 3.0), COLOR_WHITE)
	_draw_healthbar(Rect2(Vector2(45.0, 69.0) + hud_jitter, Vector2(103.0, 37.0)), power_percent, bar_color)
	_draw_text("pixelmix", Vector2(41.0, 120.0), GameState.t("usage") + ":", COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE)
	for i in range(min(night_usage, 3)):
		var usage_color := COLOR_WHITE
		if i > 0:
			usage_color = COLOR_YELLOW
		if i > 1:
			usage_color = COLOR_RED
		_canvas().draw_circle(Vector2(116.0 + float(i * 18), 128.0), 6.0, usage_color)
	_draw_toxicity_scale()


func _draw_phone_call_button() -> void:
	if not _phone_call_button_visible():
		return
	var hovered := MUTE_CALL_RECT.has_point(_mouse_screen())
	var fill_color := Color(0.0, 0.0, 0.0, 0.22)
	if hovered:
		fill_color = Color(COLOR_CAM_HOVER.r, COLOR_CAM_HOVER.g, COLOR_CAM_HOVER.b, 0.35)
	_canvas().draw_rect(MUTE_CALL_RECT, fill_color, true)
	_canvas().draw_rect(MUTE_CALL_RECT, Color(1.0, 1.0, 1.0, 0.45), false, 1.0)
	_draw_text("pixelmixbold", MUTE_CALL_RECT.position + Vector2(MUTE_CALL_RECT.size.x * 0.5, 7.0), GameState.t("mute_call_short"), Color(1.0, 1.0, 1.0, 0.72), 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(0.75, 0.75))


func _draw_toxicity_scale() -> void:
	if not GameState.toxicity_scale or GameState.lvl_toxic == -2 or night_lung <= 0.0:
		return
	var toxic_ratio: float = clamp(night_toxic / night_lung, 0.0, 1.0)
	var toxic_color := COLOR_WHITE
	if toxic_ratio > 0.50:
		toxic_color = COLOR_YELLOW
	if toxic_ratio > 0.80:
		toxic_color = COLOR_RED
	_draw_text("pixelmix", Vector2(41.0, 150.0), GameState.t("toxicity") + ":", COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE)
	_draw_healthbar(Rect2(45.0, 174.0, 103.0, 16.0), toxic_ratio * 100.0, toxic_color)


func _draw_healthbar(rect: Rect2, power_percent: float, fill_color: Color) -> void:
	_canvas().draw_rect(rect, COLOR_BLACK, true)
	var fill_w: float = rect.size.x * clamp(power_percent / 100.0, 0.0, 1.0)
	_canvas().draw_rect(Rect2(rect.position, Vector2(fill_w, rect.size.y)), fill_color, true)
	for i in range(3):
		var border_rect := Rect2(rect.position - Vector2(float(i), float(i)), rect.size + Vector2(float(i * 2), float(i * 2)))
		_canvas().draw_rect(border_rect, COLOR_WHITE, false, 1.0)


func _draw_office_buttons() -> void:
	var button_scale := MOBILE_BUTTON_SCALE if GameState.uses_touch_controls() else Vector2.ONE
	var cam_pos := _control_button_position(button_cam_texture, Vector2(384.0, 664.0), button_scale, false)
	var mask_pos := _control_button_position(button_mask_texture, Vector2(384.0, 16.0), button_scale, true)
	var control_alpha := 0.78 if GameState.uses_touch_controls() else _hover_alpha(Vector2(VIEW_W * 0.5, VIEW_H))
	var mask_alpha := 0.78 if GameState.uses_touch_controls() else _hover_alpha(Vector2(VIEW_W * 0.5, 0.0))
	if not is_power_empty:
		_draw_screen_texture(button_cam_texture, cam_pos, button_scale, Color(1.0, 1.0, 1.0, control_alpha))
	if not is_mask_too_much:
		_draw_screen_texture(button_mask_texture, mask_pos, button_scale, Color(1.0, 1.0, 1.0, mask_alpha))
	elif int(elapsed * 2.0) % 2 == 0:
		_draw_screen_texture(button_mask_texture, mask_pos, button_scale, Color(1.0, 1.0, 1.0, 0.5))


func _draw_cctv_lower_button() -> void:
	var button_scale := MOBILE_BUTTON_SCALE if GameState.uses_touch_controls() else Vector2.ONE
	var base_pos := Vector2(384.0, 664.0) if GameState.uses_touch_controls() else Vector2(262.0, 664.0)
	var draw_pos := _control_button_position(button_cam_texture, base_pos, button_scale, false)
	var control_alpha := 0.78 if GameState.uses_touch_controls() else _hover_alpha(Vector2((VIEW_W * 0.5) - 241.0, VIEW_H))
	_draw_screen_texture(button_cam_texture, draw_pos, button_scale, Color(1.0, 1.0, 1.0, control_alpha))


func _draw_mask_button() -> void:
	var button_scale := MOBILE_BUTTON_SCALE if GameState.uses_touch_controls() else Vector2.ONE
	var draw_pos := _control_button_position(button_mask_texture, Vector2(384.0, 16.0), button_scale, true)
	var control_alpha := 0.78 if GameState.uses_touch_controls() else _hover_alpha(Vector2(VIEW_W * 0.5, 0.0))
	_draw_screen_texture(button_mask_texture, draw_pos, button_scale, Color(1.0, 1.0, 1.0, control_alpha))


func _draw_mask_overlay() -> void:
	if mask_overlay_texture != null:
		var toxic_ratio: float = clamp(night_toxic / night_lung, 0.0, 1.0)
		var jitter: float = toxic_ratio * 4.0 if toxic_ratio > 0.7 else 0.0
		var draw_x: float = -113.0 + randf_range(-jitter, jitter)
		var draw_y: float = -180.0 + mask_yoffset
		_draw_screen_texture(mask_overlay_texture, Vector2(draw_x, draw_y), Vector2.ONE, COLOR_WHITE)


func _draw_toxicity_overlay() -> void:
	if toxicity_texture != null and night_toxic > 0.0:
		var toxic_ratio: float = clamp(night_toxic / night_lung, 0.0, 1.0)
		var toxic_scale: float = 0.05 + clamp(2.0 - toxic_ratio, 1.0, 2.0)
		var alpha_limit: float = 0.5 if GameState.mod_perma else 1.0
		_draw_screen_texture_centered(toxicity_texture, Vector2(640.0, 360.0), Vector2(toxic_scale, toxic_scale), Color(1.0, 1.0, 1.0, clamp(toxic_ratio, 0.0, alpha_limit)))


func _update_scene_entry_fade(delta: float) -> void:
	if scene_entry_fade_duration <= 0.0:
		return
	scene_entry_fade_elapsed = min(scene_entry_fade_elapsed + delta, scene_entry_fade_duration)
	if scene_entry_fade_elapsed >= scene_entry_fade_duration:
		scene_entry_fade_duration = 0.0


func _draw_scene_entry_fade() -> void:
	if scene_entry_fade_duration <= 0.0:
		return
	var alpha := 1.0 - clampf(scene_entry_fade_elapsed / scene_entry_fade_duration, 0.0, 1.0)
	_canvas().draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), Color(0.0, 0.0, 0.0, alpha), true)


func _draw_hallucination_layer(additive: bool) -> void:
	if not hallucination_is_active or hallucination_frames.is_empty() or is_dead or is_game_over or is_night_complete:
		return
	if additive == hallucination_whole:
		return
	var texture: Texture2D = hallucination_frames[clampi(hallucination_frame, 0, hallucination_frames.size() - 1)]
	var draw_scale := Vector2(hallucination_draw_scale, hallucination_draw_scale)
	var hallucination_rotation := float(randi_range(0, 1) - randi_range(0, 1))
	_draw_screen_texture_centered_rotated(texture, Vector2(VIEW_W * 0.5, VIEW_H * 0.5), draw_scale, deg_to_rad(hallucination_rotation), COLOR_WHITE)


func _draw_beta_notice() -> void:
	if beta_notice_texture == null or GameState.hiderewards:
		return
	var notice_alpha := 0.10 if int(elapsed) % 2 == 0 else 0.07
	_draw_screen_texture(beta_notice_texture, Vector2(920.0, 520.0), Vector2(0.5, 0.5), Color(1.0, 1.0, 1.0, notice_alpha))


func _draw_cctv_screen() -> void:
	var section_start := 0
	_canvas().draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), COLOR_BLACK, true)
	var cctv_disabled := cctv_disabled_timer > 0.0
	if perf_profile_enabled:
		section_start = _perf_tick()
	if current_cam != 5 and current_cam < cctv_bg_frames.size() and not cctv_disabled:
		var bg_texture: Texture2D = cctv_bg_frames[current_cam]
		var source_y := 720.0 if cctv_light_held else 0.0
		_canvas().draw_texture_rect_region(bg_texture, Rect2(0.0, 0.0, VIEW_W, VIEW_H), Rect2(0.0, source_y, 1280.0, 720.0), COLOR_WHITE)
		_draw_cctv_ai_overlays(source_y)
	if perf_profile_enabled:
		_perf_end("draw.cctv.bg_overlays", section_start)
		section_start = _perf_tick()
	if cctv_noise_frames.size() > 0:
		var noise_index := int(floor(elapsed * 30.0)) % cctv_noise_frames.size()
		_canvas().draw_texture_rect(cctv_noise_frames[noise_index], Rect2(0.0, 0.0, VIEW_W, VIEW_H), false, Color(1.0, 1.0, 1.0, cctv_noise_alpha))
	if cctv_lines_texture != null:
		_canvas().draw_texture_rect(cctv_lines_texture, Rect2(0.0, 0.0, VIEW_W, VIEW_H), false, Color(1.0, 1.0, 1.0, 0.5))
	if perf_profile_enabled:
		_perf_end("draw.cctv.noise_lines", section_start)
		section_start = _perf_tick()
	if current_cam == 5 or cctv_disabled:
		_draw_text("pixelmix", Vector2(VIEW_W * 0.5, 150.0), GameState.t("camera_disabled"), COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(2.0, 2.0))
	if cctv_cam_transition > 0.0:
		_draw_cctv_transition_noise()
	if perf_profile_enabled:
		_perf_end("draw.cctv.disabled_transition", section_start)
		section_start = _perf_tick()
	_draw_cctv_border()
	_draw_cctv_clock()
	_draw_cctv_indicators()
	if perf_profile_enabled:
		_perf_end("draw.cctv.hud", section_start)
		section_start = _perf_tick()
	_draw_cctv_map()
	if perf_profile_enabled:
		_perf_end("draw.cctv.map", section_start)


func _draw_cctv_transition_noise() -> void:
	for i in range(40):
		if randf() < 0.08:
			var y := float(i * 20)
			var height := 10.0 + randf() * 100.0
			_canvas().draw_rect(Rect2(0.0, y, VIEW_W, height), Color(1.0, 1.0, 1.0, 0.35), true)


func _draw_cctv_border() -> void:
	_canvas().draw_rect(Rect2(8.0, 8.0, VIEW_W - 16.0, VIEW_H - 16.0), COLOR_WHITE, false, 1.0)


func _draw_cctv_clock() -> void:
	var hour := int(clamp(floor(night_time / (night_goal / 6.0)), 0.0, 99.0))
	var minute := clampi(int(floor(night_time / (night_goal / 360.0))) % 60, 0, 99)
	var second := clampi(int(floor(night_time / (night_goal / 21600.0))) % 60, 0, 99)
	_canvas().draw_rect(Rect2(447.0, 48.0, 380.0, 42.0), Color(0.0, 0.0, 0.0, 0.5), true)
	_draw_text("pixelmix", Vector2(540.0, 58.0), _pad2(hour), COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(2.0, 1.5))
	_draw_text("pixelmix", Vector2(640.0, 58.0), _pad2(minute), COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(2.0, 1.5))
	_draw_text("pixelmix", Vector2(740.0, 58.0), _pad2(second), COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(2.0, 1.5))
	_draw_text("pixelmix", Vector2(590.0, 58.0), ":", COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(2.0, 1.5))
	_draw_text("pixelmix", Vector2(690.0, 58.0), ":", COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2(2.0, 1.5))


func _draw_cctv_indicators() -> void:
	if current_cam == 5 or cctv_indicator_frames.is_empty():
		return
	var record_alpha := 1.2 if int(elapsed) % 2 == 0 else 0.2
	_draw_screen_texture(cctv_indicator_frames[0], Vector2(40.0, 645.0), Vector2.ONE, Color(1.0, 1.0, 1.0, record_alpha))
	if _current_cam_has_light() and cctv_indicator_frames.size() > 1:
		_draw_screen_texture(cctv_indicator_frames[1], Vector2(130.0, 645.0), Vector2.ONE, Color(1.0, 1.0, 1.0, 0.2 + (1.0 if cctv_light_held else 0.0)))


func _draw_cctv_map() -> void:
	var map_start := 0
	if perf_profile_enabled:
		map_start = _perf_tick()
	var map_tint := Color(1.0, 1.0, 1.0, cctv_map_alpha)
	var map_scale := _cctv_map_scale()
	var mouse := _mouse_screen()
	var text_scale := Vector2.ONE * map_scale
	if cctv_map_texture != null:
		_draw_screen_texture(cctv_map_texture, CCTV_MAP_POS, CCTV_MAP_SCALE * map_scale, map_tint)
	var you_pos := CCTV_MAP_POS + ((CCTV_MAP_YOU_POS - CCTV_MAP_POS) * map_scale)
	_draw_text("pixelmix", you_pos, GameState.t("you"), map_tint, 1.0, HALIGN_LEFT, VALIGN_TOP, text_scale)
	var you_size := 12.0 if int(elapsed) % 2 == 0 else 10.0
	var you_marker_pos := CCTV_MAP_POS + ((CCTV_MAP_YOU_MARKER_POS - CCTV_MAP_POS) * map_scale)
	_canvas().draw_rect(Rect2(you_marker_pos, Vector2(you_size, you_size) * map_scale), map_tint, true)
	var cam_name_pos := CCTV_MAP_POS + ((CCTV_MAP_CAM_NAME_POS - CCTV_MAP_POS) * map_scale)
	_draw_text("pixelmix", cam_name_pos, GameState.t(str(cam_data[current_cam]["name_key"])), map_tint, 1.0, HALIGN_RIGHT, VALIGN_TOP, Vector2(1.5, 1.5) * map_scale)
	for button in cam_buttons:
		_draw_camera_button(button, map_scale, mouse)
	if perf_profile_enabled:
		_perf_end("draw.cctv.map_base_buttons", map_start)
		map_start = _perf_tick()
	if _current_cam_has_light() and not is_power_empty:
		_draw_camera_light_button()
	if GameState.mod_music and current_cam == 3:
		_draw_music_box_button()
	if perf_profile_enabled:
		_perf_end("draw.cctv.map_action_buttons", map_start)
		map_start = _perf_tick()
	if GameState.radar:
		_draw_radar_icons()
	if perf_profile_enabled:
		_perf_end("draw.cctv.radar", map_start)


func _draw_camera_button(button: Dictionary, map_scale: float, mouse: Vector2) -> void:
	var base_rect: Rect2 = button["rect"]
	var rect := Rect2(CCTV_MAP_POS + ((base_rect.position - CCTV_MAP_POS) * map_scale), base_rect.size * map_scale)
	var cam_num := int(button["cam"])
	var color := COLOR_CAM_UNSELECTED
	if cam_num == current_cam:
		color = COLOR_CAM_SELECTED
	elif rect.has_point(mouse):
		color = COLOR_CAM_HOVER
	color.a = cctv_map_alpha
	_canvas().draw_rect(rect, color, true)
	for i in range(3):
		var inset := float(i) * map_scale
		_canvas().draw_rect(Rect2(rect.position + Vector2(inset, inset), rect.size - Vector2(inset * 2.0, inset * 2.0)), Color(1.0, 1.0, 1.0, cctv_map_alpha), false, 1.0)
	_draw_text("pixelmixbold", rect.position + (Vector2(7.0, 4.0) * map_scale), str(cam_data[cam_num]["label"]), Color(1.0, 1.0, 1.0, cctv_map_alpha), 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE * map_scale)


func _draw_camera_light_button() -> void:
	var rect := _camera_light_rect()
	var color := COLOR_CAM_SELECTED if cctv_light_held else (COLOR_CAM_HOVER if rect.has_point(_mouse_screen()) else COLOR_CAM_UNSELECTED)
	color.a = cctv_map_alpha
	_canvas().draw_rect(rect, color, true)
	for i in range(4):
		var inset := float(i)
		_canvas().draw_rect(Rect2(rect.position + Vector2(inset, inset), rect.size - Vector2(inset * 2.0, inset * 2.0)), Color(1.0, 1.0, 1.0, cctv_map_alpha), false, 1.0)
	var check_rect := Rect2(rect.position + Vector2(rect.size.x - 34.0, rect.size.y - 42.0), Vector2(22.0, 22.0))
	_canvas().draw_rect(check_rect, Color(1.0, 1.0, 1.0, cctv_map_alpha), not cctv_light_held)
	_canvas().draw_rect(check_rect, Color(1.0, 1.0, 1.0, cctv_map_alpha), false, 2.0)
	_draw_text("pixelmixbold", rect.position + Vector2(10.0, 12.0), GameState.t("turn_on_cam_light"), Color(1.0, 1.0, 1.0, cctv_map_alpha), 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2(0.9, 1.0))
	_draw_text("pixelmix", rect.position + Vector2(6.0, rect.size.y + 5.0), GameState.t("click_hold"), Color(1.0, 1.0, 1.0, cctv_map_alpha), 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2(1.16, 0.8))


func _draw_music_box_button() -> void:
	var rect := _music_box_rect()
	var color := COLOR_CAM_SELECTED if music_box_held else (COLOR_CAM_HOVER if rect.has_point(_mouse_screen()) else COLOR_CAM_UNSELECTED)
	color.a = cctv_map_alpha
	_canvas().draw_rect(rect, color, true)
	for i in range(4):
		var inset := float(i)
		_canvas().draw_rect(Rect2(rect.position + Vector2(inset, inset), rect.size - Vector2(inset * 2.0, inset * 2.0)), Color(1.0, 1.0, 1.0, cctv_map_alpha), false, 1.0)
	if cctv_watch_texture != null:
		_draw_screen_texture(cctv_watch_texture, rect.position, Vector2.ONE, Color(1.0, 1.0, 1.0, cctv_map_alpha))


func _draw_cctv_ai_overlays(source_y: float) -> void:
	var overlay_indices := {}
	for ai in ai_units:
		if not bool(ai.get("active", false)):
			continue
		var details: Array = _room_detail(str(ai.get("in", "")))
		if int(floor(float(details[1]))) != current_cam:
			continue
		var walkpath: Array = _walk_detail(ai, str(ai.get("in", "")))
		var overlay_index := int(walkpath[1])
		if overlay_index <= 0 or overlay_index >= cctv_ol_frames.size():
			continue
		var can_shake := int(ai.get("difficulty", 0)) > 0
		overlay_indices[overlay_index] = bool(overlay_indices.get(overlay_index, false)) or can_shake
	for overlay_index in range(1, cctv_ol_frames.size()):
		if overlay_indices.has(overlay_index):
			_draw_cctv_overlay_index(overlay_index, source_y, bool(overlay_indices[overlay_index]))
	if current_cam == 7:
		var bb: Dictionary = ai_by_id.get("ai_bb", {})
		if not bb.is_empty() and bool(bb.get("active", false)) and str(bb.get("in", "")) == "none":
			_draw_cctv_overlay_index(35, source_y)
	if current_cam == 6 and (_ai_in("ai_tx", "you") or _ai_in("ai_tx", "officetx")):
		_draw_cctv_overlay_index(29, source_y)
	if current_cam == 3 and _ai_in("ai_tb", "prizecornertb"):
		_set_hallucination_activity(60)


func _draw_cctv_overlay_index(overlay_index: int, source_y: float, allow_shake := false) -> void:
	if overlay_index <= 0 or overlay_index >= cctv_ol_frames.size():
		return
	var overlay_texture: Texture2D = cctv_ol_frames[overlay_index]
	_canvas().draw_texture_rect_region(overlay_texture, Rect2(0.0, 0.0, VIEW_W, VIEW_H), Rect2(0.0, source_y, 1280.0, 720.0), COLOR_WHITE)
	if source_y <= 0.0 or not allow_shake or not cctv_shake_frames.has(overlay_index):
		return
	var shake_frames: Array = cctv_shake_frames[overlay_index]
	if shake_frames.is_empty():
		return
	var shake_index := randi_range(0, shake_frames.size() - 1)
	var origin: Vector2 = cctv_shake_origins.get(overlay_index, Vector2.ZERO)
	_canvas().draw_texture(shake_frames[shake_index], Vector2(-origin.x, -origin.y))


func _draw_radar_icons() -> void:
	var placed_counts := {}
	var map_scale := _cctv_map_scale()
	var icon_tint := Color(1.0, 1.0, 1.0, cctv_map_alpha)
	for ai in ai_units:
		if not bool(ai.get("active", false)):
			continue
		var ai_id := str(ai.get("id", ""))
		if not radar_icons.has(ai_id):
			continue
		var frames: Array = radar_icons[ai_id]
		if frames.is_empty():
			continue
		var room_name := str(ai.get("in", ""))
		var room: Array = ai.get("indetails", [])
		if room.is_empty() or str(room[0]) != room_name:
			room = _room_detail(room_name)
		var texture: Texture2D = frames[0]
		var texture_size := texture.get_size()
		var column: int = maxi(int(room[6]), 1)
		var radar_offset := int(placed_counts.get(room_name, 0))
		var draw_pos := Vector2(
			CCTV_MAP_POS.x + float(room[4]) + (texture_size.x * float(radar_offset % column)),
			CCTV_MAP_POS.y + float(room[5]) + (texture_size.y * floor(float(radar_offset) / float(column)))
		)
		_draw_screen_texture(texture, _scale_cctv_map_pos(draw_pos), Vector2.ONE * map_scale, icon_tint)
		placed_counts[room_name] = radar_offset + 1


func _draw_gf_overlay() -> void:
	var frames := _get_scare_frames("sprt_scare_gf")
	if frames.is_empty():
		return
	var frame_index := int(floor(gf_overlay_time * 30.0)) % frames.size()
	var alpha: float = clampf(1.0 - (gf_overlay_time / 3.0), 0.0, 1.0)
	_draw_screen_texture(frames[frame_index], Vector2.ZERO, Vector2(2.0, 2.0), Color(1.0, 1.0, 1.0, alpha))


func _draw_inoffice_ai() -> void:
	if _ai_in("ai_tf", "office") or _ai_in("ai_tf", "officeclose"):
		_draw_inoffice_sprite("sprt_inoffice_tf", Vector2(672.0, 61.0), true)
	if _ai_in("ai_wf", "office"):
		_draw_inoffice_sprite("sprt_inoffice_wf", Vector2(608.0, 34.0), true)
	if _ai_in("ai_wb", "office"):
		_draw_inoffice_sprite("sprt_inoffice_wb", Vector2(384.0, 88.0))
	if _ai_in("ai_wc", "office"):
		_draw_inoffice_sprite("sprt_inoffice_wc", Vector2(896.0, 36.0))
	var gf: Dictionary = ai_by_id.get("ai_gf", {})
	if not gf.is_empty() and bool(gf.get("officevisible", false)):
		_draw_inoffice_sprite("sprt_inoffice_gf", Vector2(340.0, 266.0))
	if _ai_in("ai_bb", "officesp") and night_state == STATE_CCTV:
		_draw_inoffice_sprite("sprt_inoffice_bb", Vector2(429.0, 317.0))
	if tx_anim_time >= 0.0 and inoffice_frames.has("sprt_inoffice_tx"):
		var frames: Array = inoffice_frames["sprt_inoffice_tx"]
		if not frames.is_empty():
			var frame_index := clampi(int(floor(tx_anim_time * 30.0)), 0, frames.size() - 1)
			_draw_world_texture(frames[frame_index], Vector2(537.0, 0.0), Vector2.ONE, COLOR_WHITE)


func _draw_inoffice_sprite(sprite_name: String, world_pos: Vector2, animated := false) -> void:
	var texture: Texture2D = null
	if inoffice_textures.has(sprite_name):
		texture = inoffice_textures[sprite_name]
	if animated and inoffice_frames.has(sprite_name):
		var frames: Array = inoffice_frames[sprite_name]
		if not frames.is_empty():
			var frame_index := int(floor(elapsed * 20.0)) % frames.size()
			texture = frames[frame_index]
	_draw_world_texture(texture, world_pos, Vector2.ONE, COLOR_WHITE)


func _draw_close_office_anims() -> void:
	if inoffice_close_frames.is_empty():
		return
	var frame_index := int(floor(elapsed * 30.0)) % inoffice_close_frames.size()
	var texture: Texture2D = inoffice_close_frames[frame_index]
	if _should_close_anim_advance(ai_by_id.get("ai_tb", {})):
		_draw_close_office_slice(texture, Rect2(0.0, 0.0, texture.get_size().x, 720.0), Vector2(tb_close_x, 0.0))
	if _should_close_anim_advance(ai_by_id.get("ai_tc", {})):
		_draw_close_office_slice(texture, Rect2(0.0, 720.0, texture.get_size().x, 720.0), Vector2(tc_close_x, 0.0))


func _draw_close_office_slice(texture: Texture2D, source_rect: Rect2, world_pos: Vector2) -> void:
	var screen_pos: Vector2 = world_pos - Vector2(camx, CAMERA_Y)
	_canvas().draw_texture_rect_region(texture, Rect2(screen_pos, source_rect.size), source_rect, COLOR_WHITE)


func _draw_jumpscare() -> void:
	var frames := _get_scare_frames(str(scare_unit.get("scare_sprite", "")))
	if frames.is_empty():
		_canvas().draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), COLOR_BLACK, true)
		return
	var frame_index := clampi(int(floor(jumpscare_time * 30.0)), 0, frames.size() - 1)
	var texture: Texture2D = frames[frame_index]
	var draw_scale := Vector2(2.0, 2.0)
	var draw_size := texture.get_size() * draw_scale
	var pos := Vector2((VIEW_W - draw_size.x) * 0.5, (VIEW_H - draw_size.y) * 0.5)
	_draw_screen_texture(texture, pos, draw_scale, COLOR_WHITE)


func _draw_game_over() -> void:
	_canvas().draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), COLOR_BLACK, true)
	var killer_index := _killer_over_index(last_killer)
	if killer_index >= 0 and killer_index < over_character_frames.size():
		_draw_screen_texture(over_character_frames[killer_index], Vector2.ZERO, Vector2.ONE, COLOR_WHITE)
	if cctv_noise_frames.size() > 0:
		var noise_index := int(floor(game_over_time * 30.0)) % cctv_noise_frames.size()
		var static_alpha: float = clamp(1.0 - (game_over_time / 2.0), 0.15, 1.0)
		_draw_screen_texture(cctv_noise_frames[noise_index], Vector2.ZERO, Vector2(2.0, 2.0), Color(1.0, 1.0, 1.0, static_alpha))
	_draw_text("pixelmixbold", Vector2(64.0, 610.0), GameState.t("game_over"), COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2(2.0, 2.0))
	_draw_text("pixelmix", Vector2(64.0, 650.0), _game_over_tip_lines(last_killer), COLOR_GRAY, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE)
	_draw_text("pixelmix", Vector2(1216.0, 684.0), "ESC " + GameState.t("main_options"), COLOR_GRAY, 1.0, HALIGN_RIGHT, VALIGN_TOP, Vector2.ONE)


func _killer_over_index(killer: String) -> int:
	match killer:
		"ai_tf":
			return 0
		"ai_tb":
			return 1
		"ai_tc":
			return 2
		"ai_tx":
			return 3
		"ai_wf":
			return 4
		"ai_wb":
			return 5
		"ai_wc":
			return 6
		"ai_wx":
			return 7
		"ai_pp":
			return 8
		_:
			return -1


func _game_over_tip(killer: String) -> String:
	match killer:
		"ai_tf":
			return "Toy Freddy can hide in the party rooms after entering the office."
		"ai_tb":
			return "Toy Bonnie approaches from the right vent."
		"ai_tc":
			return "Toy Chica approaches from the left vent."
		"ai_tx":
			return "Mangle is weak to the flashlight. Keep Kids Cove watched."
		"ai_wf":
			return "Withered Freddy tries to hide from the lights."
		"ai_wb":
			return "Withered Bonnie needs to be flashed on camera."
		"ai_wc":
			return "Withered Chica needs to be flashed on camera."
		"ai_wx":
			return "Withered Foxy only appears in the hallway."
		"ai_pp":
			return "Do not let the battery run out."
		_:
			return "Try again."


func _game_over_tip_lines(killer: String) -> String:
	var text := "> " + _game_over_tip(killer)
	var secondary_key := str(GameState.last_death_context.get("secondary_reason", ""))
	if secondary_key != "":
		text += "\n> " + GameState.t(secondary_key)
	return text


func _current_cam_has_light() -> bool:
	return cctv_disabled_timer <= 0.0 and bool(cam_data[current_cam]["light"])


func _top_control_rect() -> Rect2:
	return MOBILE_TOP_HOVER if GameState.uses_touch_controls() else TOP_HOVER


func _bottom_control_rect() -> Rect2:
	return MOBILE_BOTTOM_HOVER if GameState.uses_touch_controls() else BOTTOM_HOVER


func _control_button_position(texture: Texture2D, desktop_pos: Vector2, button_scale: Vector2, top: bool) -> Vector2:
	if not GameState.uses_touch_controls() or texture == null:
		return desktop_pos
	var size := texture.get_size() * button_scale
	var y := 8.0 if top else VIEW_H - size.y - 8.0
	return Vector2((VIEW_W - size.x) * 0.5, y)


func _hover_alpha(point: Vector2) -> float:
	var distance := _mouse_screen().distance_to(point)
	return clamp(0.2 + (1.0 - (distance * 0.0025)), 0.2, 0.8)


func _is_flash_active() -> bool:
	return ((view_light_held and view_disabled_timer <= 0.0) or (cctv_light_held and cctv_disabled_timer <= 0.0)) and not is_power_empty


func _flash_texture_for(key: String) -> Texture2D:
	match key:
		"left":
			return flash_left_texture
		"front":
			return flash_front_texture
		"right":
			return flash_right_texture
		_:
			return null


func _screen_to_world(screen_pos: Vector2) -> Vector2:
	return screen_pos + Vector2(camx, CAMERA_Y)


func _mouse_screen() -> Vector2:
	return get_viewport().get_mouse_position()


func _pad2(value: int) -> String:
	var text := str(value)
	return "0" + text if text.length() < 2 else text


func _canvas() -> CanvasItem:
	return active_canvas if active_canvas != null else self


func _draw_world_texture(texture: Texture2D, world_pos: Vector2, draw_scale: Vector2, tint_color: Color) -> void:
	if texture == null:
		return
	var screen_pos: Vector2 = world_pos - Vector2(camx, CAMERA_Y)
	var draw_size: Vector2 = texture.get_size() * draw_scale
	_canvas().draw_texture_rect(texture, Rect2(screen_pos, draw_size), false, tint_color)


func _draw_screen_texture(texture: Texture2D, screen_pos: Vector2, draw_scale: Vector2, tint_color: Color) -> void:
	if texture == null:
		return
	_canvas().draw_texture_rect(texture, Rect2(screen_pos, texture.get_size() * draw_scale), false, tint_color)


func _draw_screen_texture_centered(texture: Texture2D, center_pos: Vector2, draw_scale: Vector2, tint_color: Color) -> void:
	if texture == null:
		return
	var size := texture.get_size() * draw_scale
	_canvas().draw_texture_rect(texture, Rect2(center_pos - (size * 0.5), size), false, tint_color)


func _draw_screen_texture_centered_rotated(texture: Texture2D, center_pos: Vector2, draw_scale: Vector2, rotation_radians: float, tint_color: Color) -> void:
	if texture == null:
		return
	var canvas := _canvas()
	canvas.draw_set_transform(center_pos, rotation_radians, draw_scale)
	canvas.draw_texture(texture, -texture.get_size() * 0.5, tint_color)
	canvas.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _register_vector_font(font_key: String, size: int, line_step: int) -> void:
	font_data[font_key] = {"size": size, "line_step": line_step}


func _draw_text(font_key: String, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int, text_scale: Vector2) -> void:
	var text_start := 0
	if perf_profile_enabled:
		text_start = _perf_tick()
	if not font_data.has(font_key):
		return
	var data: Dictionary = font_data[font_key]
	if _fallback_font_for_key(font_key) == null:
		return
	_draw_vector_text(font_key, data, screen_pos, text, color, alpha, halign, valign, text_scale)
	if perf_profile_enabled:
		_perf_end("draw.text", text_start)


func _fallback_font_for_key(font_key: String) -> FontFile:
	if font_key == "pixelmix" or font_key == "pixelmixbold":
		return pixelmix_fallback_font if pixelmix_fallback_font != null else fallback_font
	return fallback_font


func _draw_vector_text(font_key: String, data: Dictionary, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int, text_scale: Vector2) -> void:
	var vector_font := _fallback_font_for_key(font_key)
	if vector_font == null:
		return
	var base_line_step := float(data["line_step"])
	var line_step := base_line_step * text_scale.y
	var base_font_size := float(data["size"])
	var visual_font_size := base_font_size + ((base_line_step - base_font_size) * 0.25)
	if font_key == "pixelmix" or font_key == "pixelmixbold":
		visual_font_size = base_line_step
	var font_size := int(max(round(visual_font_size * max(text_scale.x, text_scale.y)), 8.0))
	var ascent := vector_font.get_ascent(font_size)
	var layout_key := "%s:%d:%s" % [font_key, font_size, text]
	var layout: Dictionary = text_layout_cache.get(layout_key, {})
	if layout.is_empty():
		var layout_lines := text.split("\n")
		var layout_widths: Array[float] = []
		for layout_line in layout_lines:
			layout_widths.append(vector_font.get_string_size(str(layout_line), HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x)
		layout = {"lines": layout_lines, "widths": layout_widths}
		text_layout_cache[layout_key] = layout
	var lines: PackedStringArray = layout["lines"]
	var widths: Array = layout["widths"]
	var start := screen_pos
	if valign == VALIGN_MIDDLE:
		start.y -= (line_step * lines.size()) * 0.5
	var text_color := Color(color.r, color.g, color.b, color.a * alpha)
	for line_index in range(lines.size()):
		var line_text := str(lines[line_index])
		var line_width := float(widths[line_index])
		var x := start.x
		if halign == HALIGN_CENTER:
			x -= line_width * 0.5
		elif halign == HALIGN_RIGHT:
			x -= line_width
		var baseline := start.y + (float(line_index) * line_step) + ascent
		_canvas().draw_string(vector_font, Vector2(x, baseline), line_text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, text_color)
