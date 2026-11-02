extends Node2D

const VIEW_W := 1280.0
const VIEW_H := 720.0
const TARGET_FPS := 60.0

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_GRAY := Color(0.5, 0.5, 0.5, 1.0)
const COLOR_BUTTON := Color(11.0 / 255.0, 13.0 / 255.0, 31.0 / 255.0, 0.45)
const HALIGN_LEFT := 0
const HALIGN_CENTER := 1
const HALIGN_RIGHT := 2
const VALIGN_TOP := 0
const VALIGN_MIDDLE := 1

var bg_texture: Texture2D
var mask_texture: Texture2D
var over_character_frames: Array[Texture2D] = []
var cctv_noise_frames: Array[Texture2D] = []
var font_data := {}
var fallback_font: FontFile
var hover_player: AudioStreamPlayer
var select_player: AudioStreamPlayer
var cut_player: AudioStreamPlayer
var elapsed := 0.0
var frame_cursor := 0
var static_alpha := 1.0
var tx_gender := false
var mask_origin_x := 634.0
var mask_vibrate := 0
var hovered_button := -1
var scene_change_queued := false

var buttons := [
	{"label_key": "retry", "rect": Rect2(1056.0, 576.0, 162.0, 48.0), "scene": "res://scenes/night/NightScene.tscn"},
	{"label_key": "to_menu", "rect": Rect2(1056.0, 640.0, 162.0, 48.0), "scene": "res://scenes/menu/MenuScene.tscn"},
]


func _ready() -> void:
	GameState.apply_options()
	bg_texture = _load_sprite("sprt_over_bg_0")
	mask_texture = _load_sprite("sprt_over_mask_0")
	over_character_frames = _load_frames("sprt_over_character")
	cctv_noise_frames = _load_frames("sprt_cctv_noise")
	_register_vector_font("cnbt", 24, 33)
	_register_vector_font("menubt", 18, 25)
	_register_vector_font("smaller", 12, 17)
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	hover_player = _make_audio("res://assets/sounds/menu/soun_menuover.wav", GameState.mastervol, false)
	select_player = _make_audio("res://assets/sounds/menu/soun_menuselect.wav", GameState.mastervol, false)
	cut_player = _make_audio("res://assets/gm/sounds/soun_cutcctv.wav", GameState.mastervol, false)
	tx_gender = bool(randi_range(0, 1))


func _exit_tree() -> void:
	for player in [hover_player, select_player, cut_player]:
		if player != null:
			player.stop()
			player.stream = null
	font_data.clear()
	fallback_font = null
	over_character_frames.clear()
	cctv_noise_frames.clear()


func _process(delta: float) -> void:
	elapsed += delta
	var target_frame := int(floor(elapsed * TARGET_FPS))
	while frame_cursor < target_frame:
		frame_cursor += 1
		_step_frame(frame_cursor)
	_update_hover()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		_change_scene_deferred("res://scenes/menu/MenuScene.tscn")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if frame_cursor <= int(5.0 * TARGET_FPS):
			return
		for i in range(buttons.size()):
			var rect: Rect2 = buttons[i]["rect"]
			if rect.has_point(event.position):
				_play_once(select_player)
				var next_scene := str(buttons[i]["scene"])
				if next_scene == "res://scenes/night/NightScene.tscn":
					GameState.change_scene_to_night(GameState.NIGHT_RETRY_FADE_SECONDS)
				else:
					_change_scene_deferred(next_scene)
				return


func _step_frame(frame: int) -> void:
	if frame == int(3.0 * TARGET_FPS):
		_play_once(cut_player)
	if frame > int(3.0 * TARGET_FPS) and static_alpha > 0.05:
		static_alpha = max(static_alpha - 0.005, 0.05)
	if mask_vibrate <= 0 and frame % int(TARGET_FPS) == 0 and randf() < 0.5:
		mask_vibrate = int((0.2 + randf()) * TARGET_FPS)
	if mask_vibrate > 0:
		mask_vibrate -= 1


func _update_hover() -> void:
	var previous_hover := hovered_button
	hovered_button = -1
	if frame_cursor > int(5.0 * TARGET_FPS):
		var mouse := get_viewport().get_mouse_position()
		for i in range(buttons.size()):
			var rect: Rect2 = buttons[i]["rect"]
			if rect.has_point(mouse):
				hovered_button = i
				break
	if hovered_button != -1 and hovered_button != previous_hover:
		_play_once(hover_player)


func _draw() -> void:
	draw_rect(Rect2(0.0, 0.0, VIEW_W, VIEW_H), Color.BLACK, true)
	if bg_texture != null:
		draw_texture_rect(bg_texture, Rect2(0.0, 0.0, VIEW_W, VIEW_H), false, COLOR_WHITE)
	var killer_index := _killer_over_index(GameState.last_killer)
	if killer_index >= 0 and killer_index < over_character_frames.size():
		draw_texture(over_character_frames[killer_index], Vector2.ZERO)
	if mask_texture != null:
		var jitter_x := 0.0
		if mask_vibrate > 0:
			jitter_x = randf_range(-3.0, 3.0)
		draw_texture(mask_texture, Vector2(mask_origin_x + jitter_x - 665.0, 359.0 - 374.0))
	_draw_over_content()
	if frame_cursor > int(5.0 * TARGET_FPS):
		_draw_buttons()


