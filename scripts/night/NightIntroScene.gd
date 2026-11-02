extends Node2D

const VIEW_W := 1280.0
const VIEW_H := 720.0
const TARGET_FPS := 60.0
const FADE_START_SECONDS := 8.0
const ROOM_END_SECONDS := 10.0

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_GRAY := Color(0.5, 0.5, 0.5, 1.0)
const COLOR_BLUE := Color(70.0 / 255.0, 70.0 / 255.0, 1.0, 1.0)
const HALIGN_CENTER := 1
const VALIGN_TOP := 0

var font_data := {}
var fallback_font: FontFile
var cut_player: AudioStreamPlayer
var elapsed := 0.0
var scene_change_queued := false


func _ready() -> void:
	GameState.finish_scene_transition()
	GameState.apply_options()
	_register_vector_font("menubt", 18, 25)
	_register_vector_font("footer", 12, 17)
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	cut_player = AudioStreamPlayer.new()
	if ResourceLoader.exists("res://assets/gm/sounds/soun_cutcctv.wav"):
		cut_player.stream = load("res://assets/gm/sounds/soun_cutcctv.wav")
	cut_player.volume_db = GameState.volume_db(GameState.mastervol)
	add_child(cut_player)
	if cut_player.stream != null and DisplayServer.get_name() != "headless":
		cut_player.play()


func _exit_tree() -> void:
	if cut_player != null:
		cut_player.stop()
		cut_player.stream = null
	font_data.clear()
	fallback_font = null


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= ROOM_END_SECONDS:
		_change_to_night()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if elapsed <= 3.0 or elapsed >= FADE_START_SECONDS:
		return
	if event is InputEventMouseButton and event.pressed:
		elapsed = FADE_START_SECONDS
	elif event is InputEventScreenTouch and event.pressed:
		elapsed = FADE_START_SECONDS
	elif event is InputEventKey and event.pressed and not event.echo:
		elapsed = FADE_START_SECONDS


func _draw() -> void:
	draw_rect(Rect2(0.0, 0.0, VIEW_W, VIEW_H), Color.BLACK, true)
	_draw_text("menubt", Vector2(640.0, 330.0), "12:00 AM", COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2.ONE)
	_draw_text("menubt", Vector2(640.0, 370.0), GameState.story_night_title(), COLOR_BLUE, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2.ONE)
	_draw_text("footer", Vector2(640.0, 420.0), "> " + GameState.night_intro_description(), COLOR_GRAY, 1.0, HALIGN_CENTER, VALIGN_TOP, Vector2.ONE)
	if int(floor(elapsed * TARGET_FPS)) < 10:
		_draw_initial_static_bars()
	var fade_alpha := clampf((elapsed - FADE_START_SECONDS) / (ROOM_END_SECONDS - FADE_START_SECONDS), 0.0, 1.0)
	if fade_alpha > 0.0:
		draw_rect(Rect2(0.0, 0.0, VIEW_W, VIEW_H), Color(0.0, 0.0, 0.0, fade_alpha), true)


func _draw_initial_static_bars() -> void:
	for i in range(int(VIEW_H / 20.0)):
		if randi_range(0, 15) < 1:
			var y := float(i * 20 + 20)
			draw_rect(Rect2(0.0, y, VIEW_W, 10.0 + randf() * 100.0), COLOR_WHITE, true)


func _change_to_night() -> void:
	if scene_change_queued:
		return
	scene_change_queued = true
	GameState.change_scene_to_night()


func _register_vector_font(font_key: String, size: int, line_step: int) -> void:
	font_data[font_key] = {"size": size, "line_step": line_step}


func _draw_text(font_key: String, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int, text_scale: Vector2) -> void:
	if not font_data.has(font_key) or fallback_font == null:
		return
	var data: Dictionary = font_data[font_key]
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
	if valign != VALIGN_TOP:
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
