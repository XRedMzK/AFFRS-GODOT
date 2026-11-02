extends Node2D

const MENU_DRAW_LAYER_SCRIPT := preload("res://scripts/menu/MenuDrawLayer.gd")
const UPSCALE_2D_SHADER := preload("res://shaders/upscale_2d.gdshader")

const VIEW_W := 1280.0
const VIEW_H := 720.0
const INITIAL_CAM_X := 720.0
const ROOM_W := 2918.0

const DRAW_LAYER_BACKGROUND := 0
const DRAW_LAYER_ADDITIVE := 1
const DRAW_LAYER_UI := 2
const HELD_REPEAT_DELAY := 0.17
const HELD_REPEAT_SLOW_INTERVAL := 0.10
const HELD_REPEAT_FAST_AFTER := 2.0
const HELD_REPEAT_FAST_INTERVAL := 0.05
const RADIO_SIZE := Vector2(40.0, 40.0)
const RADIO_ORIGIN := Vector2(20.0, 20.0)
const SLIDER_SIZE := Vector2(20.0, 40.0)
const SLIDER_ORIGIN := Vector2(10.0, 20.0)
const OPTIONS_CATEGORY_SIZE := Vector2(248.0, 44.0)
const OPTIONS_CATEGORY_X_OFFSET := 88.0
const OPTIONS_ROW_LABEL_X_OFFSET := 400.0
const OPTIONS_ROW_TOP := 132.0
const OPTIONS_ROW_STEP := 56.0
const OPTIONS_ROW_CONTROL_Y_OFFSET := 10.0
const OPTIONS_LABEL_CONTROL_GAP := 16.0
const OPTIONS_VALUE_SIDE_GAP := 12.0
const AI_BUTTON_SIZE := Vector2(45.0, 14.0)
const AI_BUTTON_ORIGIN := Vector2(22.0, 7.0)
const AI_BUTTON_LOCAL_Y := 138.0
const PORTRAIT_STAR_ORIGIN := Vector2(22.0, 0.0)

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_GRAY := Color(0.5, 0.5, 0.5, 1.0)
const COLOR_RED := Color(1.0, 0.0, 0.0, 1.0)
const COLOR_YELLOW := Color(1.0, 1.0, 0.0, 1.0)
const COLOR_HOVER := Color(99.0 / 255.0, 122.0 / 255.0, 1.0, 40.0 / 255.0)
const COLOR_LAMP := Color(99.0 / 255.0, 159.0 / 255.0, 1.0, 1.0)
const COLOR_OMEGA := Color(235.0 / 255.0, 51.0 / 255.0, 1.0, 1.0)
const COLOR_WOTT := Color(0.0, 155.0 / 255.0, 1.0, 1.0)

const HALIGN_LEFT := 0
const HALIGN_CENTER := 1
const HALIGN_RIGHT := 2
const VALIGN_TOP := 0
const VALIGN_MIDDLE := 1

var menu_bg: Texture2D
var menu_mainblack: Texture2D
var menu_openlogo: Texture2D
var menu_hallway: Array[Texture2D] = []
var menu_flashvol: Texture2D
var menu_lampvol: Texture2D
var beta_notice: Texture2D
var radio_buttons: Array[Texture2D] = []
var slider_buttons: Array[Texture2D] = []
var ai_buttons: Array[Texture2D] = []
var portrait_star: Texture2D
var portrait_textures := {}
var credit_dudes := {}
var fallback_font: FontFile

var font_data := {}
var text_width_cache := {}
var hover_player: AudioStreamPlayer
var select_player: AudioStreamPlayer
var click_player: AudioStreamPlayer
var music_player: AudioStreamPlayer
var background_draw_layer: Node2D
var additive_draw_layer: Node2D
var ui_draw_layer: Node2D
var active_canvas: CanvasItem
var render_viewport: SubViewport
var render_root: Node2D
var render_output: TextureRect
var render_material: ShaderMaterial
var applied_render_scale := -1.0
var applied_upscaler := -1

var camx := INITIAL_CAM_X
var current_slot := "main"
var target_slot := "main"
var hovered_button := -1
var terminal_hovered := false
var hovered_back_slot := ""
var hovered_custom_control := ""
var hovered_options_control := ""
var hovered_extras_control := ""
var hovered_new_game_control := ""
var hovered_portrait_key := ""
var hovered_continue_night := 0
var hovered_mission_index := -1
var hovered_minigame_index := -1
var options_category := "video"
var held_event := ""
var held_time := 0.0
var held_repeat_elapsed := 0.0
var elapsed_ms := 0.0
var fog_alpha := 1.0
var fog_soft_target := 1.0
var fog_hard_target := 1.0
var fog_variance := 0.5

var bg_base := Vector2(0.0, -50.0)
var slots := {
	"new_game": {"x": 1488.0, "alpha": 0.0, "active": false, "title": "New Game"},
	"continue": {"x": 1488.0, "alpha": 0.0, "active": false, "title": "Continue"},
	"custom": {"x": 150.0, "alpha": 0.0, "active": false, "title": "Custom Night"},
	"extras": {"x": 720.0, "alpha": 0.0, "active": false, "title": "Extras"},
	"missions": {"x": 1488.0, "alpha": 0.0, "active": false, "title": "Missions"},
	"minigames": {"x": 1488.0, "alpha": 0.0, "active": false, "title": "Minigames"},
	"main": {"x": 720.0, "alpha": 1.0, "active": true, "title": "Main Menu"},
	"options": {"x": 720.0, "alpha": 0.0, "active": false, "title": "Options"},
	"credits": {"x": 720.0, "alpha": 0.0, "active": false, "title": "Credits"},
	"quit": {"x": 720.0, "alpha": 0.0, "active": false, "title": "Quit"},
}

var main_buttons := [
	{"label": "New Game", "target": "new_game", "subimg": 1, "x": 784.0, "y": 224.0, "w": 512.0, "h": 55.17241, "enabled": true},
	{"label": "Continue", "target": "continue", "subimg": 3, "x": 784.0, "y": 288.0, "w": 512.0, "h": 55.17241, "enabled": true},
	{"label": "Extras", "target": "extras", "subimg": 2, "x": 784.0, "y": 352.0, "w": 512.0, "h": 55.17241, "enabled": true},
	{"label": "Options", "target": "options", "subimg": 4, "x": 784.0, "y": 416.0, "w": 512.0, "h": 55.17241, "enabled": true},
	{"label": "Credits", "target": "credits", "subimg": 5, "x": 784.0, "y": 480.0, "w": 512.0, "h": 55.17241, "enabled": true},
	{"label": "Quit", "target": "quit", "subimg": 0, "x": 784.0, "y": 544.0, "w": 512.0, "h": 55.17241, "enabled": true},
]

var back_buttons := {
	"new_game": Rect2(1536.0, 608.0, 160.0, 64.0),
	"continue": Rect2(1536.0, 608.0, 160.0, 64.0),
	"custom": Rect2(198.0, 608.0, 160.0, 64.0),
	"extras": Rect2(768.0, 608.0, 160.0, 64.0),
	"missions": Rect2(1536.0, 608.0, 160.0, 64.0),
	"minigames": Rect2(1536.0, 608.0, 160.0, 64.0),
	"options": Rect2(768.0, 608.0, 160.0, 64.0),
	"credits": Rect2(768.0, 608.0, 160.0, 64.0),
}

var new_game_buttons := {
	"yes": Rect2(1584.0, 312.0, 184.0, 64.0),
	"no": Rect2(1816.0, 312.0, 184.0, 64.0),
}

var custom_portraits := [
	{"key": "lvl_tf", "sprite": "tf", "x": 659.0, "y": 180.0},
	{"key": "lvl_tb", "sprite": "tb", "x": 800.0, "y": 180.0},
	{"key": "lvl_tc", "sprite": "tc", "x": 940.0, "y": 180.0},
	{"key": "lvl_tx", "sprite": "tx", "x": 1080.0, "y": 180.0},
	{"key": "lvl_bb", "sprite": "bb", "x": 1220.0, "y": 180.0},
	{"key": "lvl_wf", "sprite": "wf", "x": 659.0, "y": 390.0},
	{"key": "lvl_wb", "sprite": "wb", "x": 800.0, "y": 390.0},
	{"key": "lvl_wc", "sprite": "wc", "x": 940.0, "y": 390.0},
	{"key": "lvl_wx", "sprite": "wx", "x": 1080.0, "y": 390.0},
	{"key": "lvl_gf", "sprite": "gf", "x": 1220.0, "y": 390.0},
]

var custom_sliders := [
	{"event": "lvl_duration-1", "x": 443.0, "y": 143.0, "right": false},
	{"event": "lvl_duration+1", "x": 576.0, "y": 143.0, "right": true},
	{"event": "lvl_battery-1", "x": 443.0, "y": 187.0, "right": false},
	{"event": "lvl_battery+1", "x": 576.0, "y": 187.0, "right": true},
	{"event": "lvl_toxic-1", "x": 443.0, "y": 231.0, "right": false},
	{"event": "lvl_toxic+1", "x": 576.0, "y": 231.0, "right": true},
	{"event": "lvl_usage-1", "x": 443.0, "y": 275.0, "right": false},
	{"event": "lvl_usage+1", "x": 576.0, "y": 275.0, "right": true},
]

var custom_radios := [
	{"event": "mod_music", "x": 469.0, "y": 422.0},
	{"event": "mod_auto", "x": 469.0, "y": 466.0},
	{"event": "mod_perma", "x": 469.0, "y": 510.0},
	{"event": "mod_insta", "x": 469.0, "y": 554.0},
	{"event": "lvl_pp", "x": 1360.0, "y": 572.0},
]

var custom_group_buttons := [
	{"event": "all_0", "label_key": "all_off", "value": 0, "x": 656.0, "y": 550.0, "w": 120.0, "h": 40.0},
	{"event": "all_11", "label_key": "all_max", "value": 11, "x": 800.0, "y": 550.0, "w": 120.0, "h": 40.0},
	{"event": "all_-1", "label": "-1", "value": -1, "x": 944.0, "y": 550.0, "w": 56.0, "h": 40.0},
	{"event": "all_1", "label": "+1", "value": 1, "x": 1008.0, "y": 550.0, "w": 56.0, "h": 40.0},
	{"event": "randomize", "label_key": "randomize", "x": 656.0, "y": 596.0, "w": 176.0, "h": 36.0},
]

var extras_buttons := [
	{"id": "custom", "label_key": "main_custom", "desc_key": "extras_custom_desc", "target": "custom", "x": 784.0, "y": 164.0, "w": 512.0, "h": 64.0},
	{"id": "survival", "label_key": "extras_survival", "desc_key": "extras_survival_desc", "target": "survival", "x": 784.0, "y": 244.0, "w": 512.0, "h": 64.0},
	{"id": "random", "label_key": "extras_random", "desc_key": "extras_random_desc", "target": "random", "x": 784.0, "y": 324.0, "w": 512.0, "h": 64.0},
	{"id": "missions", "label_key": "extras_missions", "desc_key": "extras_missions_desc", "target": "missions", "x": 784.0, "y": 404.0, "w": 512.0, "h": 64.0},
	{"id": "minigames", "label_key": "extras_minigames", "desc_key": "extras_minigames_desc", "target": "minigames", "x": 784.0, "y": 484.0, "w": 512.0, "h": 64.0},
]

