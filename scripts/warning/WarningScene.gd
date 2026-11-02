extends Node2D

const VIEW_W := 1280.0
const VIEW_H := 720.0
const MENU_SCENE := "res://scenes/menu/MenuScene.tscn"
const GOOGLE_PLAY_URL := "https://play.google.com/store/apps/details?id=com.scottgames.fnaf2"
const STEAM_APP_ID := "332800"

const COLOR_WHITE := Color(1.0, 1.0, 1.0, 1.0)
const COLOR_BLUE := Color(70.0 / 255.0, 70.0 / 255.0, 1.0, 1.0)
const COLOR_GRAY := Color(0.5, 0.5, 0.5, 1.0)
const COLOR_RED := Color(1.0, 0.16, 0.16, 1.0)
const COLOR_HOVER := Color(99.0 / 255.0, 122.0 / 255.0, 1.0, 40.0 / 255.0)

const HALIGN_LEFT := 0
const HALIGN_CENTER := 1
const VALIGN_TOP := 0
const VALIGN_MIDDLE := 1

const OK_BUTTON := Rect2(432.0, 454.0, 184.0, 58.0)
const CANCEL_BUTTON := Rect2(664.0, 454.0, 184.0, 58.0)
const PLAY_BUTTON := Rect2(312.0, 454.0, 288.0, 58.0)
const CONFIRM_BUTTON := Rect2(648.0, 454.0, 408.0, 58.0)

var font_data := {}
var fallback_font: FontFile
var file_dialog: FileDialog
var status_text := ""
var status_color := COLOR_GRAY
var mode := "checking"
var hovered_button := ""
var scene_change_queued := false
var dust := []
var elapsed := 0.0


func _ready() -> void:
	GameState.apply_options()
	_register_vector_font("menubt", 18, 25)
	_register_vector_font("footer", 12, 17)
	_register_vector_font("cnbt", 24, 33)
	_register_vector_font("cnsmall", 16, 22)
	fallback_font = load("res://assets/fonts/font_ocr_cnbt.otf")
	_setup_file_dialog()
	_setup_dust()
	if not GameState.original_game_needs_verification():
		_change_scene_deferred(MENU_SCENE)
		return
	if OS.get_name() == "Android":
		mode = "android"
		status_text = GameState.t("verify_android")
		status_color = COLOR_WHITE
	else:
		status_text = GameState.t("verify_checking")
		call_deferred("_run_desktop_check")


func _exit_tree() -> void:
	font_data.clear()
	fallback_font = null
	file_dialog = null


func _process(delta: float) -> void:
	elapsed += delta
	_update_hover()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_handle_click(event.position)


func _setup_file_dialog() -> void:
	file_dialog = FileDialog.new()
	file_dialog.name = "OriginalGameFileDialog"
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.title = "Select Five Nights at Freddy's 2.exe"
	file_dialog.filters = PackedStringArray(["*.exe ; Windows executable"])
	file_dialog.mode_overrides_title = false
	file_dialog.use_native_dialog = true
	file_dialog.file_selected.connect(_on_file_selected)
	file_dialog.canceled.connect(_on_file_dialog_canceled)
	add_child(file_dialog)


func _setup_dust() -> void:
	dust.clear()
	for i in range(48):
		dust.append({
			"pos": Vector2(randf_range(32.0, VIEW_W - 32.0), randf_range(32.0, VIEW_H - 32.0)),
			"speed": randf_range(4.0, 18.0),
			"alpha": randf_range(0.05, 0.18),
		})


func _run_desktop_check() -> void:
	var found_path := _find_original_game_in_steam()
	if found_path != "":
		GameState.mark_original_game_verified(found_path)
		mode = "found"
		status_text = GameState.t("verify_found")
		status_color = COLOR_WHITE
		await get_tree().create_timer(0.85).timeout
		_change_scene_deferred(MENU_SCENE)
	else:
		mode = "missing"
		status_text = GameState.t("verify_missing")
		status_color = COLOR_WHITE


func _update_hover() -> void:
	var next_hover := ""
	var mouse := get_viewport().get_mouse_position()
	if mode == "missing" or mode == "invalid":
		if OK_BUTTON.has_point(mouse):
			next_hover = "ok"
		elif CANCEL_BUTTON.has_point(mouse):
			next_hover = "cancel"
	elif mode == "android":
		if PLAY_BUTTON.has_point(mouse):
			next_hover = "play"
		elif CONFIRM_BUTTON.has_point(mouse):
			next_hover = "confirm"
	hovered_button = next_hover