func _draw_over_content() -> void:
	_draw_text("cnbt", Vector2(64.0, 610.0), GameState.t("game_over"), COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE)
	_draw_text("smaller", Vector2(64.0, 650.0), _game_over_tip_lines(), COLOR_GRAY, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE)
	if cctv_noise_frames.size() > 0:
		var noise_index := int(floor(elapsed * 30.0)) % cctv_noise_frames.size()
		draw_texture_rect(cctv_noise_frames[noise_index], Rect2(0.0, 0.0, VIEW_W, VIEW_H), false, Color(1.0, 1.0, 1.0, static_alpha))
	if frame_cursor >= int(3.0 * TARGET_FPS) and frame_cursor <= int(3.2 * TARGET_FPS):
		for i in range(36):
			if randi_range(0, 15) < 1:
				var y := float(i * 20 + 20)
				draw_rect(Rect2(0.0, y, VIEW_W, 10.0 + randf() * 100.0), Color(1.0, 1.0, 1.0, 0.35), true)


func _draw_buttons() -> void:
	for i in range(buttons.size()):
		var rect: Rect2 = buttons[i]["rect"]
		if hovered_button == i:
			draw_rect(rect, COLOR_BUTTON, true)
			_draw_text("menubt", rect.position + Vector2(16.0, (rect.size.y * 0.5) + 3.0), ">", COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_MIDDLE, Vector2.ONE)
		_draw_text("menubt", rect.position + Vector2(32.0 + (8.0 if hovered_button == i else 0.0), (rect.size.y * 0.5) + 3.0), GameState.t(str(buttons[i]["label_key"])), COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_MIDDLE, Vector2.ONE)


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
			return GameState.t("gameover_tf")
		"ai_tb":
			return GameState.t("gameover_tb")
		"ai_tc":
			return GameState.t("gameover_tc")
		"ai_tx":
			return GameState.t("gameover_tx_her" if tx_gender else "gameover_tx_him")
		"ai_wf":
			return GameState.t("gameover_wf")
		"ai_wb":
			return GameState.t("gameover_wb")
		"ai_wc":
			return GameState.t("gameover_wc")
		"ai_wx":
			return GameState.t("gameover_wx")
		"ai_pp":
			return GameState.t("gameover_pp")
		_:
			return GameState.t("gameover_default")


func _game_over_tip_lines() -> String:
	var text := "> " + _game_over_tip(GameState.last_killer)
	var secondary_key := str(GameState.last_death_context.get("secondary_reason", ""))
	if secondary_key != "":
		text += "\n> " + GameState.t(secondary_key)
	return text


func _change_scene_deferred(path: String) -> void:
	if scene_change_queued:
		return
	scene_change_queued = true
	call_deferred("_change_scene_now", path)


func _change_scene_now(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _make_audio(path: String, volume_percent: int, loops: bool) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	if ResourceLoader.exists(path):
		player.stream = load(path)
	player.volume_db = GameState.volume_db(volume_percent)
	player.set_meta("loops", loops)
	player.finished.connect(_restart_audio.bind(player))
	add_child(player)
	return player


func _restart_audio(player: AudioStreamPlayer) -> void:
	if is_instance_valid(player) and bool(player.get_meta("loops", false)):
		player.play()


func _play_once(player: AudioStreamPlayer) -> void:
	if player != null and player.stream != null:
		player.stop()
		player.play()


func _load_sprite(sprite_name: String) -> Texture2D:
	var path := "res://assets/gm/sprites/%s.png" % sprite_name
	if not ResourceLoader.exists(path):
		return null
	return load(path)


func _load_frames(prefix: String) -> Array[Texture2D]:
	var frames: Array[Texture2D] = []
	var frame_index := 0
	while true:
		var path := "res://assets/gm/sprites/%s_%d.png" % [prefix, frame_index]
		if not ResourceLoader.exists(path):
			break
		frames.append(load(path))
		frame_index += 1
	return frames


func _register_vector_font(font_key: String, size: int, line_step: int) -> void:
	font_data[font_key] = {"size": size, "line_step": line_step}


func _draw_text(font_key: String, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int, text_scale: Vector2) -> void:
	if not font_data.has(font_key):
		return
	var data: Dictionary = font_data[font_key]
	if fallback_font == null:
		return
	_draw_vector_text(data, screen_pos, text, color, alpha, halign, valign, text_scale)


func _draw_vector_text(data: Dictionary, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int, text_scale: Vector2) -> void:
	var lines := text.split("\n")
	var base_line_step := float(data["line_step"])
	var line_step := base_line_step * text_scale.y
	var base_font_size := float(data["size"])
	var visual_font_size := base_font_size + ((base_line_step - base_font_size) * 0.25)
	var font_size := int(max(round(visual_font_size * max(text_scale.x, text_scale.y)), 8.0))
	var ascent := fallback_font.get_ascent(font_size)
	var total_height := line_step * lines.size()
	var start := screen_pos
	if valign == VALIGN_MIDDLE:
		start.y -= total_height * 0.5
	var text_color := Color(color.r, color.g, color.b, color.a * alpha)
	for line_index in range(lines.size()):
		var text_line := str(lines[line_index])
		var line_width := fallback_font.get_string_size(text_line, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
		var x := start.x
		if halign == HALIGN_CENTER:
			x -= line_width * 0.5
		elif halign == HALIGN_RIGHT:
			x -= line_width
		var baseline := start.y + (float(line_index) * line_step) + ascent
		draw_string(fallback_font, Vector2(x, baseline), text_line, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, text_color)