var options_categories := [
	{"id": "video", "label_key": "video_settings", "y": 128.0},
	{"id": "audio", "label_key": "audio_settings", "y": 184.0},
	{"id": "language", "label_key": "language_settings", "y": 240.0},
	{"id": "gameplay", "label_key": "gameplay_settings", "y": 296.0},
]

var options_radios := [
	{"event": "fullscreen", "category": "video", "row": 0},
	{"event": "vsync", "category": "video", "row": 3},
	{"event": "perspective", "category": "video", "row": 4},
	{"event": "particles", "category": "video", "row": 5},
	{"event": "performance_mode", "category": "video", "row": 6},
	{"event": "babyscare", "category": "audio", "row": 2},
	{"event": "hiderewards", "category": "gameplay", "row": 0},
	{"event": "radar", "category": "gameplay", "row": 1},
	{"event": "toxicity_scale", "category": "gameplay", "row": 2},
]

var options_sliders := [
	{"event": "antialiasing-1", "category": "video", "row": 1, "right": false},
	{"event": "antialiasing+1", "category": "video", "row": 1, "right": true},
	{"event": "upscaler-1", "category": "video", "row": 2, "right": false},
	{"event": "upscaler+1", "category": "video", "row": 2, "right": true},
	{"event": "mastervol-1", "category": "audio", "row": 0, "right": false},
	{"event": "mastervol+1", "category": "audio", "row": 0, "right": true},
	{"event": "musicvol-1", "category": "audio", "row": 1, "right": false},
	{"event": "musicvol+1", "category": "audio", "row": 1, "right": true},
	{"event": "language-1", "category": "language", "row": 0, "right": false},
	{"event": "language+1", "category": "language", "row": 0, "right": true},
	{"event": "phone_guy_voice-1", "category": "language", "row": 1, "right": false},
	{"event": "phone_guy_voice+1", "category": "language", "row": 1, "right": true},
]


func _ready() -> void:
	menu_bg = load("res://assets/sprites/menu/sprt_menu_bg.png")
	menu_mainblack = load("res://assets/sprites/menu/sprt_menu_mainblack.png")
	menu_openlogo = load("res://assets/sprites/menu/sprt_menu_openlogo.png")
	menu_flashvol = load("res://assets/sprites/menu/sprt_menu_flashvol.png")
	menu_lampvol = load("res://assets/sprites/menu/sprt_menu_lampvol.png")
	beta_notice = load("res://assets/sprites/menu/sprt_betabuildnotice.png")
	for i in range(6):
		menu_hallway.append(load("res://assets/sprites/menu/sprt_menu_hallway_%d.png" % i))
	for i in range(2):
		radio_buttons.append(_load_menu_control_sprite("sprt_menu_radiobt_%d" % i))
		slider_buttons.append(_load_menu_control_sprite("sprt_menu_sliderbt_%d" % i))
		ai_buttons.append(_load_menu_control_sprite("sprt_menu_aibt_%d" % i))
	portrait_star = load("res://assets/sprites/custom_night/sprt_portrait_star_0.png")
	_load_portrait_textures()
	_load_credit_dudes()
	_register_vector_font("menubt", 18, 25)
	_register_vector_font("footer", 12, 17)
	_register_vector_font("terminal", 16, 22)
	_register_vector_font("cnbt", 24, 33)
	_register_vector_font("cnsmall", 16, 22)
	_register_vector_font("smaller", 12, 17)
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	_setup_render_backend()
	_setup_draw_layers()
	_setup_audio()
	set_process(true)


func _load_portrait_textures() -> void:
	for sprite_name in ["tf", "tb", "tc", "tx", "bb", "wf", "wb", "wc", "wx", "gf"]:
		var frames: Array[Texture2D] = []
		for frame in range(12):
			frames.append(load("res://assets/sprites/custom_night/sprt_portrait_%s_%d.png" % [sprite_name, frame]))
		portrait_textures[sprite_name] = frames


func _load_credit_dudes() -> void:
	for sprite_name in ["tb", "tf", "tx", "bb", "wf", "wc", "wx", "pp"]:
		var path := "res://assets/gm/sprites/sprt_dude_%s_0.png" % sprite_name
		if ResourceLoader.exists(path):
			credit_dudes[sprite_name] = load(path)


func _setup_draw_layers() -> void:
	background_draw_layer = _make_draw_layer("BackgroundLayer", DRAW_LAYER_BACKGROUND, 0)
	additive_draw_layer = _make_draw_layer("AdditiveLightLayer", DRAW_LAYER_ADDITIVE, 1)
	var additive_material := CanvasItemMaterial.new()
	additive_material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	additive_draw_layer.material = additive_material
	ui_draw_layer = _make_draw_layer("UiLayer", DRAW_LAYER_UI, 2)


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


func _make_draw_layer(layer_name: String, draw_kind: int, z_order: int) -> Node2D:
	var layer: Node2D = MENU_DRAW_LAYER_SCRIPT.new()
	layer.name = layer_name
	layer.z_index = z_order
	layer.set("menu", self)
	layer.set("draw_kind", draw_kind)
	(render_root if render_root != null else self).add_child(layer)
	return layer


func _setup_audio() -> void:
	hover_player = AudioStreamPlayer.new()
	hover_player.name = "MenuHover"
	hover_player.stream = load("res://assets/sounds/menu/soun_menuover.wav")
	hover_player.volume_db = GameState.volume_db(GameState.mastervol)
	add_child(hover_player)

	select_player = AudioStreamPlayer.new()
	select_player.name = "MenuSelect"
	select_player.stream = load("res://assets/sounds/menu/soun_menuselect.wav")
	select_player.volume_db = GameState.volume_db(GameState.mastervol)
	add_child(select_player)

	click_player = AudioStreamPlayer.new()
	click_player.name = "MenuClickTicker"
	click_player.stream = load("res://assets/sounds/menu/soun_clickticker.wav")
	click_player.volume_db = GameState.volume_db(GameState.mastervol)
	add_child(click_player)

	music_player = AudioStreamPlayer.new()
	music_player.name = "MenuMusic"
	music_player.stream = load("res://assets/sounds/menu/soun_track_menu.wav")
	music_player.volume_db = GameState.volume_db(GameState.musicvol)
	music_player.finished.connect(_restart_music)
	add_child(music_player)
	if DisplayServer.get_name() != "headless":
		music_player.play()


func _restart_music() -> void:
	music_player.play()


func _exit_tree() -> void:
	if music_player != null and music_player.finished.is_connected(_restart_music):
		music_player.finished.disconnect(_restart_music)
	for player in [hover_player, select_player, click_player, music_player]:
		if player == null:
			continue
		player.stop()
		player.stream = null
	menu_bg = null
	menu_mainblack = null
	menu_openlogo = null
	menu_hallway.clear()
	menu_flashvol = null
	menu_lampvol = null
	beta_notice = null
	radio_buttons.clear()
	slider_buttons.clear()
	ai_buttons.clear()
	portrait_star = null
	portrait_textures.clear()
	credit_dudes.clear()
	fallback_font = null
	font_data.clear()
	text_width_cache.clear()
	active_canvas = null
	if render_output != null:
		render_output.material = null
		render_output.texture = null
	render_material = null
	render_viewport = null
	render_root = null
	render_output = null


func _process(delta: float) -> void:
	elapsed_ms += delta * 1000.0
	_sync_render_backend()
	_update_lighting(delta)
	_update_transition(delta)
	_update_hover_state()
	_update_held_control(delta)
	_queue_draw_layers()


func _queue_draw_layers() -> void:
	for layer in [background_draw_layer, additive_draw_layer, ui_draw_layer]:
		if layer != null:
			layer.queue_redraw()


func _update_lighting(delta: float) -> void:
	var frame_scale: float = clamp(delta * 60.0, 0.0, 4.0)
	if randf() < 0.03 * frame_scale:
		fog_soft_target = fog_hard_target - randf() * fog_variance
	if not is_equal_approx(fog_alpha, fog_soft_target):
		var change_amount: float = 0.002 * frame_scale
		if fog_alpha < fog_soft_target:
			fog_alpha = min(fog_alpha + change_amount, fog_soft_target)
		else:
			fog_alpha = max(fog_alpha - change_amount, fog_soft_target)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_handle_click(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		held_event = ""
		held_time = 0.0
		held_repeat_elapsed = 0.0
	elif event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN) and event.pressed:
		if current_slot == "custom" and target_slot == "custom" and hovered_portrait_key != "":
			_play_click()
			_apply_menu_event("ai+1" if event.button_index == MOUSE_BUTTON_WHEEL_UP else "ai-1")


func _update_held_control(delta: float) -> void:
	if held_event == "" or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	held_time += delta
	if held_time < HELD_REPEAT_DELAY:
		return
	var interval: float = HELD_REPEAT_FAST_INTERVAL if held_time >= HELD_REPEAT_FAST_AFTER else HELD_REPEAT_SLOW_INTERVAL
	held_repeat_elapsed += delta
	while held_repeat_elapsed >= interval:
		held_repeat_elapsed -= interval
		_play_click()
		_apply_menu_event(held_event)


func _update_transition(delta: float) -> void:
	if current_slot == target_slot:
		return

	var frame_scale: float = clamp(delta * 60.0, 0.0, 4.0)
	var target: Dictionary = slots[target_slot]
	target["alpha"] = min(float(target["alpha"]) + (0.1 * frame_scale), 1.0)
	for slot_name in slots.keys():
		if slot_name != target_slot:
			var slot: Dictionary = slots[slot_name]
			slot["alpha"] = max(float(slot["alpha"]) - (0.1 * frame_scale), 0.0)

	var target_x: float = float(target["x"])
	var distance: float = abs(target_x - camx)
	var step: float = (1.0 + (distance / 15.0)) * frame_scale
	if camx < target_x:
		camx = min(camx + step, target_x)
	elif camx > target_x:
		camx = max(camx - step, target_x)

	if abs(camx - target_x) < 1.0 and float(target["alpha"]) >= 1.0:
		_finish_transition()


func _finish_transition() -> void:
	current_slot = target_slot
	camx = float(slots[current_slot]["x"])
	for slot_name in slots.keys():
		slots[slot_name]["active"] = slot_name == current_slot
		slots[slot_name]["alpha"] = 1.0 if slot_name == current_slot else 0.0
	hovered_button = -1
	terminal_hovered = false
	hovered_back_slot = ""
	hovered_custom_control = ""
	hovered_options_control = ""
	hovered_extras_control = ""
	hovered_new_game_control = ""
	hovered_portrait_key = ""
	hovered_continue_night = 0
	hovered_mission_index = -1
	hovered_minigame_index = -1
	held_event = ""
	held_time = 0.0
	held_repeat_elapsed = 0.0