func _handle_click(screen_pos: Vector2) -> void:
	if mode == "missing" or mode == "invalid":
		if OK_BUTTON.has_point(screen_pos):
			_open_file_dialog()
		elif CANCEL_BUTTON.has_point(screen_pos):
			get_tree().quit()
	elif mode == "android":
		if PLAY_BUTTON.has_point(screen_pos):
			OS.shell_open(GOOGLE_PLAY_URL)
		elif CONFIRM_BUTTON.has_point(screen_pos):
			GameState.mark_original_game_verified(GameState.ORIGINAL_GAME_ANDROID_MARKER)
			_change_scene_deferred(MENU_SCENE)


func _open_file_dialog() -> void:
	if file_dialog == null:
		return
	file_dialog.popup_file_dialog()


func _on_file_selected(path: String) -> void:
	var normalized := _normalize_path(path)
	if _is_valid_original_game_exe(normalized):
		GameState.mark_original_game_verified(normalized)
		mode = "found"
		status_text = GameState.t("verify_found")
		status_color = COLOR_WHITE
		_change_scene_deferred(MENU_SCENE)
	else:
		mode = "invalid"
		status_text = GameState.t("verify_invalid") + "\n" + GameState.t("verify_missing")
		status_color = COLOR_RED


func _on_file_dialog_canceled() -> void:
	mode = "missing"
	status_text = GameState.t("verify_no_file")
	status_color = COLOR_WHITE


func _find_original_game_in_steam() -> String:
	for library_path in _steam_libraries():
		var found_path := _find_original_game_in_library(library_path)
		if found_path != "":
			return found_path
	return ""


func _steam_libraries() -> Array[String]:
	var libraries: Array[String] = []
	for root in _steam_roots():
		if root == "":
			continue
		var normalized_root := _normalize_path(root)
		_add_unique_path(libraries, normalized_root)
		for library in _read_steam_libraryfolders(normalized_root):
			_add_unique_path(libraries, library)
	return libraries


func _steam_roots() -> Array[String]:
	var roots: Array[String] = []
	var program_files_x86 := OS.get_environment("ProgramFiles(x86)")
	var program_files := OS.get_environment("ProgramFiles")
	if program_files_x86 != "":
		roots.append(program_files_x86.path_join("Steam"))
	if program_files != "":
		roots.append(program_files.path_join("Steam"))
	for drive in ["C", "D", "E", "F", "G"]:
		roots.append("%s:/Steam" % drive)
		roots.append("%s:/Program Files (x86)/Steam" % drive)
	return roots


func _read_steam_libraryfolders(steam_root: String) -> Array[String]:
	var libraries: Array[String] = []
	var library_file := steam_root.path_join("steamapps").path_join("libraryfolders.vdf")
	if not FileAccess.file_exists(library_file):
		return libraries
	var text := FileAccess.get_file_as_string(library_file)
	for raw_line in text.split("\n"):
		var line := raw_line.strip_edges()
		if line.begins_with("\"path\""):
			var value := _vdf_value(line)
			if value != "":
				libraries.append(_normalize_path(value))
		else:
			var legacy_value := _vdf_legacy_library_path(line)
			if legacy_value != "":
				libraries.append(_normalize_path(legacy_value))
	return libraries


func _find_original_game_in_library(library_path: String) -> String:
	var steamapps := library_path.path_join("steamapps")
	var manifest_path := steamapps.path_join("appmanifest_%s.acf" % STEAM_APP_ID)
	if FileAccess.file_exists(manifest_path):
		var install_dir := _read_appmanifest_install_dir(manifest_path)
		if install_dir != "":
			var manifest_found := _find_original_game_in_folder(steamapps.path_join("common").path_join(install_dir))
			if manifest_found != "":
				return manifest_found
	var common := steamapps.path_join("common")
	for folder_name in [
		"Five Nights at Freddy's 2",
		"Five Nights at Freddys 2",
		"FiveNightsatFreddys2",
		"FNaF 2",
	]:
		var found_path := _find_original_game_in_folder(common.path_join(folder_name))
		if found_path != "":
			return found_path
	var common_dir := DirAccess.open(common)
	if common_dir == null:
		return ""
	common_dir.list_dir_begin()
	while true:
		var entry := common_dir.get_next()
		if entry == "":
			break
		if not common_dir.current_is_dir() or entry.begins_with("."):
			continue
		var lower_entry := entry.to_lower()
		if (lower_entry.contains("freddy") or lower_entry.contains("fnaf")) and lower_entry.contains("2"):
			var found_in_entry := _find_original_game_in_folder(common.path_join(entry))
			if found_in_entry != "":
				return found_in_entry
	common_dir.list_dir_end()
	return ""


func _read_appmanifest_install_dir(manifest_path: String) -> String:
	var text := FileAccess.get_file_as_string(manifest_path)
	for raw_line in text.split("\n"):
		var line := raw_line.strip_edges()
		if line.begins_with("\"installdir\""):
			return _vdf_value(line)
	return ""


