extends Node2D

const VIEW_W := 1280.0
const VIEW_H := 720.0
const TARGET_FPS := 60.0

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_BLUE := Color(70.0 / 255.0, 70.0 / 255.0, 1.0, 1.0)
const COLOR_HOVER := Color(99.0 / 255.0, 122.0 / 255.0, 1.0, 40.0 / 255.0)
const HALIGN_LEFT := 0
const HALIGN_CENTER := 1
const VALIGN_TOP := 0
const VALIGN_MIDDLE := 1
const ACTIONS_START_FRAME := 6.0 * TARGET_FPS
const MENU_BUTTON := Rect2(172.0, 520.0, 376.0, 64.0)
const NEXT_BUTTON := Rect2(732.0, 520.0, 376.0, 64.0)

var bg_texture: Texture2D
var mainblack_texture: Texture2D
var font_data := {}
var fallback_font: FontFile
var title := "5:59 AM"
var new_title := "6:00 AM"
var bg_alpha := 1.0
var elapsed := 0.0
var frame_cursor := 0
var scene_change_queued := false
var track_player: AudioStreamPlayer
var select_player: AudioStreamPlayer
var completed_story_night := 0
var completed_story_mode := false
var hovered_action := ""


func _ready() -> void:
	GameState.apply_options()
	completed_story_mode = GameState.is_story_mode()
	completed_story_night = GameState.story_night if completed_story_mode else 0
	GameState.complete_current_night()
	bg_texture = _load_sprite("sprt_6am_bg_0")
	mainblack_texture = _load_sprite("sprt_menu_mainblack_0")
	_register_vector_font("cnbt", 24, 33)
	_register_vector_font("menubt", 18, 25)
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	track_player = AudioStreamPlayer.new()
	if ResourceLoader.exists("res://assets/gm/sounds/soun_track_6am.wav"):
		track_player.stream = load("res://assets/gm/sounds/soun_track_6am.wav")
	track_player.volume_db = GameState.volume_db(GameState.musicvol)
	add_child(track_player)
	if track_player.stream != null and DisplayServer.get_name() != "headless":
		track_player.play()
	select_player = AudioStreamPlayer.new()
	if ResourceLoader.exists("res://assets/sounds/menu/soun_menuselect.wav"):
		select_player.stream = load("res://assets/sounds/menu/soun_menuselect.wav")
	select_player.volume_db = GameState.volume_db(GameState.mastervol)
	add_child(select_player)


func _exit_tree() -> void:
	if track_player != null:
		track_player.stop()
		track_player.stream = null
	if select_player != null:
		select_player.stop()
		select_player.stream = null
	font_data.clear()
	fallback_font = null


func _process(delta: float) -> void:
	elapsed += delta
	var target_frame := int(floor(elapsed * TARGET_FPS))
	while frame_cursor < target_frame:
		frame_cursor += 1
		_step_frame(frame_cursor)
	_update_hover()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_handle_click(event.position)


func _step_frame(frame: int) -> void:
	if frame > int(2.0 * TARGET_FPS) and frame < int(3.5 * TARGET_FPS) and frame % 10 == 0:
		title = title.substr(0, max(title.length() - 1, 0))
	if frame > int(3.6 * TARGET_FPS) and frame < int(5.0 * TARGET_FPS) and frame % 10 == 0:
		title = new_title.substr(0, min(title.length() + 1, new_title.length()))
	if frame > int(5.0 * TARGET_FPS) and title != new_title:
		title = new_title
	if frame > int(5.0 * TARGET_FPS) and bg_alpha > 0.0:
		bg_alpha = max(bg_alpha - 0.01, 0.0)


func _draw() -> void:
	if bg_texture != null:
		draw_texture_rect(bg_texture, Rect2(0.0, 0.0, VIEW_W, VIEW_H), false, COLOR_WHITE)
	draw_rect(Rect2(0.0, 0.0, VIEW_W, VIEW_H), Color(0.0, 0.0, 0.0, bg_alpha), true)
	if mainblack_texture != null:
		draw_texture_rect(mainblack_texture, Rect2(Vector2(-90.0, 0.0), mainblack_texture.get_size() * Vector2(3.0, 2.0)), false, COLOR_WHITE)
	_draw_text("cnbt", Vector2(128.0, 320.0), "> " + title, COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2(2.0, 2.0))
	if frame_cursor > int(5.0 * TARGET_FPS) and frame_cursor % int(TARGET_FPS) > int(TARGET_FPS * 0.5):
		_draw_text("menubt", Vector2(236.0, 420.0), GameState.night_complete_title(), COLOR_BLUE, 1.0, HALIGN_LEFT, VALIGN_TOP, Vector2.ONE)
	if _actions_visible():
		_draw_actions()


func _actions_visible() -> bool:
	return frame_cursor >= int(ACTIONS_START_FRAME)


func _has_next_night() -> bool:
	return completed_story_mode and completed_story_night >= 1 and completed_story_night < 6


func _update_hover() -> void:
	var next_hover := ""
	if _actions_visible():
		var mouse := get_viewport().get_mouse_position()
		if MENU_BUTTON.has_point(mouse):
			next_hover = "menu"
		elif _has_next_night() and NEXT_BUTTON.has_point(mouse):
			next_hover = "next"
	hovered_action = next_hover


func _handle_click(screen_pos: Vector2) -> void:
	if not _actions_visible():
		return
	if MENU_BUTTON.has_point(screen_pos):
		_play_select()
		_change_scene_deferred("res://scenes/menu/MenuScene.tscn")
	elif _has_next_night() and NEXT_BUTTON.has_point(screen_pos):
		_play_select()
		GameState.start_story_night(completed_story_night + 1)
		GameState.change_scene_to_night_intro()


func _play_select() -> void:
	if select_player != null and select_player.stream != null:
		select_player.play()


func _draw_actions() -> void:
	_draw_action_button(MENU_BUTTON, GameState.t("sixam_return_menu"), hovered_action == "menu")
	if _has_next_night():
		_draw_action_button(NEXT_BUTTON, GameState.t("sixam_continue"), hovered_action == "next")


func _draw_action_button(rect: Rect2, label: String, hovered: bool) -> void:
	if hovered:
		draw_rect(rect, COLOR_HOVER, true)
		_draw_text("cnbt", rect.position + Vector2(22.0, (rect.size.y / 2.0) + 3.0), ">", COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_MIDDLE, Vector2.ONE)
	draw_rect(rect, Color(1.0, 1.0, 1.0, 0.68), false, 1.0)
	_draw_text("cnbt", rect.position + Vector2(54.0 + (8.0 if hovered else 0.0), (rect.size.y / 2.0) + 3.0), label, COLOR_WHITE, 1.0, HALIGN_LEFT, VALIGN_MIDDLE, Vector2.ONE)


func _change_scene_deferred(path: String) -> void:
	if scene_change_queued:
		return
	scene_change_queued = true
	call_deferred("_change_scene_now", path)


func _change_scene_now(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _load_sprite(sprite_name: String) -> Texture2D:
	var path := "res://assets/gm/sprites/%s.png" % sprite_name
	if not ResourceLoader.exists(path):
		return null
	return load(path)


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
		var baseline := start.y + (float(line_index) * line_step) + ascent
		draw_string(fallback_font, Vector2(x, baseline), text_line, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, text_color)