func _update_hover_state() -> void:
	var world_mouse := _world_mouse()
	var next_hover := -1
	var next_terminal := false
	var next_back := ""
	var next_custom := ""
	var next_options := ""
	var next_extras := ""
	var next_new_game := ""
	var next_portrait := ""
	var next_continue_night := 0
	var next_mission_index := -1
	var next_minigame_index := -1

	if current_slot == "main" and target_slot == "main" and bool(slots["main"]["active"]):
		for i in range(main_buttons.size()):
			var button: Dictionary = main_buttons[i]
			if bool(button["enabled"]) and _button_rect(button).has_point(world_mouse):
				next_hover = i
				break
		next_terminal = Rect2(776.0, 68.0, 536.0, 32.0).has_point(world_mouse)
	else:
		for slot_name in back_buttons.keys():
			if current_slot == slot_name and target_slot == slot_name and back_buttons[slot_name].has_point(world_mouse):
				next_back = slot_name
				break
		if next_back == "":
			if current_slot == "custom" and target_slot == "custom":
				next_custom = _hovered_custom_control(world_mouse)
				next_portrait = hovered_portrait_key
			elif current_slot == "options" and target_slot == "options":
				next_options = _hovered_options_control(world_mouse)
			elif current_slot == "extras" and target_slot == "extras":
				next_extras = _hovered_extras_control(world_mouse)
			elif current_slot == "missions" and target_slot == "missions":
				next_mission_index = _hovered_mission_index(world_mouse)
			elif current_slot == "minigames" and target_slot == "minigames":
				next_minigame_index = _hovered_minigame_index(world_mouse)
			elif current_slot == "continue" and target_slot == "continue":
				next_continue_night = _hovered_continue_night(world_mouse)
			elif current_slot == "new_game" and target_slot == "new_game":
				next_new_game = _hovered_new_game_control(world_mouse)

		if next_hover != hovered_button or (next_terminal and not terminal_hovered) or (next_back != "" and next_back != hovered_back_slot) or (next_continue_night > 0 and next_continue_night != hovered_continue_night) or (next_new_game != "" and next_new_game != hovered_new_game_control) or (next_extras != "" and next_extras != hovered_extras_control) or (next_mission_index >= 0 and next_mission_index != hovered_mission_index) or (next_minigame_index >= 0 and next_minigame_index != hovered_minigame_index) or _should_play_custom_hover(next_custom) or _should_play_options_hover(next_options):
			if next_hover != -1 or next_terminal or next_back != "" or next_continue_night > 0 or next_new_game != "" or next_extras != "" or next_mission_index >= 0 or next_minigame_index >= 0 or _is_custom_hover_sound(next_custom) or _is_options_hover_sound(next_options):
				hover_player.play()

	hovered_button = next_hover
	terminal_hovered = next_terminal
	hovered_back_slot = next_back
	hovered_custom_control = next_custom
	hovered_options_control = next_options
	hovered_extras_control = next_extras
	hovered_new_game_control = next_new_game
	hovered_portrait_key = next_portrait
	hovered_continue_night = next_continue_night
	hovered_mission_index = next_mission_index
	hovered_minigame_index = next_minigame_index


func _handle_click(screen_position: Vector2) -> void:
	var world_pos := Vector2(screen_position.x + camx, screen_position.y)
	if hovered_back_slot != "":
		select_player.play()
		_set_target_slot(_back_target_for_slot(hovered_back_slot))
		return
	if current_slot == "main" and target_slot == "main":
		for i in range(main_buttons.size()):
			var button: Dictionary = main_buttons[i]
			if bool(button["enabled"]) and _button_rect(button).has_point(world_pos):
				_activate_main_button(button)
				return
	elif current_slot == "custom" and target_slot == "custom":
		if _handle_custom_click(world_pos):
			return
	elif current_slot == "options" and target_slot == "options":
		if _handle_options_click(world_pos):
			return
	elif current_slot == "extras" and target_slot == "extras":
		if _handle_extras_click(world_pos):
			return
	elif current_slot == "missions" and target_slot == "missions":
		if _handle_missions_click(world_pos):
			return
	elif current_slot == "minigames" and target_slot == "minigames":
		if _handle_minigames_click(world_pos):
			return
	elif current_slot == "continue" and target_slot == "continue":
		if _handle_continue_click(world_pos):
			return
	elif current_slot == "new_game" and target_slot == "new_game":
		if _handle_new_game_click(world_pos):
			return


func _back_target_for_slot(slot_name: String) -> String:
	match slot_name:
		"custom", "missions", "minigames":
			return "extras"
		_:
			return "main"


func _activate_main_button(button: Dictionary) -> void:
	select_player.play()
	var target_name: String = str(button["target"])
	if target_name == "quit":
		get_tree().quit()
		return
	if target_name == "custom":
		GameState.reset_custom_night_defaults()
	_set_target_slot(target_name)


func _set_target_slot(slot_name: String) -> void:
	for slot_key in slots.keys():
		slots[slot_key]["active"] = false
	target_slot = slot_name
	hovered_button = -1
	terminal_hovered = false
	hovered_back_slot = ""
	hovered_custom_control = ""
	hovered_options_control = ""
	hovered_extras_control = ""
	hovered_new_game_control = ""
	hovered_portrait_key = ""
	hovered_continue_night = 0
	hovered_mission_index = -1
	hovered_minigame_index = -1
	held_event = ""
	held_time = 0.0
	held_repeat_elapsed = 0.0


func _button_rect(button: Dictionary) -> Rect2:
	return Rect2(float(button["x"]), float(button["y"]), float(button["w"]), float(button["h"]))


func _centered_rect(center: Vector2, size: Vector2) -> Rect2:
	return Rect2(center - (size * 0.5), size)


func _option_category_rect(category: Dictionary) -> Rect2:
	var slot_x := float(slots["options"]["x"])
	return Rect2(Vector2(slot_x + OPTIONS_CATEGORY_X_OFFSET, float(category["y"])), OPTIONS_CATEGORY_SIZE)


func _option_control_visible(control: Dictionary) -> bool:
	return str(control.get("category", "")) == options_category


func _option_control_y(row_index: int) -> float:
	return _option_row_y(row_index) + OPTIONS_ROW_CONTROL_Y_OFFSET


func _option_radio_center(radio: Dictionary) -> Vector2:
	if not radio.has("category"):
		return Vector2(float(radio["x"]), float(radio["y"]))
	var slot_x := float(slots["options"]["x"])
	var category_id := str(radio.get("category", ""))
	return Vector2(_option_toggle_center_x(slot_x, category_id), _option_control_y(int(radio.get("row", 0))))


func _option_slider_center(slider: Dictionary) -> Vector2:
	if not slider.has("category"):
		return Vector2(float(slider["x"]), float(slider["y"]))
	var slot_x := float(slots["options"]["x"])
	var category_id := str(slider.get("category", ""))
	var value := _option_value_for_event(str(slider["event"]))
	var slider_x := _option_slider_center_x(slot_x, category_id, value, bool(slider["right"]))
	return Vector2(slider_x, _option_control_y(int(slider.get("row", 0))))


func _option_control_start_x(slot_x: float, category_id: String) -> float:
	return slot_x + OPTIONS_ROW_LABEL_X_OFFSET + _option_category_label_width(category_id) + OPTIONS_LABEL_CONTROL_GAP


func _option_toggle_center_x(slot_x: float, category_id: String) -> float:
	return _option_control_start_x(slot_x, category_id) + (RADIO_SIZE.x * 0.5)


func _option_value_left_x(slot_x: float, category_id: String) -> float:
	return _option_control_start_x(slot_x, category_id) + SLIDER_SIZE.x + OPTIONS_VALUE_SIDE_GAP


func _option_slider_center_x(slot_x: float, category_id: String, value: String, right: bool) -> float:
	var control_start := _option_control_start_x(slot_x, category_id)
	if not right:
		return control_start + (SLIDER_SIZE.x * 0.5)
	var value_width := _measure_text_width("cnsmall", value)
	return control_start + SLIDER_SIZE.x + OPTIONS_VALUE_SIDE_GAP + value_width + OPTIONS_VALUE_SIDE_GAP + (SLIDER_SIZE.x * 0.5)


func _option_category_label_width(category_id: String) -> float:
	var max_label_width := 0.0
	for radio in options_radios:
		if str(radio.get("category", "")) == category_id:
			max_label_width = max(max_label_width, _measure_text_width("cnsmall", _option_label_for_event(str(radio["event"]))))
	for slider in options_sliders:
		if str(slider.get("category", "")) == category_id:
			max_label_width = max(max_label_width, _measure_text_width("cnsmall", _option_label_for_event(str(slider["event"]))))
	return max_label_width


func _option_label_for_event(event_name: String) -> String:
	var base_event := event_name
	if base_event.ends_with("-1") or base_event.ends_with("+1"):
		base_event = base_event.substr(0, base_event.length() - 2)
	match base_event:
		"fullscreen":
			return GameState.t("fullscreen")
		"antialiasing":
			return GameState.t("anti_aliasing")
		"upscaler":
			return GameState.t("upscaling")
		"vsync":
			return GameState.t("vertical_sync")
		"perspective":
			return GameState.t("perspective_3d")
		"particles":
			return GameState.t("extra_particles")
		"performance_mode":
			return GameState.t("performance_mode")
		"mastervol":
			return GameState.t("sfx_volume")
		"musicvol":
			return GameState.t("music_volume")
		"babyscare":
			return GameState.t("disable_loud_scares")
		"language":
			return GameState.t("language")
		"phone_guy_voice":
			return GameState.t("phone_guy_voice")
		"hiderewards":
			return GameState.t("hide_office_rewards")
		"radar":
			return GameState.t("camera_radar")
		"toxicity_scale":
			return GameState.t("toxicity_scale")
		_:
			return base_event


func _option_value_for_event(event_name: String) -> String:
	var base_event := event_name
	if base_event.ends_with("-1") or base_event.ends_with("+1"):
		base_event = base_event.substr(0, base_event.length() - 2)
	match base_event:
		"antialiasing":
			return "0x" if GameState.antialiasing <= 0 else str(int(pow(2.0, GameState.antialiasing))) + "x"
		"upscaler":
			return GameState.upscaler_label()
		"mastervol":
			return _volume_bars(GameState.mastervol)
		"musicvol":
			return _volume_bars(GameState.musicvol)
		"language":
			return GameState.language_label()
		"phone_guy_voice":
			return GameState.phone_guy_voice_label()
		_:
			return ""


func _world_mouse() -> Vector2:
	var mouse := get_viewport().get_mouse_position()
	return Vector2(mouse.x + camx, mouse.y)


func _hovered_custom_control(world_mouse: Vector2) -> String:
	hovered_portrait_key = ""
	if Rect2(1206.0, 608.0, 176.0, 64.0).has_point(world_mouse):
		return "start"
	for button in custom_group_buttons:
		var group_rect := Rect2(Vector2(float(button["x"]), float(button["y"])), Vector2(float(button["w"]), float(button["h"])))
		if group_rect.has_point(world_mouse):
			return "group:" + str(button["event"])
	for radio in custom_radios:
		if _centered_rect(Vector2(float(radio["x"]), float(radio["y"])), RADIO_SIZE).has_point(world_mouse):
			return "radio:" + str(radio["event"])
	for slider in custom_sliders:
		if _centered_rect(Vector2(float(slider["x"]), float(slider["y"])), SLIDER_SIZE).has_point(world_mouse) and _custom_slider_active(str(slider["event"])):
			return "slider:" + str(slider["event"])
	for portrait in custom_portraits:
		var pos := Vector2(float(portrait["x"]), float(portrait["y"]))
		if Rect2(pos, Vector2(105.0, 150.0)).has_point(world_mouse):
			hovered_portrait_key = str(portrait["key"])
			if _centered_rect(pos + Vector2(27.0, AI_BUTTON_LOCAL_Y), AI_BUTTON_SIZE).has_point(world_mouse):
				return "ai:ai-1"
			if _centered_rect(pos + Vector2(77.0, AI_BUTTON_LOCAL_Y), AI_BUTTON_SIZE).has_point(world_mouse):
				return "ai:ai+1"
			return "portrait:" + hovered_portrait_key
	return ""