func _find_original_game_in_folder(folder_path: String) -> String:
	if folder_path == "":
		return ""
	for exe_name in [
		"Five Nights at Freddy's 2.exe",
		"FiveNightsatFreddys2.exe",
		"FNaF2.exe",
		"fnaf2.exe",
	]:
		var candidate := folder_path.path_join(exe_name)
		if _is_valid_original_game_exe(candidate):
			return _normalize_path(candidate)
	var folder := DirAccess.open(folder_path)
	if folder == null:
		return ""
	folder.list_dir_begin()
	while true:
		var entry := folder.get_next()
		if entry == "":
			break
		if folder.current_is_dir():
			continue
		var candidate_file := folder_path.path_join(entry)
		if _is_valid_original_game_exe(candidate_file):
			return _normalize_path(candidate_file)
	folder.list_dir_end()
	return ""


func _is_valid_original_game_exe(path: String) -> bool:
	var normalized := _normalize_path(path)
	if normalized == "" or normalized.get_extension().to_lower() != "exe":
		return false
	if not FileAccess.file_exists(normalized):
		return false
	var file_name := normalized.get_file().to_lower().replace("'", "").replace(" ", "").replace("-", "")
	if file_name == "fivenightsatfreddys2.exe":
		return true
	if file_name == "fnaf2.exe":
		return true
	return file_name.contains("freddy") and file_name.contains("2")


func _vdf_value(line: String) -> String:
	var parts := line.split("\"", false)
	if parts.size() >= 2:
		return _normalize_path(str(parts[parts.size() - 1]))
	return ""


func _vdf_legacy_library_path(line: String) -> String:
	var parts := line.split("\"", false)
	if parts.size() < 2:
		return ""
	if not str(parts[0]).is_valid_int():
		return ""
	var value := str(parts[1])
	return value if value.contains(":") or value.contains("\\") or value.contains("/") else ""


func _add_unique_path(paths: Array[String], path: String) -> void:
	if path != "" and not paths.has(path):
		paths.append(path)


func _normalize_path(path: String) -> String:
	return path.replace("\\\\", "/").replace("\\", "/").strip_edges()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(VIEW_W, VIEW_H)), Color.BLACK, true)
	_draw_dust()
	_draw_text("menubt", Vector2(640.0, 300.0), "Five Nights at Freddy's 2", COLOR_BLUE, 1.0, HALIGN_CENTER, VALIGN_TOP)
	_draw_text("cnsmall", Vector2(640.0, 360.0), status_text, status_color, 1.0, HALIGN_CENTER, VALIGN_TOP)
	if mode == "missing" or mode == "invalid":
		_draw_button(OK_BUTTON, GameState.t("verify_choose_exe"), "ok")
		_draw_button(CANCEL_BUTTON, GameState.t("verify_quit"), "cancel")
	elif mode == "android":
		_draw_button(PLAY_BUTTON, GameState.t("verify_android_download"), "play")
		_draw_button(CONFIRM_BUTTON, GameState.t("verify_android_confirm"), "confirm")
	_draw_text("footer", Vector2(640.0, 650.0), GameState.t("warning_tiny"), COLOR_GRAY, 1.0, HALIGN_CENTER, VALIGN_TOP)


func _draw_dust() -> void:
	if not GameState.particles_enabled():
		return
	for particle in dust:
		var pos: Vector2 = particle["pos"]
		var speed := float(particle["speed"])
		var alpha := float(particle["alpha"])
		var draw_pos := Vector2(fmod(pos.x + (elapsed * speed), VIEW_W), pos.y + sin(elapsed + pos.x) * 2.0)
		draw_circle(draw_pos, 1.0, Color(1.0, 1.0, 1.0, alpha))


func _draw_button(rect: Rect2, label: String, button_name: String) -> void:
	var hovered := hovered_button == button_name
	if hovered:
		draw_rect(rect, COLOR_HOVER, true)
	draw_rect(rect, Color(1.0, 1.0, 1.0, 0.72), false, 1.0)
	_draw_text("cnbt", rect.position + Vector2(rect.size.x * 0.5, (rect.size.y * 0.5) + 3.0), label, COLOR_WHITE, 1.0, HALIGN_CENTER, VALIGN_MIDDLE)


func _change_scene_deferred(path: String) -> void:
	if scene_change_queued:
		return
	scene_change_queued = true
	call_deferred("_change_scene_now", path)


func _change_scene_now(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _register_vector_font(font_key: String, size: int, line_step: int) -> void:
	font_data[font_key] = {"size": size, "line_step": line_step}


func _draw_text(font_key: String, screen_pos: Vector2, text: String, color: Color, alpha: float, halign: int, valign: int) -> void:
	if not font_data.has(font_key):
		return
	var data: Dictionary = font_data[font_key]
	if fallback_font == null:
		return
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
