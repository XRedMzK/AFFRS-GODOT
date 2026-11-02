extends Node2D

const VIEW_W := 1280.0
const VIEW_H := 720.0
const VERIFY_SCENE := "res://scenes/warning/WarningScene.tscn"
const SKIP_AFTER_SECONDS := 2.0
const FADE_OUT_AT_SECONDS := 13.0
const CHANGE_AT_SECONDS := 15.0
const FADE_IN_SECONDS := 3.0
const FADE_OUT_SECONDS := 2.0

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_BLUE := Color(70.0 / 255.0, 70.0 / 255.0, 1.0, 1.0)
const COLOR_GRAY := Color(0.5, 0.5, 0.5, 1.0)

const HALIGN_CENTER := 1
const VALIGN_TOP := 0

var font_data := {}
var fallback_font: FontFile
var dust := []
var elapsed := 0.0
var scene_change_queued := false
var music_player: AudioStreamPlayer


func _ready() -> void:
	GameState.apply_options()
	_register_vector_font("menubt", 18, 25)
	_register_vector_font("footer", 12, 17)
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	_setup_dust()
	_setup_audio()


func _exit_tree() -> void:
	if music_player != null:
		music_player.stop()
		music_player.stream = null
	music_player = null
	font_data.clear()
	fallback_font = null
	dust.clear()


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= CHANGE_AT_SECONDS:
		_change_scene_deferred()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if elapsed < SKIP_AFTER_SECONDS or elapsed >= FADE_OUT_AT_SECONDS:
		return
	if _is_skip_event(event):
		elapsed = FADE_OUT_AT_SECONDS


func _is_skip_event(event: InputEvent) -> bool:
	if event is InputEventMouseButton and event.pressed:
		return true
	if event is InputEventScreenTouch and event.pressed:
		return true
	if event is InputEventKey and event.pressed:
		return true
	return false


func _setup_audio() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "WarningMenuMusic"
	music_player.stream = load("res://assets/sounds/menu/soun_track_menu.wav")
	music_player.volume_db = GameState.volume_db(GameState.musicvol)
	music_player.finished.connect(_restart_music)
	add_child(music_player)
	if DisplayServer.get_name() != "headless":
		music_player.play()


func _restart_music() -> void:
	if music_player != null:
		music_player.play()


func _setup_dust() -> void:
	dust.clear()
	for i in range(48):
		dust.append({
			"pos": Vector2(randf_range(32.0, VIEW_W - 32.0), randf_range(32.0, VIEW_H - 32.0)),
			"speed": randf_range(4.0, 18.0),
			"alpha": randf_range(0.05, 0.18),
		})


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), Color.BLACK, true)
	_draw_dust()
	_draw_text("menubt", Vector2(640.0, 300.0), GameState.t("warning_title"), COLOR_BLUE, 1.0, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("menubt", Vector2(640.0, 350.0), GameState.t("warning_desc"), COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("footer", Vector2(640.0, 650.0), GameState.t("warning_tiny"), COLOR_GRAY, 1.0, HALIGN_CENTER, VALIGN_TOP)
	var fade_alpha := _fade_alpha()
	if fade_alpha > 0.0:
		draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), Color(0.0, 0.0, 0.0, fade_alpha), true)


func _fade_alpha() -> float:
	if elapsed < FADE_IN_SECONDS:
		return 1.0 - clampf(elapsed / FADE_IN_SECONDS, 0.0, 1.0)
	if elapsed >= FADE_OUT_AT_SECONDS:
		return clampf((elapsed - FADE_OUT_AT_SECONDS) / FADE_OUT_SECONDS, 0.0, 1.0)
	return 0.0


func _draw_dust() -> void:
	if not GameState.particles_enabled():
		return
	for particle in dust:
		var pos: Vector2 = particle["pos"]
		var speed := float(particle["speed"])
		var alpha := float(particle["alpha"])
		var draw_pos := Vector2(fmod(pos.x + (elapsed * speed), VIEW_W), pos.y + sin(elapsed + pos.x) * 2.0)
		draw_circle(draw_pos, 1.0, Color(1.0, 1.0, 1.0, alpha))


func _change_scene_deferred() -> void:
	if scene_change_queued:
		return
	scene_change_queued = true
	call_deferred("_change_scene_now")


func _change_scene_now() -> void:
	get_tree().change_scene_to_file(VERIFY_SCENE)


func _register_vector_font(font_key: String, size: int, line_step: int) -> void:
	font_data[font_key] = {"size": size, "line_step": line_step}


func _draw_text(font_key: String, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int) -> void:
	if not font_data.has(font_key) or fallback_font == null:
		return
	var data: Dictionary = font_data[font_key]
	_draw_vector_text(data, screen_pos, text, color, alpha, halign, valign)


func _draw_vector_text(data: Dictionary, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int) -> void:
	var lines := text.split("\n")
	var line_step := float(data["line_step"])
	var base_font_size := float(data["size"])
	var visual_font_size := base_font_size + ((line_step - base_font_size) * 0.25)
	var font_size := int(max(round(visual_font_size), 8.0))
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