func _hovered_options_control(world_mouse: Vector2) -> String:
	if Rect2(1296.0, 624.0, 304.0, 48.0).has_point(world_mouse):
		return "default_options"
	for category in options_categories:
		if _option_category_rect(category).has_point(world_mouse):
			return "category:" + str(category["id"])
	for radio in options_radios:
		if _option_control_visible(radio) and _centered_rect(_option_radio_center(radio), RADIO_SIZE).has_point(world_mouse):
			return "radio:" + str(radio["event"])
	for slider in options_sliders:
		if _option_control_visible(slider) and _centered_rect(_option_slider_center(slider), SLIDER_SIZE).has_point(world_mouse) and _options_slider_active(str(slider["event"])):
			return "slider:" + str(slider["event"])
	return ""


func _hovered_extras_control(world_mouse: Vector2) -> String:
	for button in extras_buttons:
		if _button_rect(button).has_point(world_mouse):
			return str(button["id"])
	return ""


func _hovered_mission_index(world_mouse: Vector2) -> int:
	for mission_index in range(GameState.mission_count()):
		if _mission_rect(mission_index).has_point(world_mouse):
			return mission_index
	return -1


func _hovered_minigame_index(world_mouse: Vector2) -> int:
	for minigame_index in range(GameState.minigame_count()):
		if _minigame_rect(minigame_index).has_point(world_mouse):
			return minigame_index
	return -1


func _hovered_new_game_control(world_mouse: Vector2) -> String:
	for control_name in new_game_buttons.keys():
		if new_game_buttons[control_name].has_point(world_mouse):
			return str(control_name)
	return ""


func _hovered_continue_night(world_mouse: Vector2) -> int:
	for night_number in range(1, 7):
		if _continue_night_rect(night_number).has_point(world_mouse) and GameState.story_night_unlocked(night_number):
			return night_number
	return 0


func _should_play_custom_hover(next_custom: String) -> bool:
	return next_custom != hovered_custom_control and _is_custom_hover_sound(next_custom)


func _should_play_options_hover(next_options: String) -> bool:
	return next_options != hovered_options_control and _is_options_hover_sound(next_options)


func _is_custom_hover_sound(control: String) -> bool:
	return control == "start" or control.begins_with("group:") or control.begins_with("portrait:")


func _is_options_hover_sound(control: String) -> bool:
	return control == "default_options" or control.begins_with("category:")


func _handle_custom_click(world_pos: Vector2) -> bool:
	var control := _hovered_custom_control(world_pos)
	if control == "":
		return false
	if control == "start":
		select_player.play()
		GameState.start_custom_night()
		GameState.change_scene_to_night_intro()
		return true
	if control.begins_with("group:"):
		select_player.play()
		_apply_group_event(control.substr(6))
		return true
	if control.begins_with("radio:"):
		_play_click()
		_apply_menu_event(control.substr(6))
		return true
	if control.begins_with("slider:"):
		_play_click()
		var event_name := control.substr(7)
		_apply_menu_event(event_name)
		held_event = event_name
		held_time = 0.0
		held_repeat_elapsed = 0.0
		return true
	if control.begins_with("ai:"):
		_play_click()
		var ai_event := control.substr(3)
		_apply_menu_event(ai_event)
		held_event = ai_event
		held_time = 0.0
		held_repeat_elapsed = 0.0
		return true
	return false


func _handle_continue_click(world_pos: Vector2) -> bool:
	var night_number := _hovered_continue_night(world_pos)
	if night_number <= 0:
		return false
	select_player.play()
	GameState.start_story_night(night_number)
	GameState.change_scene_to_night_intro()
	return true


func _handle_new_game_click(world_pos: Vector2) -> bool:
	var control := _hovered_new_game_control(world_pos)
	if control == "":
		return false
	select_player.play()
	if control == "yes":
		GameState.start_new_story()
		GameState.change_scene_to_night_intro()
	else:
		_set_target_slot("main")
	return true


func _handle_options_click(world_pos: Vector2) -> bool:
	var control := _hovered_options_control(world_pos)
	if control == "":
		return false
	if control == "default_options":
		select_player.play()
		GameState.reset_options_defaults()
		_sync_audio_volume()
		return true
	if control.begins_with("category:"):
		select_player.play()
		options_category = control.substr(9)
		held_event = ""
		held_time = 0.0
		held_repeat_elapsed = 0.0
		return true
	if control.begins_with("radio:"):
		_play_click()
		_apply_menu_event(control.substr(6))
		return true
	if control.begins_with("slider:"):
		_play_click()
		var event_name := control.substr(7)
		_apply_menu_event(event_name)
		held_event = event_name
		held_time = 0.0
		held_repeat_elapsed = 0.0
		return true
	return false


func _handle_extras_click(world_pos: Vector2) -> bool:
	var control := _hovered_extras_control(world_pos)
	if control == "":
		return false
	select_player.play()
	match control:
		"custom":
			GameState.reset_custom_night_defaults()
			_set_target_slot("custom")
		"survival":
			GameState.start_survival_mode()
			GameState.change_scene_to_night_intro()
		"random":
			GameState.start_random_mode()
			GameState.change_scene_to_night_intro()
		"missions":
			_set_target_slot("missions")
		"minigames":
			_set_target_slot("minigames")
	return true


func _handle_missions_click(world_pos: Vector2) -> bool:
	var mission_index := _hovered_mission_index(world_pos)
	if mission_index < 0:
		return false
	select_player.play()
	GameState.start_mission(mission_index)
	GameState.change_scene_to_night_intro()
	return true


func _handle_minigames_click(world_pos: Vector2) -> bool:
	var minigame_index := _hovered_minigame_index(world_pos)
	if minigame_index < 0:
		return false
	select_player.play()
	GameState.start_minigame(minigame_index)
	GameState.change_scene_to_minigame()
	return true


func _play_click() -> void:
	if click_player != null:
		click_player.play()


func _sync_audio_volume() -> void:
	if hover_player != null:
		hover_player.volume_db = GameState.volume_db(GameState.mastervol)
	if select_player != null:
		select_player.volume_db = GameState.volume_db(GameState.mastervol)
	if click_player != null:
		click_player.volume_db = GameState.volume_db(GameState.mastervol)
	if music_player != null:
		music_player.volume_db = GameState.volume_db(GameState.musicvol)


func _apply_group_event(event_name: String) -> void:
	if event_name == "randomize":
		GameState.randomize_custom_night()
		return
	var amount := 0
	if event_name == "all_11":
		amount = 11
	elif event_name == "all_1":
		amount = 1
	elif event_name == "all_-1":
		amount = -1
	var ai_keys := ["lvl_tf", "lvl_tb", "lvl_tc", "lvl_tx", "lvl_bb", "lvl_wf", "lvl_wb", "lvl_wc", "lvl_wx", "lvl_gf"]
	for ai_key in ai_keys:
		if abs(amount) == 1:
			_set_state_value(ai_key, clamp(_state_value(ai_key) + amount, 0, 11))
		else:
			_set_state_value(ai_key, clamp(amount, 0, 11))


func _apply_menu_event(event_name: String) -> void:
	match event_name:
		"mod_music", "mod_auto", "mod_perma", "mod_insta", "fullscreen", "vsync", "perspective", "particles", "performance_mode", "babyscare", "hiderewards", "radar", "toxicity_scale":
			_set_state_value(event_name, not bool(GameState.get(event_name)))
			if _is_options_event(event_name):
				GameState.save_options()
				GameState.apply_options()
				_sync_audio_volume()
		"lvl_pp":
			GameState.lvl_pp = 0 if GameState.lvl_pp > 0 else 1
		"lvl_duration-1":
			GameState.lvl_duration = max(GameState.lvl_duration - 1, -5)
		"lvl_duration+1":
			GameState.lvl_duration = min(GameState.lvl_duration + 1, 54)
		"lvl_battery-1":
			GameState.lvl_battery = max(GameState.lvl_battery - 1, -100)
		"lvl_battery+1":
			GameState.lvl_battery = min(GameState.lvl_battery + 1, 100)
		"lvl_toxic-1":
			GameState.lvl_toxic = max(GameState.lvl_toxic - 1, -2)
		"lvl_toxic+1":
			GameState.lvl_toxic = min(GameState.lvl_toxic + 1, 2)
		"lvl_usage-1":
			GameState.lvl_usage = max(GameState.lvl_usage - 1, -2)
		"lvl_usage+1":
			GameState.lvl_usage = min(GameState.lvl_usage + 1, 2)
		"ai-1":
			if hovered_portrait_key != "":
				_set_state_value(hovered_portrait_key, clamp(_state_value(hovered_portrait_key) - 1, 0, 11))
		"ai+1":
			if hovered_portrait_key != "":
				_set_state_value(hovered_portrait_key, clamp(_state_value(hovered_portrait_key) + 1, 0, 11))
		"antialiasing-1":
			GameState.antialiasing = max(GameState.antialiasing - 1, 0)
			_save_apply_options()
		"antialiasing+1":
			GameState.antialiasing = min(GameState.antialiasing + 1, 3)
			_save_apply_options()
		"upscaler-1":
			GameState.upscaler = max(GameState.upscaler - 1, 0)
			_save_apply_options()
		"upscaler+1":
			GameState.upscaler = min(GameState.upscaler + 1, 3)
			_save_apply_options()
		"language-1":
			GameState.cycle_language(-1)
			_save_apply_options()
		"language+1":
			GameState.cycle_language(1)
			_save_apply_options()
		"mastervol-1":
			GameState.mastervol = max(GameState.mastervol - 10, 0)
			_save_apply_options()
		"mastervol+1":
			GameState.mastervol = min(GameState.mastervol + 10, 100)
			_save_apply_options()
		"musicvol-1":
			GameState.musicvol = max(GameState.musicvol - 10, 0)
			_save_apply_options()
		"musicvol+1":
			GameState.musicvol = min(GameState.musicvol + 10, 100)
			_save_apply_options()
		"phone_guy_voice-1":
			GameState.cycle_phone_guy_voice(-1)
			_save_apply_options()
		"phone_guy_voice+1":
			GameState.cycle_phone_guy_voice(1)
			_save_apply_options()


func _save_apply_options() -> void:
	GameState.save_options()
	GameState.apply_options()
	_sync_render_backend()
	_sync_audio_volume()


func _is_options_event(event_name: String) -> bool:
	return ["fullscreen", "vsync", "perspective", "particles", "performance_mode", "babyscare", "hiderewards", "radar", "toxicity_scale"].has(event_name)


func _state_value(key: String) -> int:
	return int(GameState.get(key))


func _set_state_value(key: String, value: Variant) -> void:
	GameState.set(key, value)


func _custom_slider_active(event_name: String) -> bool:
	match event_name:
		"lvl_duration-1":
			return GameState.lvl_duration > -5
		"lvl_duration+1":
			return GameState.lvl_duration < 54
		"lvl_battery-1":
			return GameState.lvl_battery > -100
		"lvl_battery+1":
			return GameState.lvl_battery < 100
		"lvl_toxic-1":
			return GameState.lvl_toxic > -2
		"lvl_toxic+1":
			return GameState.lvl_toxic < 2
		"lvl_usage-1":
			return GameState.lvl_usage > -2
		"lvl_usage+1":
			return GameState.lvl_usage < 2
	return false


func _options_slider_active(event_name: String) -> bool:
	match event_name:
		"antialiasing-1":
			return GameState.antialiasing > 0
		"antialiasing+1":
			return GameState.antialiasing < 3
		"upscaler-1":
			return GameState.upscaler > 0
		"upscaler+1":
			return GameState.upscaler < 3
		"language-1", "language+1":
			return true
		"mastervol-1":
			return GameState.mastervol > 0
		"mastervol+1":
			return GameState.mastervol < 100
		"musicvol-1":
			return GameState.musicvol > 0
		"musicvol+1":
			return GameState.musicvol < 100
		"phone_guy_voice-1", "phone_guy_voice+1":
			return true
	return false


func _draw_to_layer(draw_kind: int, canvas: CanvasItem) -> void:
	active_canvas = canvas
	if draw_kind == DRAW_LAYER_BACKGROUND:
		_draw_normal_background()
	elif draw_kind == DRAW_LAYER_ADDITIVE:
		_draw_additive_lighting()
	elif draw_kind == DRAW_LAYER_UI:
		_draw_menu_ui()
	active_canvas = null


func _draw_menu_ui() -> void:
	_draw_main_slot()
	_draw_new_game_slot()
	_draw_extras_slot()
	_draw_missions_slot()
	_draw_minigames_slot()
	_draw_custom_slot()
	_draw_options_slot()
	_draw_continue_slot()
	_draw_credits_slot()
	_draw_stub_slots()
	_draw_beta_notice()


func _background_motion() -> Vector2:
	return Vector2(sin(elapsed_ms / 2400.0) * 25.0, cos(elapsed_ms / 3200.0) * 12.0)


func _draw_normal_background() -> void:
	var motion := _background_motion()
	var bg_pos := bg_base + motion
	_draw_sprite(menu_bg, bg_pos, Vector2.ONE, Vector2.ZERO, 1.0)
	if hovered_button >= 0:
		var hallway_frame: int = clamp(int(main_buttons[hovered_button]["subimg"]), 0, menu_hallway.size() - 1)
		_draw_sprite(menu_hallway[hallway_frame], Vector2(1386.0, -50.0) + motion, Vector2.ONE, Vector2.ZERO, 1.0)


func _draw_additive_lighting() -> void:
	var motion := _background_motion()
	if hovered_button >= 0:
		_draw_sprite_tinted(menu_flashvol, Vector2(945.0, 58.0) + motion, Vector2(2.0, 2.0), Vector2.ZERO, COLOR_WHITE)
	_draw_sprite_tinted(menu_lampvol, bg_base + motion, Vector2(2.0, 2.0), Vector2.ZERO, Color(COLOR_LAMP.r, COLOR_LAMP.g, COLOR_LAMP.b, fog_alpha))


func _draw_main_slot() -> void:
	var alpha := float(slots["main"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["main"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(2.0, 2.0), Vector2(30.0, 0.0), alpha)
	_draw_sprite(menu_openlogo, Vector2(slot_x + 70.0, 110.0), Vector2.ONE, Vector2.ZERO, alpha)
	_draw_text("footer", Vector2(slot_x + 70.0, 650.0), GameState.footer, COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_terminal(alpha)
	for i in range(main_buttons.size()):
		_draw_main_button(i, alpha)


func _draw_terminal(alpha: float) -> void:
	var rect := Rect2(776.0 - camx, 68.0, 536.0, 32.0)
	if terminal_hovered:
		_canvas().draw_rect(rect, Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha))
	var underscore := "_" if (int(elapsed_ms / 1000.0) % 2) == 0 else ""
	_draw_text("terminal", Vector2(792.0, 84.0), "> ANOTHER-FNAF-FANGAME" + underscore, COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_main_button(index: int, slot_alpha: float) -> void:
	var button: Dictionary = main_buttons[index]
	var alpha: float = slot_alpha if bool(button["enabled"]) else max(slot_alpha - 0.5, 0.0)
	var rect := Rect2(float(button["x"]) - camx, float(button["y"]), float(button["w"]), float(button["h"]))
	if hovered_button == index:
		_canvas().draw_rect(rect, Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * slot_alpha))
		_draw_text("menubt", Vector2(float(button["x"]) + 32.0, float(button["y"]) + (float(button["h"]) / 2.0) + 3.0), ">", COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_MIDDLE)
	_draw_text("menubt", Vector2(float(button["x"]) + 64.0 + (8.0 if hovered_button == index else 0.0), float(button["y"]) + (float(button["h"]) / 2.0) + 3.0), _main_button_label(button), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _main_button_label(button: Dictionary) -> String:
	match str(button["target"]):
		"new_game":
			return GameState.t("main_new_game")
		"continue":
			return GameState.t("main_continue")
		"custom":
			return GameState.t("main_custom")
		"extras":
			return GameState.t("main_extras")
		"options":
			return GameState.t("main_options")
		"credits":
			return GameState.t("main_credits")
		"quit":
			return GameState.t("main_quit")
		_:
			return str(button["label"])


func _draw_stub_slots() -> void:
	for slot_name in slots.keys():
		if slot_name == "main" or slot_name == "new_game" or slot_name == "custom" or slot_name == "extras" or slot_name == "missions" or slot_name == "minigames" or slot_name == "options" or slot_name == "continue" or slot_name == "credits":
			continue
		var alpha := float(slots[slot_name]["alpha"])
		if alpha <= 0.0:
			continue
		var slot_x := float(slots[slot_name]["x"])
		_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(2.0, 2.0), Vector2(30.0, 0.0), alpha)
		_draw_text("menubt", Vector2(slot_x + 70.0, 110.0), _slot_title(slot_name), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
		_draw_text("footer", Vector2(slot_x + 70.0, 650.0), GameState.t("stub_next"), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
		if back_buttons.has(slot_name):
			_draw_back_button(slot_name, alpha)


func _draw_credits_slot() -> void:
	var alpha := float(slots["credits"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["credits"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(4.0, 2.0), Vector2.ZERO, alpha)
	_draw_text("cnbt", Vector2(slot_x + 1232.0, 640.0), "Thank you for helping with the game!", COLOR_WHITE, alpha, HALIGN_RIGHT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 340.0, 128.0), "Props & Decorations Assistance", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 940.0, 128.0), "Drawings & Textures Assistance", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 340.0, 278.0), "Plush Models Assistance", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 940.0, 326.0), "Sound Effect Assistance", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 340.0, 428.0), "Character Models by", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 940.0, 428.0), "Music By", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 640.0, 538.0), "Perspective Shader and Additional Extensions by", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 640.0, 50.0), "AFF:OS is a fangame developed by Phil \"Phisnom\" Morg, made as a GameMaker Studio 2 test project.\n\"Five Nights at Freddy's\" is owned by Scott Cawthon.", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 340.0, 160.0), "TheManiacMartian\navnustu9\nMikel", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 940.0, 160.0), "UracilFeline\nGreenlight\nARuarkGuy\navnustu9\nEverythingAnimations\nConstaChymic", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 940.0, 160.0), "\n\n\n\n\n\nOmega    ", COLOR_OMEGA, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 946.0, 160.0), "\n\n\n\n\n\n    wott", COLOR_WOTT, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 340.0, 310.0), "TigeraRainbowra\nMrNobody1987\nMikel\nGosk\navnustu9", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 940.0, 356.0), "avnustu9", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 340.0, 460.0), "Scott Cawthon, Steelwool and Illumix\nPorts by Thudner", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 940.0, 460.0), "Emneisium\nMidnight in the Graveyard by Twin Musicom (twinmusicom.org)", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 640.0, 570.0), "ConstaChymic", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 640.0, 594.0), "Open Source Fork by", COLOR_GRAY, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 640.0, 612.0), "BlendRed", COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_credit_dude("tb", Vector2(slot_x + 106.0, 122.0), alpha)
	_draw_credit_dude("wf", Vector2(slot_x + 708.0, 122.0), alpha)
	_draw_credit_dude("tx", Vector2(slot_x + 147.0, 273.0), alpha)
	_draw_credit_dude("wc", Vector2(slot_x + 752.0, 321.0), alpha)
	_draw_credit_dude("wx", Vector2(slot_x + 178.0, 422.0), alpha)
	_draw_credit_dude("tf", Vector2(slot_x + 846.0, 422.0), alpha)
	_draw_credit_dude("bb", Vector2(slot_x + 290.0, 531.0), alpha)
	_draw_credit_dude("pp", Vector2(slot_x + 962.0, 531.0), alpha)
	if back_buttons.has("credits"):
		_draw_back_button("credits", alpha)


func _draw_credit_dude(sprite_name: String, world_position: Vector2, alpha: float) -> void:
	if not credit_dudes.has(sprite_name):
		return
	_draw_sprite(credit_dudes[sprite_name], world_position, Vector2.ONE, Vector2.ZERO, alpha)


func _draw_new_game_slot() -> void:
	var alpha := float(slots["new_game"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["new_game"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(2.0, 2.0), Vector2(30.0, 0.0), alpha)
	_draw_text("menubt", Vector2(slot_x + 70.0, 110.0), GameState.t("new_game_title"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 70.0, 188.0), GameState.t("new_game_confirm"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_new_game_choice_button("yes", GameState.t("yes"), alpha)
	_draw_new_game_choice_button("no", GameState.t("no"), alpha)
	if back_buttons.has("new_game"):
		_draw_back_button("new_game", alpha)


func _draw_new_game_choice_button(control_name: String, label: String, alpha: float) -> void:
	if not new_game_buttons.has(control_name):
		return
	var rect_world: Rect2 = new_game_buttons[control_name]
	var rect_screen := Rect2(rect_world.position - Vector2(camx, 0.0), rect_world.size)
	var hovered := hovered_new_game_control == control_name
	if hovered:
		_canvas().draw_rect(rect_screen, Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha))
		_draw_text("cnbt", rect_world.position + Vector2(22.0, (rect_world.size.y / 2.0) + 3.0), ">", COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)
	_canvas().draw_rect(rect_screen, Color(1.0, 1.0, 1.0, 0.65 * alpha), false, 1.0)
	_draw_text("cnbt", rect_world.position + Vector2(52.0 + (8.0 if hovered else 0.0), (rect_world.size.y / 2.0) + 3.0), label, COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_extras_slot() -> void:
	var alpha := float(slots["extras"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["extras"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(4.0, 2.0), Vector2.ZERO, alpha)
	_draw_text("menubt", Vector2(slot_x + 96.0, 70.0), GameState.t("extras_title"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	for button in extras_buttons:
		_draw_extras_button(button, alpha)
	if back_buttons.has("extras"):
		_draw_back_button("extras", alpha)


func _draw_extras_button(button: Dictionary, alpha: float) -> void:
	var rect_world := _button_rect(button)
	var rect_screen := Rect2(rect_world.position - Vector2(camx, 0.0), rect_world.size)
	var hovered := hovered_extras_control == str(button["id"])
	var fill_color := Color(0.02, 0.02, 0.02, 0.50 * alpha)
	if hovered:
		fill_color = Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha)
	_canvas().draw_rect(rect_screen, fill_color, true)
	_canvas().draw_rect(rect_screen, Color(1.0, 1.0, 1.0, 0.70 * alpha), false, 1.0)
	if hovered:
		_draw_text("cnsmall", rect_world.position + Vector2(24.0, 17.0), ">", COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", rect_world.position + Vector2(52.0 + (8.0 if hovered else 0.0), 17.0), GameState.t(str(button["label_key"])), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("smaller", rect_world.position + Vector2(52.0, 44.0), GameState.t(str(button["desc_key"])), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)


func _draw_missions_slot() -> void:
	var alpha := float(slots["missions"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["missions"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(5.0, 2.0), Vector2.ZERO, alpha)
	_draw_text("menubt", Vector2(slot_x + 66.0, 80.0), GameState.t("missions_title"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("footer", Vector2(slot_x + 72.0, 112.0), GameState.t("missions_select"), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	for mission_index in range(GameState.mission_count()):
		_draw_mission_button(mission_index, alpha)
	if hovered_mission_index >= 0:
		_draw_mission_preview(slot_x, alpha, hovered_mission_index)
	if back_buttons.has("missions"):
		_draw_back_button("missions", alpha)


func _draw_mission_preview(slot_x: float, alpha: float, mission_index: int) -> void:
	_draw_text("menubt", Vector2(slot_x + 740.0, 80.0), GameState.t("ai_difficulty"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 840.0, 148.0), GameState.t("the_toys"), COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 840.0, 360.0), GameState.t("the_withereds"), COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	for portrait in custom_portraits:
		_draw_mission_portrait(portrait, alpha, mission_index)
	_draw_text("cnsmall", Vector2(slot_x + 949.0, 561.0), GameState.t("enable_puppet"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_radio_button({"event": "lvl_pp", "x": slot_x + 1210.0, "y": 572.0}, alpha, true, _mission_puppet_frame(mission_index), false)
	_draw_text("footer", Vector2(slot_x + 72.0, 552.0), GameState.mission_description(mission_index), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("footer", Vector2(slot_x + 640.0, 640.0), GameState.t("difficulty_note"), COLOR_GRAY, alpha, HALIGN_CENTER, VALIGN_TOP)


func _mission_rect(mission_index: int) -> Rect2:
	var slot_x := float(slots["missions"]["x"])
	return Rect2(Vector2(slot_x + 72.0, 140.0 + (float(mission_index) * 40.0)), Vector2(392.0, 34.0))


func _draw_mission_button(mission_index: int, alpha: float) -> void:
	var rect_world := _mission_rect(mission_index)
	var hovered := hovered_mission_index == mission_index
	var rect_screen := Rect2(rect_world.position - Vector2(camx, 0.0), rect_world.size)
	var fill_color := Color(0.02, 0.02, 0.02, 0.50 * alpha)
	if hovered:
		fill_color = Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha)
	_canvas().draw_rect(rect_screen, fill_color, true)
	_canvas().draw_rect(rect_screen, Color(1.0, 1.0, 1.0, (0.70 if hovered else 0.32) * alpha), false, 1.0)
	if hovered:
		_draw_text("cnsmall", rect_world.position + Vector2(16.0, 19.0), ">", COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)
	_draw_text("cnsmall", rect_world.position + Vector2(42.0 + (6.0 if hovered else 0.0), 19.0), GameState.mission_title(mission_index), COLOR_WHITE if hovered else COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_minigames_slot() -> void:
	var alpha := float(slots["minigames"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["minigames"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(4.0, 2.0), Vector2.ZERO, alpha)
	_draw_text("menubt", Vector2(slot_x + 66.0, 80.0), GameState.t("minigames_title"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("footer", Vector2(slot_x + 72.0, 112.0), GameState.t("minigames_select"), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	for minigame_index in range(GameState.minigame_count()):
		_draw_minigame_button(minigame_index, alpha)
	if hovered_minigame_index >= 0:
		_draw_minigame_preview(slot_x, alpha, hovered_minigame_index)
	if back_buttons.has("minigames"):
		_draw_back_button("minigames", alpha)


func _minigame_rect(minigame_index: int) -> Rect2:
	var slot_x := float(slots["minigames"]["x"])
	return Rect2(Vector2(slot_x + 72.0, 164.0 + (float(minigame_index) * 76.0)), Vector2(472.0, 58.0))


func _draw_minigame_button(minigame_index: int, alpha: float) -> void:
	var rect_world := _minigame_rect(minigame_index)
	var hovered := hovered_minigame_index == minigame_index
	var rect_screen := Rect2(rect_world.position - Vector2(camx, 0.0), rect_world.size)
	var fill_color := Color(0.02, 0.02, 0.02, 0.50 * alpha)
	if hovered:
		fill_color = Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha)
	_canvas().draw_rect(rect_screen, fill_color, true)
	_canvas().draw_rect(rect_screen, Color(1.0, 1.0, 1.0, (0.70 if hovered else 0.32) * alpha), false, 1.0)
	if hovered:
		_draw_text("cnsmall", rect_world.position + Vector2(16.0, 29.0), ">", COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)
	_draw_text("cnsmall", rect_world.position + Vector2(42.0 + (6.0 if hovered else 0.0), 29.0), GameState.minigame_title(minigame_index), COLOR_WHITE if hovered else COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_minigame_preview(slot_x: float, alpha: float, minigame_index: int) -> void:
	var title := GameState.minigame_title(minigame_index)
	var desc := GameState.minigame_description(minigame_index)
	_draw_text("menubt", Vector2(slot_x + 680.0, 164.0), title, COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 684.0, 228.0), desc, COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("smaller", Vector2(slot_x + 684.0, 344.0), GameState.t("minigame_controls"), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_minigame_preview_art(slot_x, alpha, minigame_index)


func _draw_minigame_preview_art(slot_x: float, alpha: float, minigame_index: int) -> void:
	var base := Vector2(slot_x + 710.0, 424.0)
	var color_a := Color(0.85, 0.85, 0.85, alpha)
	var color_b := Color(0.5, 0.0, 0.8, alpha)
	var color_c := Color(0.95, 0.75, 0.2, alpha)
	match str(GameState.minigame_preset(minigame_index).get("id", "")):
		"give_gifts":
			_canvas().draw_rect(Rect2(base + Vector2(0.0, 44.0), Vector2(42.0, 64.0)), color_b, true)
			for i in range(4):
				_canvas().draw_rect(Rect2(base + Vector2(96.0 + float(i) * 62.0, 52.0), Vector2(28.0, 44.0)), color_a, true)
				_canvas().draw_rect(Rect2(base + Vector2(92.0 + float(i) * 62.0, 102.0), Vector2(36.0, 16.0)), color_c, true)
		"foxy_go":
			_canvas().draw_rect(Rect2(base + Vector2(0.0, 58.0), Vector2(64.0, 42.0)), Color(0.75, 0.16, 0.06, alpha), true)
			_canvas().draw_rect(Rect2(base + Vector2(210.0, 60.0), Vector2(30.0, 46.0)), color_a, true)
			_canvas().draw_rect(Rect2(base + Vector2(270.0, 60.0), Vector2(30.0, 46.0)), color_a, true)
			_canvas().draw_line(base + Vector2(88.0, 80.0), base + Vector2(188.0, 80.0), color_c, 5.0)
		_:
			_canvas().draw_rect(Rect2(base + Vector2(0.0, 54.0), Vector2(44.0, 54.0)), Color(0.55, 0.28, 0.1, alpha), true)
			for i in range(5):
				_canvas().draw_rect(Rect2(base + Vector2(112.0 + float(i) * 46.0, 58.0), Vector2(24.0, 42.0)), color_a, true)
			_canvas().draw_rect(Rect2(base + Vector2(286.0, 110.0), Vector2(76.0, 22.0)), color_b, true)


func _mission_portrait_position(portrait: Dictionary) -> Vector2:
	var custom_slot_x := float(slots["custom"]["x"])
	var mission_slot_x := float(slots["missions"]["x"])
	return Vector2(mission_slot_x + (float(portrait["x"]) - custom_slot_x), float(portrait["y"]))


func _draw_mission_portrait(portrait: Dictionary, alpha: float, mission_index: int) -> void:
	var sprite_name := str(portrait["sprite"])
	if not portrait_textures.has(sprite_name):
		return
	var value := _mission_ai_value(mission_index, str(portrait["key"]))
	var frame: int = 11 if value > 10 else clamp(value, 0, 10)
	var frames: Array = portrait_textures[sprite_name]
	var world_pos := _mission_portrait_position(portrait)
	_draw_sprite_tinted(frames[frame], world_pos, Vector2.ONE, Vector2.ZERO, Color(1.0, 1.0, 1.0, alpha))
	if value <= 10:
		_draw_text("cnbt", world_pos + Vector2(97.0, 5.0), str(value), COLOR_WHITE, alpha, HALIGN_RIGHT, VALIGN_TOP)
	elif portrait_star != null:
		_draw_sprite(portrait_star, world_pos + Vector2(97.0, 8.0), Vector2.ONE, PORTRAIT_STAR_ORIGIN, alpha)


func _mission_ai_value(mission_index: int, ai_key: String) -> int:
	var mission: Dictionary = GameState.mission_preset(mission_index)
	var ai: Dictionary = mission.get("ai", {})
	return clampi(int(ai.get(ai_key, 0)), 0, 11)


func _mission_puppet_frame(mission_index: int) -> int:
	var mission: Dictionary = GameState.mission_preset(mission_index)
	var ai: Dictionary = mission.get("ai", {})
	return 1 if int(ai.get("lvl_pp", 1)) > 0 else 0


func _draw_continue_slot() -> void:
	var alpha := float(slots["continue"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["continue"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(2.0, 2.0), Vector2(30.0, 0.0), alpha)
	_draw_text("menubt", Vector2(slot_x + 70.0, 110.0), GameState.t("continue_title"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("footer", Vector2(slot_x + 70.0, 150.0), GameState.t("continue_select"), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	for night_index in range(6):
		var night_number := night_index + 1
		_draw_continue_night_button(_continue_night_rect(night_number), night_number, alpha)
	_draw_text("footer", Vector2(slot_x + 70.0, 650.0), GameState.t("continue_locked_note"), COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)
	if back_buttons.has("continue"):
		_draw_back_button("continue", alpha)


func _continue_night_rect(night_number: int) -> Rect2:
	var slot_x := float(slots["continue"]["x"])
	var night_index := night_number - 1
	var col: int = night_index % 2
	var row: int = int(float(night_index) / 2.0)
	return Rect2(Vector2(slot_x + 80.0 + (float(col) * 520.0), 210.0 + (float(row) * 104.0)), Vector2(440.0, 72.0))


func _draw_continue_night_button(rect_world: Rect2, night_number: int, alpha: float) -> void:
	var unlocked := GameState.story_night_unlocked(night_number)
	var hovered := hovered_continue_night == night_number
	var rect_screen := Rect2(rect_world.position - Vector2(camx, 0.0), rect_world.size)
	var fill_color := Color(0.02, 0.02, 0.02, 0.50 * alpha)
	if hovered:
		fill_color = Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha)
	_canvas().draw_rect(rect_screen, fill_color, true)
	_canvas().draw_rect(rect_screen, Color(1.0, 1.0, 1.0, (0.82 if unlocked else 0.38) * alpha), false, 1.0)
	_canvas().draw_rect(rect_screen.grow(1.0), Color(1.0, 1.0, 1.0, 0.24 * alpha), false, 1.0)
	var text_color := COLOR_WHITE if unlocked else COLOR_GRAY
	var label_pos := rect_world.position + Vector2(28.0 + (20.0 if hovered else 0.0), 21.0)
	if hovered:
		_draw_text("cnsmall", rect_world.position + Vector2(28.0, 21.0), ">", COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", label_pos, GameState.t("night") + " " + str(night_number), text_color, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", rect_world.position + Vector2(rect_world.size.x - 28.0, 21.0), GameState.t("ready") if unlocked else GameState.t("locked"), text_color, alpha, HALIGN_RIGHT, VALIGN_TOP)


func _slot_title(slot_name: String) -> String:
	match slot_name:
		"new_game":
			return GameState.t("main_new_game")
		"continue":
			return GameState.t("main_continue")
		"custom":
			return GameState.t("main_custom")
		"extras":
			return GameState.t("main_extras")
		"missions":
			return GameState.t("missions_title")
		"minigames":
			return GameState.t("minigames_title")
		"options":
			return GameState.t("main_options")
		"credits":
			return GameState.t("main_credits")
		"quit":
			return GameState.t("main_quit")
		_:
			return str(slots[slot_name]["title"])


func _draw_custom_slot() -> void:
	var alpha := float(slots["custom"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["custom"]["x"])
	var lvl_names := [GameState.t("lvl_none"), GameState.t("lvl_slow"), GameState.t("lvl_normal"), GameState.t("lvl_fast"), GameState.t("lvl_max")]
	var duration_text := str(GameState.lvl_duration + 6) + ("м" if GameState.is_ru() else "m")
	var battery_text := str(GameState.lvl_battery + 100) + "%"
	var toxic_text: String = lvl_names[clamp(GameState.lvl_toxic + 2, 0, lvl_names.size() - 1)]
	var usage_text: String = lvl_names[clamp(GameState.lvl_usage + 2, 0, lvl_names.size() - 1)]
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(5.0, 2.0), Vector2.ZERO, alpha)
	_draw_text("menubt", Vector2(slot_x + 66.0, 80.0), GameState.t("night_settings"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("menubt", Vector2(slot_x + 66.0, 360.0), GameState.t("game_mods"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("menubt", Vector2(slot_x + 740.0, 80.0), GameState.t("ai_difficulty"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 72.0, 132.0), GameState.t("shift_duration") + "\n\n" + GameState.t("battery_level") + "\n\n" + GameState.t("toxic_level") + "\n\n" + GameState.t("usage_level"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 72.0, 412.0), GameState.t("music_box_timer") + "\n\n" + GameState.t("auto_recharge") + "\n\n" + GameState.t("perma_toxicity") + "\n\n" + GameState.t("insta_scare"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 949.0, 561.0), GameState.t("enable_puppet"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 840.0, 148.0), GameState.t("the_toys"), COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 840.0, 360.0), GameState.t("the_withereds"), COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("footer", Vector2(slot_x + 640.0, 640.0), GameState.t("difficulty_note"), COLOR_GRAY, alpha, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(slot_x + 360.0, 132.0), duration_text + "\n\n" + battery_text + "\n\n" + toxic_text + "\n\n" + usage_text, COLOR_WHITE, alpha, HALIGN_CENTER, VALIGN_TOP)
	for portrait in custom_portraits:
		_draw_custom_portrait(portrait, alpha)
	for slider in custom_sliders:
		_draw_slider_button(slider, alpha, _custom_slider_active(str(slider["event"])), hovered_custom_control == "slider:" + str(slider["event"]))
	for radio in custom_radios:
		_draw_radio_button(radio, alpha, true, _custom_radio_frame(str(radio["event"])), hovered_custom_control == "radio:" + str(radio["event"]))
	for button in custom_group_buttons:
		_draw_group_button(button, alpha)
	_draw_start_button(alpha)
	if back_buttons.has("custom"):
		_draw_back_button("custom", alpha)


func _draw_options_slot() -> void:
	var alpha := float(slots["options"]["alpha"])
	if alpha <= 0.0:
		return
	var slot_x := float(slots["options"]["x"])
	_draw_sprite(menu_mainblack, Vector2(slot_x, 0.0), Vector2(4.0, 2.0), Vector2.ZERO, alpha)
	_draw_text("menubt", Vector2(slot_x + 96.0, 70.0), GameState.t("main_options"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	_draw_options_categories(alpha)
	_draw_options_category_content(slot_x, alpha)
	_draw_text("smaller", Vector2(slot_x + 1072.0, 678.0), GameState.t("press_hold"), COLOR_GRAY, alpha, HALIGN_CENTER, VALIGN_TOP)
	for radio in options_radios:
		if _option_control_visible(radio):
			_draw_radio_button(radio, alpha, true, _option_radio_frame(str(radio["event"])), hovered_options_control == "radio:" + str(radio["event"]))
	for slider in options_sliders:
		if _option_control_visible(slider):
			_draw_slider_button(slider, alpha, _options_slider_active(str(slider["event"])), hovered_options_control == "slider:" + str(slider["event"]))
	_draw_options_default_button(alpha)
	if back_buttons.has("options"):
		_draw_back_button("options", alpha)


func _draw_options_categories(alpha: float) -> void:
	for category in options_categories:
		_draw_options_category_button(category, alpha)


func _draw_options_category_button(category: Dictionary, alpha: float) -> void:
	var category_id := str(category["id"])
	var rect_world := _option_category_rect(category)
	var rect_screen := Rect2(rect_world.position - Vector2(camx, 0.0), rect_world.size)
	var active := options_category == category_id
	var hovered := hovered_options_control == "category:" + category_id
	var fill_alpha := 0.20 if active else 0.0
	if hovered:
		fill_alpha = 0.32
	if fill_alpha > 0.0:
		_canvas().draw_rect(rect_screen, Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, fill_alpha * alpha), true)
	_canvas().draw_rect(rect_screen, Color(1.0, 1.0, 1.0, (0.50 if active else 0.18) * alpha), false, 1.0)
	if active or hovered:
		_draw_text("cnsmall", rect_world.position + Vector2(18.0, 24.0), ">", COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)
	_draw_text("cnsmall", rect_world.position + Vector2(44.0 + (6.0 if hovered else 0.0), 24.0), GameState.t(str(category["label_key"])), COLOR_WHITE if active else COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_options_category_content(slot_x: float, alpha: float) -> void:
	match options_category:
		"audio":
			_draw_options_audio(slot_x, alpha)
		"language":
			_draw_options_language(slot_x, alpha)
		"gameplay":
			_draw_options_gameplay(slot_x, alpha)
		_:
			_draw_options_video(slot_x, alpha)


func _draw_options_video(slot_x: float, alpha: float) -> void:
	var aa := "0x" if GameState.antialiasing <= 0 else str(int(pow(2.0, GameState.antialiasing))) + "x"
	_draw_options_category_title(slot_x, alpha, "video_settings")
	_draw_option_row(slot_x, alpha, 0, GameState.t("fullscreen"))
	_draw_option_row(slot_x, alpha, 1, GameState.t("anti_aliasing"), aa)
	_draw_option_row(slot_x, alpha, 2, GameState.t("upscaling"), GameState.upscaler_label())
	_draw_option_row(slot_x, alpha, 3, GameState.t("vertical_sync"))
	_draw_option_row(slot_x, alpha, 4, GameState.t("perspective_3d"))
	_draw_option_row(slot_x, alpha, 5, GameState.t("extra_particles"))
	_draw_option_row(slot_x, alpha, 6, GameState.t("performance_mode"))


func _draw_options_audio(slot_x: float, alpha: float) -> void:
	_draw_options_category_title(slot_x, alpha, "audio_settings")
	_draw_option_row(slot_x, alpha, 0, GameState.t("sfx_volume"), _volume_bars(GameState.mastervol))
	_draw_option_row(slot_x, alpha, 1, GameState.t("music_volume"), _volume_bars(GameState.musicvol))
	_draw_option_row(slot_x, alpha, 2, GameState.t("disable_loud_scares"))


func _draw_options_language(slot_x: float, alpha: float) -> void:
	_draw_options_category_title(slot_x, alpha, "language_settings")
	_draw_option_row(slot_x, alpha, 0, GameState.t("language"), GameState.language_label())
	_draw_option_row(slot_x, alpha, 1, GameState.t("phone_guy_voice"), GameState.phone_guy_voice_label())


func _draw_options_gameplay(slot_x: float, alpha: float) -> void:
	_draw_options_category_title(slot_x, alpha, "gameplay_settings")
	_draw_option_row(slot_x, alpha, 0, GameState.t("hide_office_rewards"))
	_draw_option_row(slot_x, alpha, 1, GameState.t("camera_radar"))
	_draw_option_row(slot_x, alpha, 2, GameState.t("toxicity_scale"))
	_draw_text("smaller", Vector2(slot_x + OPTIONS_ROW_LABEL_X_OFFSET, _option_row_y(3)), GameState.t("cheat_disables_progress"), COLOR_RED if GameState.radar else COLOR_GRAY, alpha, HALIGN_LEFT, VALIGN_TOP)


func _draw_options_category_title(slot_x: float, alpha: float, label_key: String) -> void:
	_draw_text("menubt", Vector2(slot_x + OPTIONS_ROW_LABEL_X_OFFSET, 70.0), GameState.t(label_key), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)


func _draw_option_row(slot_x: float, alpha: float, row_index: int, label: String, value := "", value_color := COLOR_WHITE) -> void:
	var row_y := _option_row_y(row_index)
	_draw_text("cnsmall", Vector2(slot_x + OPTIONS_ROW_LABEL_X_OFFSET, row_y), label, COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_TOP)
	if value != "":
		_draw_text("cnsmall", Vector2(_option_value_left_x(slot_x, options_category), row_y), value, value_color, alpha, HALIGN_LEFT, VALIGN_TOP)


func _option_row_y(row_index: int) -> float:
	return OPTIONS_ROW_TOP + (float(row_index) * OPTIONS_ROW_STEP)


func _draw_custom_portrait(portrait: Dictionary, alpha: float) -> void:
	var sprite_name := str(portrait["sprite"])
	if not portrait_textures.has(sprite_name):
		return
	var key := str(portrait["key"])
	var value := _state_value(key)
	var frame: int = 11 if value > 10 else clamp(value, 0, 10)
	var frames: Array = portrait_textures[sprite_name]
	var world_pos := Vector2(float(portrait["x"]), float(portrait["y"]))
	_draw_sprite_tinted(frames[frame], world_pos, Vector2.ONE, Vector2.ZERO, Color(1.0, 1.0, 1.0, alpha))
	if value <= 10:
		_draw_text("cnbt", world_pos + Vector2(97.0, 5.0), str(value), COLOR_WHITE, alpha, HALIGN_RIGHT, VALIGN_TOP)
	elif portrait_star != null:
		_draw_sprite(portrait_star, world_pos + Vector2(97.0, 8.0), Vector2.ONE, PORTRAIT_STAR_ORIGIN, alpha)
	if hovered_portrait_key == key:
		_draw_portrait_selector(world_pos, alpha)
		_draw_ai_button(world_pos + Vector2(27.0, AI_BUTTON_LOCAL_Y), 0, hovered_custom_control == "ai:ai-1", alpha)
		_draw_ai_button(world_pos + Vector2(77.0, AI_BUTTON_LOCAL_Y), 1, hovered_custom_control == "ai:ai+1", alpha)


func _draw_portrait_selector(world_pos: Vector2, alpha: float) -> void:
	var screen_pos := world_pos - Vector2(camx, 0.0)
	var rect := Rect2(screen_pos, Vector2(105.0, 150.0))
	_canvas().draw_rect(rect, Color(1.0, 1.0, 1.0, max(sin(elapsed_ms / 100.0) * 0.2, 0.0) * alpha), true)
	_canvas().draw_rect(rect, Color(1.0, 1.0, 1.0, alpha), false, 1.0)
	_canvas().draw_rect(rect.grow(1.0), Color(1.0, 1.0, 1.0, alpha), false, 1.0)


func _draw_ai_button(world_pos: Vector2, frame: int, hovered: bool, alpha: float) -> void:
	if ai_buttons.is_empty():
		return
	_draw_sprite_tinted(ai_buttons[clamp(frame, 0, ai_buttons.size() - 1)], world_pos, Vector2.ONE * (1.1 if hovered else 1.0), AI_BUTTON_ORIGIN, Color(1.0, 1.0, 1.0, alpha))


func _draw_slider_button(slider: Dictionary, alpha: float, active: bool, hovered: bool) -> void:
	if slider_buttons.is_empty():
		return
	var frame := 1 if bool(slider["right"]) else 0
	var control_alpha: float = clamp(alpha - (0.0 if active else 0.5), 0.0, 1.0)
	var control_scale := Vector2.ONE * (1.1 if hovered else 1.0)
	_draw_sprite_tinted(slider_buttons[frame], _option_slider_center(slider), control_scale, SLIDER_ORIGIN, Color(1.0, 1.0, 1.0, control_alpha))


func _draw_radio_button(radio: Dictionary, alpha: float, active: bool, frame: int, hovered: bool) -> void:
	if radio_buttons.is_empty():
		return
	var control_alpha: float = clamp(alpha - (0.0 if active else 0.5), 0.0, 1.0)
	var control_scale := Vector2.ONE * (1.1 if hovered else 1.0)
	var texture := radio_buttons[clamp(frame, 0, radio_buttons.size() - 1)]
	_draw_sprite_tinted(texture, _option_radio_center(radio), control_scale, _texture_center_origin(texture, RADIO_ORIGIN), Color(1.0, 1.0, 1.0, control_alpha))


func _draw_group_button(button: Dictionary, alpha: float) -> void:
	var event_name := "group:" + str(button["event"])
	var world_rect := Rect2(Vector2(float(button["x"]), float(button["y"])), Vector2(float(button["w"]), float(button["h"])))
	if hovered_custom_control == event_name:
		_canvas().draw_rect(Rect2(world_rect.position - Vector2(camx, 0.0), world_rect.size), Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha))
	var label := str(button.get("label", GameState.t(str(button.get("label_key", "")))))
	_draw_text("cnsmall", world_rect.position + Vector2(13.0, (world_rect.size.y / 2.0) + 2.0), label, COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_start_button(alpha: float) -> void:
	var rect := Rect2(1206.0, 608.0, 176.0, 64.0)
	var hovered := hovered_custom_control == "start"
	if hovered:
		_canvas().draw_rect(Rect2(rect.position - Vector2(camx, 0.0), rect.size), Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha))
		_draw_text("cnbt", rect.position + Vector2(24.0, (rect.size.y / 2.0) + 3.0), ">", COLOR_YELLOW, 1.0, HALIGN_LEFT, VALIGN_MIDDLE)
	_draw_text("cnbt", rect.position + Vector2(44.0 + (8.0 if hovered else 0.0), (rect.size.y / 2.0) + 3.0), GameState.t("start"), COLOR_YELLOW if hovered else COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_options_default_button(alpha: float) -> void:
	var rect := Rect2(1296.0, 624.0, 304.0, 48.0)
	var hovered := hovered_options_control == "default_options"
	if hovered:
		_canvas().draw_rect(Rect2(rect.position - Vector2(camx, 0.0), rect.size), Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha))
	_draw_text("menubt", rect.position + Vector2(32.0, (rect.size.y / 2.0) + 3.0), GameState.t("default_settings"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _custom_radio_frame(event_name: String) -> int:
	match event_name:
		"lvl_pp":
			return clamp(GameState.lvl_pp, 0, 1)
		_:
			return 1 if bool(GameState.get(event_name)) else 0


func _option_radio_frame(event_name: String) -> int:
	return 1 if bool(GameState.get(event_name)) else 0


func _volume_bars(value: int) -> String:
	if value <= 0:
		return GameState.t("muted")
	var result := ""
	for i in range(int(ceil(value / 10.0))):
		result += "|"
	return result


func _draw_beta_notice() -> void:
	if beta_notice == null:
		return
	var notice_alpha := 0.08 if (int(elapsed_ms / 1000.0) % 2) == 0 else 0.05
	var notice_rect := Rect2(Vector2(920.0, 520.0), beta_notice.get_size() * 0.5)
	_canvas().draw_texture_rect(beta_notice, notice_rect, false, Color(1.0, 1.0, 1.0, notice_alpha))


func _draw_back_button(slot_name: String, alpha: float) -> void:
	var rect_world: Rect2 = back_buttons[slot_name]
	var rect_screen := Rect2(rect_world.position - Vector2(camx, 0.0), rect_world.size)
	if hovered_back_slot == slot_name:
		_canvas().draw_rect(rect_screen, Color(COLOR_HOVER.r, COLOR_HOVER.g, COLOR_HOVER.b, COLOR_HOVER.a * alpha))
		_draw_text("cnbt", rect_world.position + Vector2(24.0, (rect_world.size.y / 2.0) + 3.0), ">", COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_MIDDLE)
	_draw_text("cnbt", rect_world.position + Vector2(44.0 + (8.0 if hovered_back_slot == slot_name else 0.0), (rect_world.size.y / 2.0) + 3.0), GameState.t("back"), COLOR_WHITE, alpha, HALIGN_LEFT, VALIGN_MIDDLE)


func _draw_sprite(texture: Texture2D, world_position: Vector2, sprite_scale: Vector2, origin: Vector2, alpha: float) -> void:
	_draw_sprite_tinted(texture, world_position, sprite_scale, origin, Color(1.0, 1.0, 1.0, alpha))


func _draw_sprite_tinted(texture: Texture2D, world_position: Vector2, sprite_scale: Vector2, origin: Vector2, tint: Color) -> void:
	if texture == null:
		return
	var abs_scale := Vector2(abs(sprite_scale.x), abs(sprite_scale.y))
	var size := texture.get_size() * abs_scale
	var pos := world_position - (origin * sprite_scale) - Vector2(camx, 0.0)
	_canvas().draw_texture_rect(texture, Rect2(pos, size), false, tint)


func _load_menu_control_sprite(sprite_name: String) -> Texture2D:
	var svg_path := "res://assets/sprites/menu_controls/%s.svg" % sprite_name
	if ResourceLoader.exists(svg_path):
		return load(svg_path)
	var png_path := "res://assets/sprites/menu_controls/%s.png" % sprite_name
	if ResourceLoader.exists(png_path):
		return load(png_path)
	return null


func _texture_center_origin(texture: Texture2D, fallback_origin: Vector2) -> Vector2:
	if texture == null:
		return fallback_origin
	return texture.get_size() * 0.5


func _canvas() -> CanvasItem:
	return active_canvas if active_canvas != null else self


func _register_vector_font(font_key: String, size: int, line_step: int) -> void:
	font_data[font_key] = {"size": size, "line_step": line_step}


func _draw_text(font_key: String, world_position: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int) -> void:
	if not font_data.has(font_key):
		return
	var data: Dictionary = font_data[font_key]
	if fallback_font == null:
		return
	_draw_vector_text(font_key, data, world_position, text, color, alpha, halign, valign)


func _measure_text_width(font_key: String, text: String) -> float:
	if not font_data.has(font_key) or fallback_font == null:
		return 0.0
	var data: Dictionary = font_data[font_key]
	var font_size := _vector_font_size(data)
	var max_width := 0.0
	for line in text.split("\n"):
		var line_text := str(line)
		var cache_key := "%s:%d:%s" % [font_key, font_size, line_text]
		var line_width := 0.0
		if text_width_cache.has(cache_key):
			line_width = float(text_width_cache[cache_key])
		else:
			line_width = fallback_font.get_string_size(line_text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
			text_width_cache[cache_key] = line_width
		max_width = max(max_width, line_width)
	return max_width


func _vector_font_size(data: Dictionary) -> int:
	var line_step := float(data["line_step"])
	var base_font_size := float(data["size"])
	var visual_font_size := base_font_size + ((line_step - base_font_size) * 0.25)
	return int(max(round(visual_font_size), 8.0))


func _draw_vector_text(font_key: String, data: Dictionary, world_position: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int) -> void:
	var lines := text.split("\n")
	var line_step := float(data["line_step"])
	var font_size := _vector_font_size(data)
	var ascent := fallback_font.get_ascent(font_size)
	var start := world_position - Vector2(camx, 0.0) + Vector2(0.0, _vector_text_y_offset(font_key))
	if valign == VALIGN_MIDDLE:
		start.y -= (line_step * lines.size()) * 0.5
	var text_color := Color(color.r, color.g, color.b, color.a * alpha)
	for line_index in range(lines.size()):
		var line_text := str(lines[line_index])
		var cache_key := "%s:%d:%s" % [font_key, font_size, line_text]
		var line_width := 0.0
		if text_width_cache.has(cache_key):
			line_width = float(text_width_cache[cache_key])
		else:
			line_width = fallback_font.get_string_size(line_text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
			text_width_cache[cache_key] = line_width
		var x := start.x
		if halign == HALIGN_CENTER:
			x -= line_width * 0.5
		elif halign == HALIGN_RIGHT:
			x -= line_width
		var baseline := start.y + (float(line_index) * line_step) + ascent
		_canvas().draw_string(fallback_font, Vector2(x, baseline), line_text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, text_color)


func _vector_text_y_offset(font_key: String) -> float:
	return 2.0 if font_key == "menubt" else 3.0
