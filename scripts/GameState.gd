extends Node

const FOOTER := "v0.9.0.0. Public Beta\nMade by Phil \"Phisnom\" Morg.\nRebuild by BlendRed"
const OPTIONS_PATH := "user://options.cfg"
const PROGRESS_PATH := "user://progress.cfg"
const ORIGINAL_GAME_ANDROID_MARKER := "android_purchase_confirmed"
const TARGET_FPS := 60
const WINDOWED_SIZE := Vector2i(1280, 720)
const NIGHT_SCENE := "res://scenes/night/NightScene.tscn"
const NIGHT_INTRO_SCENE := "res://scenes/night/NightIntroScene.tscn"
const MINIGAME_SCENE := "res://scenes/minigames/MinigameScene.tscn"
const NIGHT_ENTRY_FADE_SECONDS := 2.0
const NIGHT_RETRY_FADE_SECONDS := 2.0
const UPSCALER_OFF := 0
const UPSCALER_FSR1 := 1
const UPSCALER_FSR2 := 2
const UPSCALER_DLSS := 3
const UPSCALER_RENDER_SCALE := 0.67
const PERFORMANCE_RENDER_SCALE := 0.55
const PERFORMANCE_FPS := 30
const LOW_END_ANDROID_RENDER_SCALE := 0.50
const LOW_END_ANDROID_FPS := 30
const LOW_END_ANDROID_MODELS := ["SM-S156V"]
const MODE_CUSTOM := "custom"
const MODE_STORY := "story"
const MODE_SURVIVAL := "survival"
const MODE_RANDOM := "random"
const MODE_MISSION := "mission"
const LANGUAGE_CODES := ["en", "ru", "es", "pt"]
const PHONE_GUY_VOICE_CODES := ["en", "ru"]

const STORY_AI_KEYS := ["tf", "tb", "tc", "mangle", "bb", "wf", "wb", "wc", "foxy", "gf", "puppet"]
const CUSTOM_AI_KEYS := ["lvl_tf", "lvl_tb", "lvl_tc", "lvl_tx", "lvl_bb", "lvl_wf", "lvl_wb", "lvl_wc", "lvl_wx", "lvl_gf"]
const STORY_NIGHT_LEVELS := {
	1: [
		{"hour": 12, "ai": {"tf": 0, "tb": 0, "tc": 0, "mangle": 0, "bb": 0, "wf": 0, "wb": 0, "wc": 0, "foxy": 0, "gf": 0, "puppet": 1}},
		{"hour": 2, "ai": {"tb": 2, "tc": 2}},
		{"hour": 3, "ai": {"tf": 2, "tb": 3}},
	],
	2: [
		{"hour": 12, "ai": {"tf": 0, "tb": 0, "tc": 0, "mangle": 0, "bb": 0, "wf": 0, "wb": 0, "wc": 0, "foxy": 0, "gf": 0, "puppet": 1}},
		{"hour": 1, "ai": {"tf": 2, "tb": 3, "tc": 3, "mangle": 3, "bb": 3, "foxy": 1}},
	],
	3: [
		{"hour": 12, "ai": {"bb": 1, "wb": 1, "wc": 1, "foxy": 2, "puppet": 1}},
		{"hour": 1, "ai": {"tf": 0, "tb": 1, "tc": 1, "bb": 2, "wf": 2, "wb": 3, "wc": 2, "foxy": 3}},
	],
	4: [
		{"hour": 12, "ai": {"mangle": 5, "bb": 3, "wb": 1, "foxy": 6, "puppet": 1}},
		{"hour": 2, "ai": {"tb": 2, "tc": 2, "mangle": 6, "wf": 3, "wb": 4, "wc": 4}},
	],
	5: [
		{"hour": 12, "ai": {"tf": 2, "tb": 3, "tc": 3, "mangle": 3, "wf": 2, "wb": 2, "wc": 0, "foxy": 5, "puppet": 1}},
		{"hour": 1, "ai": {"tb": 4, "tc": 4, "mangle": 9, "wf": 5, "wb": 5, "wc": 5, "foxy": 7}},
	],
	6: [
		{"hour": 12, "ai": {"tf": 2, "tb": 3, "tc": 3, "mangle": 5, "bb": 6, "wf": 5, "wb": 5, "wc": 5, "foxy": 8, "puppet": 1}},
		{"hour": 2, "ai": {"tf": 6, "tb": 7, "tc": 7, "mangle": 10, "bb": 8, "wf": 8, "wb": 8, "wc": 8, "foxy": 10, "gf": 3}},
	],
}
const MISSION_PRESETS := [
	{
		"title_key": "mission_20202020",
		"desc_key": "mission_20202020_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 0, "lvl_tb": 0, "lvl_tc": 0, "lvl_tx": 0, "lvl_bb": 0, "lvl_wf": 11, "lvl_wb": 11, "lvl_wc": 11, "lvl_wx": 11, "lvl_gf": 0, "lvl_pp": 1},
	},
	{
		"title_key": "mission_new_and_shiny",
		"desc_key": "mission_new_and_shiny_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 10, "lvl_tb": 10, "lvl_tc": 10, "lvl_tx": 10, "lvl_bb": 10, "lvl_wf": 0, "lvl_wb": 0, "lvl_wc": 0, "lvl_wx": 0, "lvl_gf": 0, "lvl_pp": 1},
	},
	{
		"title_key": "mission_double_trouble",
		"desc_key": "mission_double_trouble_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 0, "lvl_tb": 11, "lvl_tc": 0, "lvl_tx": 0, "lvl_bb": 0, "lvl_wf": 0, "lvl_wb": 11, "lvl_wc": 0, "lvl_wx": 5, "lvl_gf": 0, "lvl_pp": 1},
	},
	{
		"title_key": "mission_night_of_misfits",
		"desc_key": "mission_night_of_misfits_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 0, "lvl_tb": 0, "lvl_tc": 0, "lvl_tx": 11, "lvl_bb": 11, "lvl_wf": 0, "lvl_wb": 0, "lvl_wc": 0, "lvl_wx": 0, "lvl_gf": 10, "lvl_pp": 1},
	},
	{
		"title_key": "mission_foxy_foxy",
		"desc_key": "mission_foxy_foxy_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 0, "lvl_tb": 0, "lvl_tc": 0, "lvl_tx": 11, "lvl_bb": 0, "lvl_wf": 0, "lvl_wb": 0, "lvl_wc": 0, "lvl_wx": 11, "lvl_gf": 0, "lvl_pp": 1},
	},
	{
		"title_key": "mission_ladies_night",
		"desc_key": "mission_ladies_night_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 0, "lvl_tb": 0, "lvl_tc": 11, "lvl_tx": 11, "lvl_bb": 0, "lvl_wf": 0, "lvl_wb": 0, "lvl_wc": 11, "lvl_wx": 0, "lvl_gf": 0, "lvl_pp": 1},
	},
	{
		"title_key": "mission_freddys_circus",
		"desc_key": "mission_freddys_circus_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 11, "lvl_tb": 0, "lvl_tc": 0, "lvl_tx": 0, "lvl_bb": 10, "lvl_wf": 11, "lvl_wb": 0, "lvl_wc": 0, "lvl_wx": 10, "lvl_gf": 10, "lvl_pp": 1},
	},
	{
		"title_key": "mission_cupcake_challenge",
		"desc_key": "mission_cupcake_challenge_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 5, "lvl_tb": 5, "lvl_tc": 5, "lvl_tx": 5, "lvl_bb": 5, "lvl_wf": 5, "lvl_wb": 5, "lvl_wc": 5, "lvl_wx": 5, "lvl_gf": 5, "lvl_pp": 1},
	},
	{
		"title_key": "mission_fazbear_fever",
		"desc_key": "mission_fazbear_fever_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 10, "lvl_tb": 10, "lvl_tc": 10, "lvl_tx": 10, "lvl_bb": 10, "lvl_wf": 10, "lvl_wb": 10, "lvl_wc": 10, "lvl_wx": 10, "lvl_gf": 10, "lvl_pp": 1},
	},
	{
		"title_key": "mission_golden_freddy",
		"desc_key": "mission_golden_freddy_desc",
		"duration": 0,
		"battery": 0,
		"toxic": 0,
		"usage": 0,
		"mods": {},
		"ai": {"lvl_tf": 11, "lvl_tb": 11, "lvl_tc": 11, "lvl_tx": 11, "lvl_bb": 11, "lvl_wf": 11, "lvl_wb": 11, "lvl_wc": 11, "lvl_wx": 11, "lvl_gf": 11, "lvl_pp": 1},
	},
]
const MINIGAMES := [
	{"id": "give_gifts", "title_key": "minigame_give_gifts", "desc_key": "minigame_give_gifts_desc"},
	{"id": "foxy_go", "title_key": "minigame_foxy_go", "desc_key": "minigame_foxy_go_desc"},
	{"id": "take_cake", "title_key": "minigame_take_cake", "desc_key": "minigame_take_cake_desc"},
]

var footer := FOOTER
var fullscreen_default := false
var antialiasing_default := 0
var vsync_default := false
var upscaler_default := 0
var language_default := "en"
var mastervol_default := 100
var musicvol_default := 100
var babyscare_default := false
var perspective_default := true
var particles_default := true
var radar_default := false
var hiderewards_default := false
var performance_mode_default := false
var phone_guy_voice_default := "en"
var toxicity_scale_default := true

var fullscreen := fullscreen_default
var antialiasing := antialiasing_default
var vsync := vsync_default
var upscaler := upscaler_default
var language := language_default
var mastervol := mastervol_default
var musicvol := musicvol_default
var babyscare := babyscare_default
var perspective := perspective_default
var particles := particles_default
var radar := radar_default
var hiderewards := hiderewards_default
var performance_mode := performance_mode_default
var phone_guy_voice := phone_guy_voice_default
var toxicity_scale := toxicity_scale_default

var lvl_duration := 0
var lvl_battery := 0
var lvl_toxic := 0
var lvl_usage := 0
var mod_music := false
var mod_auto := false
var mod_perma := false
var mod_insta := false
var lvl_wf := 0
var lvl_wb := 0
var lvl_wc := 0
var lvl_wx := 0
var lvl_gf := 0
var lvl_tf := 0
var lvl_tb := 0
var lvl_tc := 0
var lvl_tx := 0
var lvl_bb := 0
var lvl_pp := 0
var last_killer := ""
var last_death_context := {}
var upscaler_backend_status := "Off"
var night_mode := MODE_CUSTOM
var story_night := 0
var active_minigame_id := "give_gifts"
var active_night_title_key := "main_custom"
var active_night_desc_key := "intro_custom_desc"
var active_night_complete_key := "custom_night_complete"
var unlocked_story_night := 1
var original_game_verified := false
var original_game_path := ""
var scene_entry_fade_seconds := 0.0
var scene_transition_busy := false

var translations := {
	"en": {
		"main_new_game": "New Game",
		"main_continue": "Continue",
		"main_custom": "Custom Night",
		"main_extras": "Extras",
		"extras_title": "Extras",
		"extras_survival": "Survival Mode",
		"extras_random": "Random Mode",
		"extras_missions": "Missions",
		"extras_minigames": "Minigames",
		"extras_custom_desc": "Build your own night.",
		"extras_survival_desc": "One long shift with tough AI.",
		"extras_random_desc": "Start a randomized challenge.",
		"extras_missions_desc": "Preset challenge nights.",
		"extras_minigames_desc": "Play short arcade memories.",
		"missions_title": "Missions",
		"missions_select": "Select a challenge.",
		"minigames_title": "Minigames",
		"minigames_select": "Select an arcade memory.",
		"minigame_give_gifts": "Give Gifts, Give Life",
		"minigame_give_gifts_desc": "Give presents, then give masks.",
		"minigame_foxy_go": "Foxy Go! Go! Go!",
		"minigame_foxy_go_desc": "Run to the children before time runs out.",
		"minigame_take_cake": "Take Cake to the Children",
		"minigame_take_cake_desc": "Serve every child before patience runs out.",
		"minigame_controls": "Arrows/WASD move   SPACE acts   ESC exits",
		"minigame_complete": "COMPLETE",
		"minigame_failed": "FAILED",
		"mission_20202020": "20/20/20/20",
		"mission_20202020_desc": "WF, WB, WC and Foxy at max.",
		"mission_new_and_shiny": "New and Shiny",
		"mission_new_and_shiny_desc": "TF, TB, TC, Mangle and BB at 10.",
		"mission_double_trouble": "Double Trouble",
		"mission_double_trouble_desc": "WB and TB at max, Foxy at 5.",
		"mission_night_of_misfits": "Night of Misfits",
		"mission_night_of_misfits_desc": "Mangle and BB at max, GF at 10.",
		"mission_foxy_foxy": "Foxy Foxy",
		"mission_foxy_foxy_desc": "Foxy and Mangle at max.",
		"mission_ladies_night": "Ladies Night",
		"mission_ladies_night_desc": "WC, TC and Mangle at max.",
		"mission_freddys_circus": "Freddy's Circus",
		"mission_freddys_circus_desc": "TF and WF max, Foxy, BB and GF at 10.",
		"mission_cupcake_challenge": "Cupcake Challenge",
		"mission_cupcake_challenge_desc": "All animatronic AI at 5.",
		"mission_fazbear_fever": "Fazbear Fever",
		"mission_fazbear_fever_desc": "All animatronic AI at 10.",
		"mission_golden_freddy": "Golden Freddy",
		"mission_golden_freddy_desc": "All animatronic AI at max.",
		"intro_custom_desc": "Personalize your torture!",
		"intro_story_desc": "Survive until 6 AM.",
		"survival_complete": "Survival Complete!",
		"random_complete": "Random Night Complete!",
		"mission_complete": "%s Complete!",
		"main_options": "Options",
		"main_credits": "Credits",
		"main_quit": "Quit",
		"back": "BACK",
		"start": "START",
		"yes": "YES",
		"no": "NO",
		"new_game_title": "New Game",
		"new_game_confirm": "Start a new game?\nSaved night progress will be reset.",
		"warning_title": "WARNING!",
		"warning_desc": "This game contains flashing lights, loud noises,\nand lots of jumpscares!",
		"warning_tiny": "AFF:OS is an open source FNaF fangame project, \"Five Nights at Freddy's\" is owned by Scott Cawthon.",
		"verify_checking": "Checking for Five Nights at Freddy's 2...",
		"verify_found": "Original game found. Starting...",
		"verify_missing": "Five Nights at Freddy's 2 was not found in Steam.\nPlease select the original game executable.",
		"verify_invalid": "Selected file is not a valid Five Nights at Freddy's 2 executable.",
		"verify_ok": "OK",
		"verify_cancel": "CANCEL",
		"verify_choose_exe": "SELECT EXE",
		"verify_quit": "QUIT",
		"verify_no_file": "No file was selected.\nSelect Five Nights at Freddy's 2.exe to continue.",
		"verify_android": "Please buy Five Nights at Freddy's 2 before playing this rebuild.",
		"verify_android_download": "DOWNLOAD FNAF 2",
		"verify_android_confirm": "I CONFIRM THAT I BOUGHT FNAF 2",
		"continue_title": "Continue",
		"continue_select": "Select a saved night.",
		"continue_locked_note": "Complete a night to unlock the next one.",
		"night": "Night",
		"locked": "LOCKED",
		"ready": "READY",
		"stub_next": "This layer will be ported next.",
		"video_settings": "Video Settings",
		"audio_settings": "Audio Settings",
		"language_settings": "Language",
		"gameplay_settings": "Gameplay",
		"other_settings": "Other Settings",
		"fullscreen": "Fullscreen:",
		"anti_aliasing": "Anti-aliasing:",
		"upscaling": "Upscaling:",
		"vertical_sync": "Vertical Sync:",
		"language": "Language:",
		"sfx_volume": "SFX Volume:",
		"music_volume": "Music Volume:",
		"phone_guy_voice": "Phone Guy Voice:",
		"phone_guy_voice_en": "EN",
		"phone_guy_voice_ru": "RU",
		"disable_loud_scares": "Disable Loud Scares:",
		"perspective_3d": "3D Perspective:",
		"extra_particles": "Extra Particles:",
		"hide_office_rewards": "Hide Office Rewards:",
		"camera_radar": "Camera Radar:",
		"performance_mode": "Performance Mode:",
		"toxicity_scale": "Toxicity Scale:",
		"toxicity": "TOX",
		"default_settings": "DEFAULT SETTINGS",
		"cheat_disables_progress": "(CHEAT DISABLES PROGRESS)",
		"press_hold": "(PRESS & HOLD)",
		"night_settings": "Night Settings",
		"game_mods": "Game Mods",
		"ai_difficulty": "AI Difficulty",
		"shift_duration": "Shift Duration:",
		"battery_level": "Battery Level:",
		"toxic_level": "Toxic Level:",
		"usage_level": "Usage Level:",
		"music_box_timer": "Music Box Timer:",
		"auto_recharge": "Auto Recharge:",
		"perma_toxicity": "Perma Toxicity:",
		"insta_scare": "Insta Scare:",
		"enable_puppet": "Enable Puppet:",
		"the_toys": "The Toys",
		"the_withereds": "The Withereds",
		"all_off": "ALL OFF",
		"all_max": "ALL MAX",
		"randomize": "RANDOMIZE",
		"difficulty_note": "(0-2 = Easy. 3-6 = Medium. 7-10 = Hard. STAR = Extreme)",
		"lvl_none": "None",
		"lvl_slow": "Slow",
		"lvl_normal": "Normal",
		"lvl_fast": "Fast",
		"lvl_max": "Max",
		"muted": "MUTED",
		"mute_call": "MUTE CALL",
		"mute_call_short": "MUTE",
		"power": "POWER",
		"usage": "USAGE",
		"camera_disabled": "-CAMERA DISABLED-\nAUDIO ONLY",
		"turn_on_cam_light": "TURN ON\nCAM LIGHT",
		"click_hold": "click & hold",
		"you": "YOU",
		"cam_show_stage": "Show Stage",
		"cam_backstage": "Backstage",
		"cam_dining_hall": "Dining Hall",
		"cam_prize_corner": "Prize Corner",
		"cam_main_hall": "Main Hall",
		"cam_kitchen": "Kitchen",
		"cam_kids_cove": "Kids Cove",
		"cam_game_area": "Game Area",
		"cam_west_party": "West Party Room",
		"cam_east_party": "East Party Room",
		"custom_night_complete": "Custom Night Complete!",
		"story_night_complete": "Night %d Complete!",
		"sixam_return_menu": "RETURN TO MENU",
		"sixam_continue": "CONTINUE",
		"game_over": "GAME OVER",
		"retry": "RETRY",
		"to_menu": "TO MENU",
		"upscaler_off": "OFF",
		"upscaler_fsr1": "FSR1",
		"upscaler_fsr2": "FSR2",
		"upscaler_dlss": "DLSS N/A",
		"gameover_tf": "Toy Freddy can hide in the party rooms after going\n  into your office, check where he's gone to after leaving you alone.",
		"gameover_tb": "Toy Bonnie approaches you from the right vent,\n  check the flanks of your office from time to time.",
		"gameover_tc": "Toy Chica approaches you from the left vent,\n  check the flanks of your office from time to time.",
		"gameover_tx_her": "Mangle is weak to the flashlight, try to keep\n  her trapped in Kids Cove for as long as you can or she will rush you.",
		"gameover_tx_him": "Mangle is weak to the flashlight, try to keep\n  him trapped in Kids Cove for as long as you can or he will rush you.",
		"gameover_wf": "Withered Freddy tries to hide from the lights,\n  flash him as soon as possible or he will not back down.",
		"gameover_wb": "Withered Bonnie needs to be flashed on camera,\n  don't let him reach the left vent.",
		"gameover_wc": "Withered Chica needs to be flashed on camera,\n  don't let her reach the right vent.",
			"gameover_wx": "Withered Foxy only appears in the hallway,\n  flash the hallway periodically to make him back off.",
			"gameover_pp": "Don't let the battery run out, the Puppet\n  hates the light and will wait until it's unusable to attack you.",
			"gameover_default": "Stop sucking, loser!",
			"gameover_secondary_bb_power": "BB accelerated the power loss."
	},
	"ru": {
		"main_new_game": "Новая игра",
		"main_continue": "Продолжить",
		"main_custom": "Своя ночь",
		"main_extras": "Экстра",
		"extras_title": "Экстра",
		"extras_survival": "Выживание",
		"extras_random": "Случайная ночь",
		"extras_missions": "Миссии",
		"extras_minigames": "Миниигры",
		"extras_custom_desc": "Настрой свою ночь.",
		"extras_survival_desc": "Одна длинная смена с сильным ИИ.",
		"extras_random_desc": "Запустить случайный челлендж.",
		"extras_missions_desc": "Готовые испытания.",
		"extras_minigames_desc": "Короткие аркадные воспоминания.",
		"missions_title": "Миссии",
		"missions_select": "Выбери испытание.",
		"minigames_title": "Миниигры",
		"minigames_select": "Выбери аркадное воспоминание.",
		"minigame_give_gifts": "Give Gifts, Give Life",
		"minigame_give_gifts_desc": "Раздай подарки, затем маски.",
		"minigame_foxy_go": "Foxy Go! Go! Go!",
		"minigame_foxy_go_desc": "Добеги до детей до конца времени.",
		"minigame_take_cake": "Take Cake to the Children",
		"minigame_take_cake_desc": "Накорми всех детей, пока терпение не кончилось.",
		"minigame_controls": "Стрелки/WASD - ходьба   SPACE - действие   ESC - выход",
		"minigame_complete": "ПРОЙДЕНО",
		"minigame_failed": "ПРОВАЛ",
		"mission_20202020": "20/20/20/20",
		"mission_20202020_desc": "WF, WB, WC и Foxy на максимуме.",
		"mission_new_and_shiny": "New and Shiny",
		"mission_new_and_shiny_desc": "TF, TB, TC, Mangle и BB на 10.",
		"mission_double_trouble": "Double Trouble",
		"mission_double_trouble_desc": "WB и TB на максимуме, Foxy на 5.",
		"mission_night_of_misfits": "Night of Misfits",
		"mission_night_of_misfits_desc": "Mangle и BB на максимуме, GF на 10.",
		"mission_foxy_foxy": "Foxy Foxy",
		"mission_foxy_foxy_desc": "Foxy и Mangle на максимуме.",
		"mission_ladies_night": "Ladies Night",
		"mission_ladies_night_desc": "WC, TC и Mangle на максимуме.",
		"mission_freddys_circus": "Freddy's Circus",
		"mission_freddys_circus_desc": "TF и WF макс., Foxy, BB и GF на 10.",
		"mission_cupcake_challenge": "Cupcake Challenge",
		"mission_cupcake_challenge_desc": "Все аниматроники на 5.",
		"mission_fazbear_fever": "Fazbear Fever",
		"mission_fazbear_fever_desc": "Все аниматроники на 10.",
		"mission_golden_freddy": "Golden Freddy",
		"mission_golden_freddy_desc": "Все аниматроники на максимуме.",
		"intro_custom_desc": "Настрой свою пытку!",
		"intro_story_desc": "Доживи до 6 AM.",
		"survival_complete": "Выживание пройдено!",
		"random_complete": "Случайная ночь пройдена!",
		"mission_complete": "%s пройдена!",
		"main_options": "Настройки",
		"main_credits": "Авторы",
		"main_quit": "Выход",
		"back": "НАЗАД",
		"start": "СТАРТ",
		"yes": "ДА",
		"no": "НЕТ",
		"new_game_title": "Новая игра",
		"new_game_confirm": "Начать новую игру?\nПрогресс ночей будет сброшен.",
		"warning_title": "WARNING!",
		"warning_desc": "Эта игра содержит мигающий свет, громкие звуки\nи много скримеров!",
		"warning_tiny": "AFF:OS - open source FNaF fangame. \"Five Nights at Freddy's\" принадлежит Scott Cawthon.",
		"verify_checking": "Проверка наличия Five Nights at Freddy's 2...",
		"verify_found": "Оригинальная игра найдена. Запуск...",
		"verify_missing": "Five Nights at Freddy's 2 не найдена в Steam.\nУкажите exe-файл оригинальной игры.",
		"verify_invalid": "Выбранный файл не похож на exe Five Nights at Freddy's 2.",
		"verify_ok": "OK",
		"verify_cancel": "ОТМЕНА",
		"verify_choose_exe": "ВЫБРАТЬ EXE",
		"verify_quit": "ВЫЙТИ",
		"verify_no_file": "Файл не выбран.\nУкажи Five Nights at Freddy's 2.exe, чтобы продолжить.",
		"verify_android": "Перед запуском этого ребилда купи Five Nights at Freddy's 2.",
		"verify_android_download": "СКАЧАТЬ FNAF 2",
		"verify_android_confirm": "Я ПОДТВЕРЖДАЮ, ЧТО КУПИЛ FNAF 2",
		"continue_title": "Продолжить",
		"continue_select": "Выбери сохраненную ночь.",
		"continue_locked_note": "Пройди ночь, чтобы открыть следующую.",
		"night": "Ночь",
		"locked": "ЗАКРЫТО",
		"ready": "ОТКРЫТО",
		"stub_next": "Этот слой будет перенесен позже.",
		"video_settings": "Видео",
		"audio_settings": "Звук",
		"language_settings": "Язык",
		"gameplay_settings": "Игра",
		"other_settings": "Другое",
		"fullscreen": "Полный экран:",
		"anti_aliasing": "Сглаживание:",
		"upscaling": "Апскейл:",
		"vertical_sync": "Вертик. синхр.:",
		"language": "Язык:",
		"sfx_volume": "SFX:",
		"music_volume": "Музыка:",
		"phone_guy_voice": "Озвучка Phone Guy:",
		"phone_guy_voice_en": "EN",
		"phone_guy_voice_ru": "RU",
		"disable_loud_scares": "Тише скримеры:",
		"perspective_3d": "3D перспектива:",
		"extra_particles": "Частицы:",
		"hide_office_rewards": "Скрыть награды:",
		"camera_radar": "Радар камер:",
		"performance_mode": "Производительность:",
		"toxicity_scale": "Шкала токсичности:",
		"toxicity": "ТОКС",
		"default_settings": "СБРОС НАСТРОЕК",
		"cheat_disables_progress": "(ЧИТ ОТКЛЮЧАЕТ ПРОГРЕСС)",
		"press_hold": "(УДЕРЖИВАТЬ)",
		"night_settings": "Настройки ночи",
		"game_mods": "Моды игры",
		"ai_difficulty": "Сложность ИИ",
		"shift_duration": "Длительность:",
		"battery_level": "Батарея:",
		"toxic_level": "Токсичность:",
		"usage_level": "Расход:",
		"music_box_timer": "Музык. шкатулка:",
		"auto_recharge": "Автозаряд:",
		"perma_toxicity": "Перма токсин:",
		"insta_scare": "Мгнов. скример:",
		"enable_puppet": "Вкл. Марионетку:",
		"the_toys": "Игрушечные",
		"the_withereds": "Старые",
		"all_off": "ВСЕ ВЫКЛ",
		"all_max": "ВСЕ МАКС",
		"randomize": "СЛУЧАЙНО",
		"difficulty_note": "(0-2 = легко. 3-6 = средне. 7-10 = сложно. STAR = экстрим)",
		"lvl_none": "Нет",
		"lvl_slow": "Медл.",
		"lvl_normal": "Норма",
		"lvl_fast": "Быстро",
		"lvl_max": "Макс",
		"muted": "ВЫКЛ",
		"mute_call": "ВЫКЛ. ЗВОНОК",
		"mute_call_short": "ВЫКЛ.",
		"power": "ЗАРЯД",
		"usage": "РАСХОД",
		"camera_disabled": "-КАМЕРА ОТКЛЮЧЕНА-\nТОЛЬКО ЗВУК",
		"turn_on_cam_light": "ВКЛЮЧИТЬ\nСВЕТ КАМ.",
		"click_hold": "удерживать",
		"you": "ТЫ",
		"cam_show_stage": "Сцена",
		"cam_backstage": "Закулисье",
		"cam_dining_hall": "Обеденный зал",
		"cam_prize_corner": "Призовой угол",
		"cam_main_hall": "Главный холл",
		"cam_kitchen": "Кухня",
		"cam_kids_cove": "Kids Cove",
		"cam_game_area": "Игровая зона",
		"cam_west_party": "Западная комната",
		"cam_east_party": "Восточная комната",
		"custom_night_complete": "Своя ночь пройдена!",
		"story_night_complete": "Ночь %d пройдена!",
		"sixam_return_menu": "ВЕРНУТЬСЯ В МЕНЮ",
		"sixam_continue": "ПРОДОЛЖИТЬ",
		"game_over": "ИГРА ОКОНЧЕНА",
		"retry": "ЕЩЕ РАЗ",
		"to_menu": "В МЕНЮ",
		"upscaler_off": "ВЫКЛ",
		"upscaler_fsr1": "FSR1",
		"upscaler_fsr2": "FSR2",
		"upscaler_dlss": "DLSS Н/Д",
		"gameover_tf": "Toy Freddy может спрятаться в комнатах вечеринок\n  после входа в офис. Проверь, куда он ушел.",
		"gameover_tb": "Toy Bonnie идет через правую вентиляцию.\n  Время от времени проверяй фланги офиса.",
		"gameover_tc": "Toy Chica идет через левую вентиляцию.\n  Время от времени проверяй фланги офиса.",
		"gameover_tx_her": "Mangle слабеет от фонаря. Держи ее\n  в Kids Cove как можно дольше, иначе она нападет.",
		"gameover_tx_him": "Mangle слабеет от фонаря. Держи его\n  в Kids Cove как можно дольше, иначе он нападет.",
		"gameover_wf": "Withered Freddy прячется от света.\n  Подсвети его сразу, иначе он не отступит.",
		"gameover_wb": "Withered Bonnie нужно подсветить на камере.\n  Не дай ему дойти до левой вентиляции.",
		"gameover_wc": "Withered Chica нужно подсветить на камере.\n  Не дай ей дойти до правой вентиляции.",
			"gameover_wx": "Withered Foxy появляется только в коридоре.\n  Периодически свети туда, чтобы отогнать его.",
			"gameover_pp": "Не трать всю батарею. Puppet ненавидит свет\n  и ждет, пока он станет бесполезен.",
			"gameover_default": "Попробуй еще раз.",
			"gameover_secondary_bb_power": "BB ускорил разряд батареи."
	},
	"es": {
		"main_new_game": "Nueva partida",
		"main_continue": "Continuar",
		"main_custom": "Noche personalizada",
		"main_extras": "Extras",
		"extras_title": "Extras",
		"extras_survival": "Modo supervivencia",
		"extras_random": "Modo aleatorio",
		"extras_missions": "Misiones",
		"extras_minigames": "Minijuegos",
		"extras_custom_desc": "Crea tu propia noche.",
		"extras_survival_desc": "Un turno largo con IA dura.",
		"extras_random_desc": "Empieza un reto aleatorio.",
		"extras_missions_desc": "Noches de reto predefinidas.",
		"extras_minigames_desc": "Recuerdos arcade cortos.",
		"missions_title": "Misiones",
		"missions_select": "Elige un reto.",
		"minigames_title": "Minijuegos",
		"minigames_select": "Elige un recuerdo arcade.",
		"minigame_give_gifts": "Give Gifts, Give Life",
		"minigame_give_gifts_desc": "Entrega regalos y luego mascaras.",
		"minigame_foxy_go": "Foxy Go! Go! Go!",
		"minigame_foxy_go_desc": "Corre hasta los ninos antes de que acabe el tiempo.",
		"minigame_take_cake": "Take Cake to the Children",
		"minigame_take_cake_desc": "Sirve pastel antes de que se agote la paciencia.",
		"minigame_controls": "Flechas/WASD mover   SPACE accion   ESC salir",
		"minigame_complete": "COMPLETADO",
		"minigame_failed": "FALLO",
		"mission_20202020": "20/20/20/20",
		"mission_20202020_desc": "WF, WB, WC y Foxy al máximo.",
		"mission_new_and_shiny": "New and Shiny",
		"mission_new_and_shiny_desc": "TF, TB, TC, Mangle y BB en 10.",
		"mission_double_trouble": "Double Trouble",
		"mission_double_trouble_desc": "WB y TB al máximo, Foxy en 5.",
		"mission_night_of_misfits": "Night of Misfits",
		"mission_night_of_misfits_desc": "Mangle y BB al máximo, GF en 10.",
		"mission_foxy_foxy": "Foxy Foxy",
		"mission_foxy_foxy_desc": "Foxy y Mangle al máximo.",
		"mission_ladies_night": "Ladies Night",
		"mission_ladies_night_desc": "WC, TC y Mangle al máximo.",
		"mission_freddys_circus": "Freddy's Circus",
		"mission_freddys_circus_desc": "TF y WF max., Foxy, BB y GF en 10.",
		"mission_cupcake_challenge": "Cupcake Challenge",
		"mission_cupcake_challenge_desc": "Todos los animatrónicos en 5.",
		"mission_fazbear_fever": "Fazbear Fever",
		"mission_fazbear_fever_desc": "Todos los animatrónicos en 10.",
		"mission_golden_freddy": "Golden Freddy",
		"mission_golden_freddy_desc": "Todos los animatrónicos al máximo.",
		"intro_custom_desc": "Personaliza tu tortura.",
		"intro_story_desc": "Sobrevive hasta las 6 AM.",
		"survival_complete": "¡Supervivencia completada!",
		"random_complete": "¡Noche aleatoria completada!",
		"mission_complete": "¡%s completada!",
		"main_options": "Opciones",
		"main_credits": "Créditos",
		"main_quit": "Salir",
		"back": "ATRÁS",
		"start": "EMPEZAR",
		"yes": "SÍ",
		"no": "NO",
		"new_game_title": "Nueva partida",
		"new_game_confirm": "¿Empezar una partida nueva?\nSe reiniciará el progreso de noches.",
		"warning_title": "¡ADVERTENCIA!",
		"warning_desc": "Este juego contiene luces parpadeantes,\nsonidos fuertes y muchos sustos.",
		"warning_tiny": "AFF:OS es un fangame open source de FNaF. \"Five Nights at Freddy's\" pertenece a Scott Cawthon.",
		"verify_checking": "Buscando Five Nights at Freddy's 2...",
		"verify_found": "Juego original encontrado. Iniciando...",
		"verify_missing": "Five Nights at Freddy's 2 no se encontró en Steam.\nSelecciona el ejecutable del juego original.",
		"verify_invalid": "El archivo elegido no parece ser Five Nights at Freddy's 2.",
		"verify_ok": "OK",
		"verify_cancel": "CANCELAR",
		"verify_choose_exe": "ELEGIR EXE",
		"verify_quit": "SALIR",
		"verify_no_file": "No se seleccionó ningún archivo.\nElige Five Nights at Freddy's 2.exe para continuar.",
		"verify_android": "Compra Five Nights at Freddy's 2 antes de jugar este rebuild.",
		"verify_android_download": "DESCARGAR FNAF 2",
		"verify_android_confirm": "CONFIRMO QUE COMPRÉ FNAF 2",
		"continue_title": "Continuar",
		"continue_select": "Elige una noche guardada.",
		"continue_locked_note": "Completa una noche para desbloquear la siguiente.",
		"night": "Noche",
		"locked": "BLOQUEADA",
		"ready": "LISTA",
		"stub_next": "Esta capa será portada después.",
		"video_settings": "Vídeo",
		"audio_settings": "Sonido",
		"language_settings": "Idioma",
		"gameplay_settings": "Juego",
		"other_settings": "Otros",
		"fullscreen": "Pantalla completa:",
		"anti_aliasing": "Suavizado:",
		"upscaling": "Escalado:",
		"vertical_sync": "Sinc. vertical:",
		"language": "Idioma:",
		"sfx_volume": "SFX:",
		"music_volume": "Música:",
		"phone_guy_voice": "Voz Phone Guy:",
		"phone_guy_voice_en": "EN",
		"phone_guy_voice_ru": "RU",
		"disable_loud_scares": "Sustos suaves:",
		"perspective_3d": "Perspectiva 3D:",
		"extra_particles": "Partículas:",
		"hide_office_rewards": "Ocultar premios:",
		"camera_radar": "Radar cámaras:",
		"performance_mode": "Modo rendimiento:",
		"toxicity_scale": "Escala toxicidad:",
		"toxicity": "TOX",
		"default_settings": "RESTABLECER",
		"cheat_disables_progress": "(TRUCO: SIN PROGRESO)",
		"press_hold": "(MANTENER)",
		"night_settings": "Ajustes de noche",
		"game_mods": "Mods de juego",
		"ai_difficulty": "Dificultad IA",
		"shift_duration": "Duración:",
		"battery_level": "Batería:",
		"toxic_level": "Toxicidad:",
		"usage_level": "Consumo:",
		"music_box_timer": "Caja musical:",
		"auto_recharge": "Recarga auto:",
		"perma_toxicity": "Toxicidad fija:",
		"insta_scare": "Susto instant.:",
		"enable_puppet": "Activar Puppet:",
		"the_toys": "Los Toys",
		"the_withereds": "Los Withered",
		"all_off": "TODO OFF",
		"all_max": "TODO MAX",
		"randomize": "ALEATORIO",
		"difficulty_note": "(0-2 = fácil. 3-6 = medio. 7-10 = difícil. STAR = extremo)",
		"lvl_none": "Nada",
		"lvl_slow": "Lento",
		"lvl_normal": "Normal",
		"lvl_fast": "Rápido",
		"lvl_max": "Máx",
		"muted": "MUDO",
		"mute_call": "SILENCIAR",
		"mute_call_short": "MUDO",
		"power": "ENERGÍA",
		"usage": "USO",
		"camera_disabled": "-CÁMARA DESACTIVADA-\nSOLO AUDIO",
		"turn_on_cam_light": "ENCENDER\nLUZ CÁM.",
		"click_hold": "mantener",
		"you": "TÚ",
		"cam_show_stage": "Escenario",
		"cam_backstage": "Bastidores",
		"cam_dining_hall": "Comedor",
		"cam_prize_corner": "Rincón premios",
		"cam_main_hall": "Pasillo principal",
		"cam_kitchen": "Cocina",
		"cam_kids_cove": "Kids Cove",
		"cam_game_area": "Zona de juegos",
		"cam_west_party": "Sala oeste",
		"cam_east_party": "Sala este",
		"custom_night_complete": "¡Noche personalizada completada!",
		"story_night_complete": "¡Noche %d completada!",
		"sixam_return_menu": "VOLVER AL MENÚ",
		"sixam_continue": "CONTINUAR",
		"game_over": "FIN DEL JUEGO",
		"retry": "REINTENTAR",
		"to_menu": "AL MENÚ",
		"upscaler_off": "OFF",
		"upscaler_fsr1": "FSR1",
		"upscaler_fsr2": "FSR2",
		"upscaler_dlss": "DLSS N/D",
		"gameover_tf": "Toy Freddy puede esconderse en las salas\n  tras entrar en tu oficina. Mira adónde fue.",
		"gameover_tb": "Toy Bonnie entra por la ventilación derecha.\n  Revisa los lados de la oficina de vez en cuando.",
		"gameover_tc": "Toy Chica entra por la ventilación izquierda.\n  Revisa los lados de la oficina de vez en cuando.",
		"gameover_tx_her": "Mangle es débil ante la linterna. Mantenla\n  en Kids Cove cuanto puedas o te atacará.",
		"gameover_tx_him": "Mangle es débil ante la linterna. Mantenlo\n  en Kids Cove cuanto puedas o te atacará.",
		"gameover_wf": "Withered Freddy intenta ocultarse de la luz.\n  Ilumínalo pronto o no retrocederá.",
		"gameover_wb": "Withered Bonnie debe ser iluminado en cámara.\n  No dejes que llegue a la ventilación izquierda.",
		"gameover_wc": "Withered Chica debe ser iluminada en cámara.\n  No dejes que llegue a la ventilación derecha.",
		"gameover_wx": "Withered Foxy solo aparece en el pasillo.\n  Ilumina el pasillo a menudo para hacerlo retroceder.",
		"gameover_pp": "No agotes la batería. Puppet odia la luz\n  y espera a que sea inútil para atacar.",
		"gameover_default": "Inténtalo otra vez."
	},
	"pt": {
		"main_new_game": "Novo jogo",
		"main_continue": "Continuar",
		"main_custom": "Noite personalizada",
		"main_extras": "Extras",
		"extras_title": "Extras",
		"extras_survival": "Modo sobrevivência",
		"extras_random": "Modo aleatório",
		"extras_missions": "Missões",
		"extras_minigames": "Minigames",
		"extras_custom_desc": "Monte sua própria noite.",
		"extras_survival_desc": "Um turno longo com IA difícil.",
		"extras_random_desc": "Comece um desafio aleatório.",
		"extras_missions_desc": "Noites de desafio prontas.",
		"extras_minigames_desc": "Memorias arcade curtas.",
		"missions_title": "Missões",
		"missions_select": "Escolha um desafio.",
		"minigames_title": "Minigames",
		"minigames_select": "Escolha uma memoria arcade.",
		"minigame_give_gifts": "Give Gifts, Give Life",
		"minigame_give_gifts_desc": "Entregue presentes e depois mascaras.",
		"minigame_foxy_go": "Foxy Go! Go! Go!",
		"minigame_foxy_go_desc": "Corra ate as criancas antes do tempo acabar.",
		"minigame_take_cake": "Take Cake to the Children",
		"minigame_take_cake_desc": "Sirva bolo antes que a paciencia acabe.",
		"minigame_controls": "Setas/WASD mover   SPACE acao   ESC sair",
		"minigame_complete": "COMPLETO",
		"minigame_failed": "FALHOU",
		"mission_20202020": "20/20/20/20",
		"mission_20202020_desc": "WF, WB, WC e Foxy no máximo.",
		"mission_new_and_shiny": "New and Shiny",
		"mission_new_and_shiny_desc": "TF, TB, TC, Mangle e BB em 10.",
		"mission_double_trouble": "Double Trouble",
		"mission_double_trouble_desc": "WB e TB no máximo, Foxy em 5.",
		"mission_night_of_misfits": "Night of Misfits",
		"mission_night_of_misfits_desc": "Mangle e BB no máximo, GF em 10.",
		"mission_foxy_foxy": "Foxy Foxy",
		"mission_foxy_foxy_desc": "Foxy e Mangle no máximo.",
		"mission_ladies_night": "Ladies Night",
		"mission_ladies_night_desc": "WC, TC e Mangle no máximo.",
		"mission_freddys_circus": "Freddy's Circus",
		"mission_freddys_circus_desc": "TF e WF max., Foxy, BB e GF em 10.",
		"mission_cupcake_challenge": "Cupcake Challenge",
		"mission_cupcake_challenge_desc": "Todos os animatrônicos em 5.",
		"mission_fazbear_fever": "Fazbear Fever",
		"mission_fazbear_fever_desc": "Todos os animatrônicos em 10.",
		"mission_golden_freddy": "Golden Freddy",
		"mission_golden_freddy_desc": "Todos os animatrônicos no máximo.",
		"intro_custom_desc": "Personalize sua tortura.",
		"intro_story_desc": "Sobreviva até as 6 AM.",
		"survival_complete": "Sobrevivência completa!",
		"random_complete": "Noite aleatória completa!",
		"mission_complete": "%s completa!",
		"main_options": "Opções",
		"main_credits": "Créditos",
		"main_quit": "Sair",
		"back": "VOLTAR",
		"start": "COMEÇAR",
		"yes": "SIM",
		"no": "NÃO",
		"new_game_title": "Novo jogo",
		"new_game_confirm": "Começar um novo jogo?\nO progresso das noites será reiniciado.",
		"warning_title": "AVISO!",
		"warning_desc": "Este jogo contém luzes piscando,\nsons altos e muitos sustos.",
		"warning_tiny": "AFF:OS é um fangame open source de FNaF. \"Five Nights at Freddy's\" pertence a Scott Cawthon.",
		"verify_checking": "Procurando Five Nights at Freddy's 2...",
		"verify_found": "Jogo original encontrado. Iniciando...",
		"verify_missing": "Five Nights at Freddy's 2 não foi encontrado na Steam.\nSelecione o executável do jogo original.",
		"verify_invalid": "O arquivo escolhido não parece ser Five Nights at Freddy's 2.",
		"verify_ok": "OK",
		"verify_cancel": "CANCELAR",
		"verify_choose_exe": "ESCOLHER EXE",
		"verify_quit": "SAIR",
		"verify_no_file": "Nenhum arquivo foi selecionado.\nEscolha Five Nights at Freddy's 2.exe para continuar.",
		"verify_android": "Compre Five Nights at Freddy's 2 antes de jogar este rebuild.",
		"verify_android_download": "BAIXAR FNAF 2",
		"verify_android_confirm": "CONFIRMO QUE COMPREI FNAF 2",
		"continue_title": "Continuar",
		"continue_select": "Escolha uma noite salva.",
		"continue_locked_note": "Complete uma noite para desbloquear a próxima.",
		"night": "Noite",
		"locked": "BLOQUEADA",
		"ready": "PRONTA",
		"stub_next": "Esta camada será portada depois.",
		"video_settings": "Vídeo",
		"audio_settings": "Som",
		"language_settings": "Idioma",
		"gameplay_settings": "Jogo",
		"other_settings": "Outros",
		"fullscreen": "Tela cheia:",
		"anti_aliasing": "Suavização:",
		"upscaling": "Escala:",
		"vertical_sync": "Sinc. vertical:",
		"language": "Idioma:",
		"sfx_volume": "SFX:",
		"music_volume": "Música:",
		"phone_guy_voice": "Voz Phone Guy:",
		"phone_guy_voice_en": "EN",
		"phone_guy_voice_ru": "RU",
		"disable_loud_scares": "Sustos suaves:",
		"perspective_3d": "Perspectiva 3D:",
		"extra_particles": "Partículas:",
		"hide_office_rewards": "Ocultar prêmios:",
		"camera_radar": "Radar câmeras:",
		"performance_mode": "Modo desempenho:",
		"toxicity_scale": "Escala toxicidade:",
		"toxicity": "TOX",
		"default_settings": "REDEFINIR",
		"cheat_disables_progress": "(TRAPAÇA: SEM PROGRESSO)",
		"press_hold": "(SEGURAR)",
		"night_settings": "Ajustes da noite",
		"game_mods": "Mods do jogo",
		"ai_difficulty": "Dificuldade IA",
		"shift_duration": "Duração:",
		"battery_level": "Bateria:",
		"toxic_level": "Toxicidade:",
		"usage_level": "Consumo:",
		"music_box_timer": "Caixa musical:",
		"auto_recharge": "Recarga auto:",
		"perma_toxicity": "Toxicidade fixa:",
		"insta_scare": "Susto instant.:",
		"enable_puppet": "Ativar Puppet:",
		"the_toys": "Os Toys",
		"the_withereds": "Os Withered",
		"all_off": "TUDO OFF",
		"all_max": "TUDO MAX",
		"randomize": "ALEATÓRIO",
		"difficulty_note": "(0-2 = fácil. 3-6 = médio. 7-10 = difícil. STAR = extremo)",
		"lvl_none": "Nada",
		"lvl_slow": "Lento",
		"lvl_normal": "Normal",
		"lvl_fast": "Rápido",
		"lvl_max": "Máx",
		"muted": "MUDO",
		"mute_call": "SILENCIAR",
		"mute_call_short": "MUDO",
		"power": "ENERGIA",
		"usage": "USO",
		"camera_disabled": "-CÂMERA DESATIVADA-\nSOMENTE ÁUDIO",
		"turn_on_cam_light": "LIGAR\nLUZ CÂM.",
		"click_hold": "segurar",
		"you": "VOCÊ",
		"cam_show_stage": "Palco",
		"cam_backstage": "Bastidores",
		"cam_dining_hall": "Refeitório",
		"cam_prize_corner": "Canto prêmios",
		"cam_main_hall": "Corredor principal",
		"cam_kitchen": "Cozinha",
		"cam_kids_cove": "Kids Cove",
		"cam_game_area": "Área de jogos",
		"cam_west_party": "Sala oeste",
		"cam_east_party": "Sala leste",
		"custom_night_complete": "Noite personalizada completa!",
		"story_night_complete": "Noite %d completa!",
		"sixam_return_menu": "VOLTAR AO MENU",
		"sixam_continue": "CONTINUAR",
		"game_over": "FIM DE JOGO",
		"retry": "TENTAR DE NOVO",
		"to_menu": "AO MENU",
		"upscaler_off": "OFF",
		"upscaler_fsr1": "FSR1",
		"upscaler_fsr2": "FSR2",
		"upscaler_dlss": "DLSS N/D",
		"gameover_tf": "Toy Freddy pode se esconder nas salas\n  depois de entrar no escritório. Veja para onde foi.",
		"gameover_tb": "Toy Bonnie vem pela ventilação direita.\n  Confira os lados do escritório de vez em quando.",
		"gameover_tc": "Toy Chica vem pela ventilação esquerda.\n  Confira os lados do escritório de vez em quando.",
		"gameover_tx_her": "Mangle é fraca contra a lanterna. Mantenha-a\n  em Kids Cove o máximo possível ou ela atacará.",
		"gameover_tx_him": "Mangle é fraco contra a lanterna. Mantenha-o\n  em Kids Cove o máximo possível ou ele atacará.",
		"gameover_wf": "Withered Freddy tenta se esconder da luz.\n  Ilumine-o logo ou ele não recuará.",
		"gameover_wb": "Withered Bonnie precisa ser iluminado na câmera.\n  Não deixe que chegue à ventilação esquerda.",
		"gameover_wc": "Withered Chica precisa ser iluminada na câmera.\n  Não deixe que chegue à ventilação direita.",
		"gameover_wx": "Withered Foxy só aparece no corredor.\n  Ilumine o corredor com frequência para fazê-lo recuar.",
		"gameover_pp": "Não acabe com a bateria. Puppet odeia a luz\n  e espera ela ficar inútil para atacar.",
		"gameover_default": "Tente outra vez."
	}
}


func _ready() -> void:
	randomize()
	_apply_platform_defaults()
	load_options()
	load_progress()
	apply_options()


func _apply_platform_defaults() -> void:
	if not is_android():
		return
	fullscreen_default = true
	upscaler_default = UPSCALER_FSR1
	particles_default = false
	perspective_default = false
	antialiasing_default = 0
	vsync_default = false
	performance_mode_default = true


func is_android() -> bool:
	return OS.get_name() == "Android"


func android_model_name() -> String:
	if OS.has_method("get_model_name"):
		return str(OS.call("get_model_name"))
	return ""


func is_low_end_android_device() -> bool:
	if not is_android():
		return false
	var model := android_model_name().to_upper()
	for low_end_model in LOW_END_ANDROID_MODELS:
		if model.contains(str(low_end_model).to_upper()):
			return true
	return false


func uses_touch_controls() -> bool:
	return is_android()


func effective_fullscreen() -> bool:
	return fullscreen


func uses_fill_screen_stretch() -> bool:
	return is_android() and fullscreen


func uses_performance_mode() -> bool:
	return performance_mode or is_low_end_android_device() or (is_android() and night_mode == MODE_STORY and story_night == 6)


func particles_enabled() -> bool:
	return particles and not uses_performance_mode()


func perspective_enabled() -> bool:
	return perspective and not uses_performance_mode()


func effective_upscaler_mode(mode: int = upscaler) -> int:
	if is_android() and (mode == UPSCALER_FSR2 or mode == UPSCALER_DLSS):
		return UPSCALER_FSR1
	return mode


func change_scene_to_night_intro() -> void:
	if scene_transition_busy:
		return
	scene_transition_busy = true
	get_tree().change_scene_to_file(NIGHT_INTRO_SCENE)


func change_scene_to_night(exit_fade_seconds := 0.0) -> void:
	if scene_transition_busy:
		return
	scene_transition_busy = true
	if exit_fade_seconds > 0.0:
		await _fade_current_scene_to_black(exit_fade_seconds)
	scene_entry_fade_seconds = NIGHT_ENTRY_FADE_SECONDS
	get_tree().change_scene_to_file(NIGHT_SCENE)


func change_scene_to_minigame() -> void:
	if scene_transition_busy:
		return
	scene_transition_busy = true
	get_tree().change_scene_to_file(MINIGAME_SCENE)


func consume_scene_entry_fade_seconds() -> float:
	var value := scene_entry_fade_seconds
	scene_entry_fade_seconds = 0.0
	return value


func finish_scene_transition() -> void:
	scene_transition_busy = false


func _fade_current_scene_to_black(duration: float) -> void:
	if DisplayServer.get_name() == "headless" or duration <= 0.0:
		return
	var current := get_tree().current_scene
	if current == null:
		return
	var layer := CanvasLayer.new()
	layer.name = "LoadingFadeLayer"
	layer.layer = 128
	var rect := ColorRect.new()
	rect.name = "LoadingFadeRect"
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.color = Color(0.0, 0.0, 0.0, 0.0)
	rect.position = Vector2.ZERO
	rect.size = get_tree().root.get_visible_rect().size
	layer.add_child(rect)
	current.add_child(layer)
	var tween := create_tween()
	tween.tween_property(rect, "color:a", 1.0, duration)
	await tween.finished


func reset_custom_night_defaults() -> void:
	lvl_duration = 0
	lvl_battery = 0
	lvl_toxic = 0
	lvl_usage = 0
	mod_music = false
	mod_auto = false
	mod_perma = false
	mod_insta = false
	lvl_wf = 3
	lvl_wb = 3
	lvl_wc = 3
	lvl_wx = 3
	lvl_gf = 0
	lvl_tf = 5
	lvl_tb = 5
	lvl_tc = 5
	lvl_tx = 5
	lvl_bb = 0
	lvl_pp = 1


func _set_non_story_night(mode: String, title_key: String, desc_key: String, complete_key: String) -> void:
	night_mode = mode
	story_night = 0
	active_night_title_key = title_key
	active_night_desc_key = desc_key
	active_night_complete_key = complete_key


func start_custom_night() -> void:
	_set_non_story_night(MODE_CUSTOM, "main_custom", "intro_custom_desc", "custom_night_complete")


func start_survival_mode() -> void:
	reset_custom_night_defaults()
	lvl_duration = 54
	lvl_battery = 100
	lvl_toxic = 0
	lvl_usage = -1
	mod_music = false
	mod_auto = false
	mod_perma = false
	mod_insta = false
	lvl_tf = 7
	lvl_tb = 7
	lvl_tc = 7
	lvl_tx = 7
	lvl_bb = 6
	lvl_wf = 6
	lvl_wb = 6
	lvl_wc = 6
	lvl_wx = 7
	lvl_gf = 1
	lvl_pp = 1
	_set_non_story_night(MODE_SURVIVAL, "extras_survival", "extras_survival_desc", "survival_complete")


func start_random_mode() -> void:
	randomize_custom_night()
	_set_non_story_night(MODE_RANDOM, "extras_random", "extras_random_desc", "random_complete")


func start_mission(mission_index: int) -> void:
	var mission := mission_preset(mission_index)
	_apply_custom_preset(mission)
	_set_non_story_night(MODE_MISSION, str(mission.get("title_key", "extras_missions")), str(mission.get("desc_key", "extras_missions_desc")), "mission_complete")


func randomize_custom_night() -> void:
	lvl_duration = randi_range(-2, 6)
	lvl_battery = randi_range(-50, 50)
	lvl_toxic = randi_range(-2, 2)
	lvl_usage = randi_range(-2, 2)
	mod_music = randf() < 0.25
	mod_auto = randf() < 0.20
	mod_perma = randf() < 0.20
	mod_insta = randf() < 0.15
	for ai_key in CUSTOM_AI_KEYS:
		set(ai_key, randi_range(0, 11))
	lvl_pp = randi_range(0, 1)


func mission_count() -> int:
	return MISSION_PRESETS.size()


func mission_preset(mission_index: int) -> Dictionary:
	if MISSION_PRESETS.is_empty():
		return {}
	return MISSION_PRESETS[clampi(mission_index, 0, MISSION_PRESETS.size() - 1)]


func mission_title(mission_index: int) -> String:
	return t(str(mission_preset(mission_index).get("title_key", "extras_missions")))


func mission_description(mission_index: int) -> String:
	return t(str(mission_preset(mission_index).get("desc_key", "extras_missions_desc")))


func minigame_count() -> int:
	return MINIGAMES.size()


func minigame_preset(minigame_index: int) -> Dictionary:
	if MINIGAMES.is_empty():
		return {}
	return MINIGAMES[clampi(minigame_index, 0, MINIGAMES.size() - 1)]


func minigame_title(minigame_index: int) -> String:
	return t(str(minigame_preset(minigame_index).get("title_key", "minigames_title")))


func minigame_description(minigame_index: int) -> String:
	return t(str(minigame_preset(minigame_index).get("desc_key", "minigames_select")))


func start_minigame(minigame_index: int) -> void:
	var minigame := minigame_preset(minigame_index)
	active_minigame_id = str(minigame.get("id", "give_gifts"))


func _apply_custom_preset(preset: Dictionary) -> void:
	reset_custom_night_defaults()
	lvl_duration = clampi(int(preset.get("duration", 0)), -5, 54)
	lvl_battery = clampi(int(preset.get("battery", 0)), -100, 100)
	lvl_toxic = clampi(int(preset.get("toxic", 0)), -2, 2)
	lvl_usage = clampi(int(preset.get("usage", 0)), -2, 2)
	var mods: Dictionary = preset.get("mods", {})
	mod_music = bool(mods.get("mod_music", false))
	mod_auto = bool(mods.get("mod_auto", false))
	mod_perma = bool(mods.get("mod_perma", false))
	mod_insta = bool(mods.get("mod_insta", false))
	var ai: Dictionary = preset.get("ai", {})
	for ai_key in CUSTOM_AI_KEYS:
		set(ai_key, clampi(int(ai.get(ai_key, 0)), 0, 11))
	lvl_pp = clampi(int(ai.get("lvl_pp", 1)), 0, 1)


func start_story_night(night_number: int) -> void:
	night_mode = MODE_STORY
	story_night = clamp(night_number, 1, 6)
	active_night_title_key = "main_custom"
	active_night_desc_key = "intro_story_desc"
	active_night_complete_key = "custom_night_complete"
	_reset_story_rule_options()


func start_new_story() -> void:
	reset_story_progress()
	start_story_night(1)


func is_story_mode() -> bool:
	return night_mode == MODE_STORY and story_night >= 1 and story_night <= 6


func story_night_unlocked(night_number: int) -> bool:
	return night_number >= 1 and night_number <= unlocked_story_night


func story_night_title() -> String:
	if is_story_mode():
		return t("night") + " " + str(story_night)
	return t(active_night_title_key)


func night_intro_description() -> String:
	if is_story_mode():
		return t("intro_story_desc")
	return t(active_night_desc_key)


func night_complete_title() -> String:
	if is_story_mode():
		return t("story_night_complete") % story_night
	if active_night_complete_key == "mission_complete":
		return t("mission_complete") % t(active_night_title_key)
	return t(active_night_complete_key)


func complete_current_night() -> void:
	if not is_story_mode():
		return
	if story_night < 6 and unlocked_story_night < story_night + 1:
		unlocked_story_night = story_night + 1
		save_progress()


func reset_story_progress() -> void:
	unlocked_story_night = 1
	save_progress()


func mark_original_game_verified(path: String) -> void:
	original_game_verified = true
	original_game_path = path
	save_progress()


func original_game_needs_verification() -> bool:
	return not original_game_verified


func load_progress() -> void:
	var config := ConfigFile.new()
	var err := config.load(PROGRESS_PATH)
	if err != OK:
		unlocked_story_night = 1
		original_game_verified = false
		original_game_path = ""
		return
	unlocked_story_night = clamp(int(config.get_value("progress", "unlocked_story_night", 1)), 1, 6)
	original_game_verified = bool(config.get_value("progress", "original_game_verified", false))
	original_game_path = str(config.get_value("progress", "original_game_path", ""))


func save_progress() -> void:
	var config := ConfigFile.new()
	config.set_value("progress", "unlocked_story_night", clamp(unlocked_story_night, 1, 6))
	config.set_value("progress", "original_game_verified", original_game_verified)
	config.set_value("progress", "original_game_path", original_game_path)
	config.save(PROGRESS_PATH)


func story_night_duration_seconds() -> float:
	return 240.0 if story_night == 1 else 360.0


func story_levels_for_hour(night_number: int, hour_index: int) -> Dictionary:
	var levels := _zero_story_levels()
	var schedule: Array = STORY_NIGHT_LEVELS.get(night_number, [])
	for event in schedule:
		if _story_hour_to_index(int(event.get("hour", 12))) > hour_index:
			continue
		var ai: Dictionary = event.get("ai", {})
		for key in ai.keys():
			levels[str(key)] = clamp(int(ai[key]), 0, 11)
	return levels


func _zero_story_levels() -> Dictionary:
	var levels := {}
	for key in STORY_AI_KEYS:
		levels[key] = 0
	return levels


func _story_hour_to_index(hour: int) -> int:
	return 0 if hour == 12 else clamp(hour, 0, 6)


func _reset_story_rule_options() -> void:
	lvl_duration = 0
	lvl_battery = 0
	lvl_toxic = 0
	lvl_usage = 0
	mod_music = false
	mod_auto = false
	mod_perma = false
	mod_insta = false
	var start_levels := story_levels_for_hour(story_night, 0)
	lvl_wf = int(start_levels.get("wf", 0))
	lvl_wb = int(start_levels.get("wb", 0))
	lvl_wc = int(start_levels.get("wc", 0))
	lvl_wx = int(start_levels.get("foxy", 0))
	lvl_gf = int(start_levels.get("gf", 0))
	lvl_tf = int(start_levels.get("tf", 0))
	lvl_tb = int(start_levels.get("tb", 0))
	lvl_tc = int(start_levels.get("tc", 0))
	lvl_tx = int(start_levels.get("mangle", 0))
	lvl_bb = int(start_levels.get("bb", 0))
	lvl_pp = int(start_levels.get("puppet", 0))


func volume_db(percent: int) -> float:
	if percent <= 0:
		return -80.0
	return linear_to_db(clamp(percent, 0, 100) * 0.01)


func t(key: String) -> String:
	var language_map: Dictionary = translations.get(language, translations["en"])
	return str(language_map.get(key, translations["en"].get(key, key)))


func detect_system_language() -> String:
	var locale := OS.get_locale().to_lower().replace("-", "_")
	if locale == "":
		return language_default
	var language_code := locale.split("_")[0]
	if LANGUAGE_CODES.has(language_code):
		return str(language_code)
	return language_default


func detect_phone_guy_voice() -> String:
	var locale := OS.get_locale().to_lower().replace("-", "_")
	if locale == "":
		return phone_guy_voice_default
	var language_code := locale.split("_")[0]
	return "ru" if language_code == "ru" else phone_guy_voice_default


func language_label() -> String:
	return language.to_upper()


func cycle_language(delta: int) -> void:
	var index := LANGUAGE_CODES.find(language)
	if index < 0:
		index = 0
	language = str(LANGUAGE_CODES[posmod(index + delta, LANGUAGE_CODES.size())])


func phone_guy_voice_label() -> String:
	return t("phone_guy_voice_ru") if phone_guy_voice == "ru" else t("phone_guy_voice_en")


func cycle_phone_guy_voice(delta: int) -> void:
	var index := PHONE_GUY_VOICE_CODES.find(phone_guy_voice)
	if index < 0:
		index = 0
	phone_guy_voice = str(PHONE_GUY_VOICE_CODES[posmod(index + delta, PHONE_GUY_VOICE_CODES.size())])


func phone_guy_monologue_path(night_number: int) -> String:
	var voice := phone_guy_voice if PHONE_GUY_VOICE_CODES.has(phone_guy_voice) else phone_guy_voice_default
	return "res://assets/phone_guy/night_%d/%s.ogg" % [clamp(night_number, 1, 6), voice]


func is_ru() -> bool:
	return language == "ru"


func upscaler_label(mode: int = upscaler) -> String:
	match effective_upscaler_mode(mode):
		UPSCALER_FSR1:
			return t("upscaler_fsr1")
		UPSCALER_FSR2:
			return t("upscaler_fsr2")
		UPSCALER_DLSS:
			return t("upscaler_dlss")
		_:
			return t("upscaler_off")


func upscaler_render_scale(mode: int = upscaler) -> float:
	if uses_performance_mode():
		return LOW_END_ANDROID_RENDER_SCALE if is_android() else PERFORMANCE_RENDER_SCALE
	var effective_mode := effective_upscaler_mode(mode)
	if effective_mode != UPSCALER_FSR1 and effective_mode != UPSCALER_FSR2:
		return 1.0
	return LOW_END_ANDROID_RENDER_SCALE if is_low_end_android_device() else UPSCALER_RENDER_SCALE


func upscaler_sharpness(mode: int = upscaler) -> float:
	if uses_performance_mode() and mode == UPSCALER_OFF:
		return 0.35
	match effective_upscaler_mode(mode):
		UPSCALER_FSR1:
			return 0.40
		UPSCALER_FSR2:
			return 0.22
		_:
			return 0.0


func reset_options_defaults() -> void:
	fullscreen = fullscreen_default
	antialiasing = antialiasing_default
	vsync = vsync_default
	upscaler = upscaler_default
	language = language_default
	mastervol = mastervol_default
	musicvol = musicvol_default
	babyscare = babyscare_default
	perspective = perspective_default
	particles = particles_default
	radar = radar_default
	hiderewards = hiderewards_default
	performance_mode = performance_mode_default
	phone_guy_voice = detect_phone_guy_voice()
	toxicity_scale = toxicity_scale_default
	save_options()
	apply_options()


func load_options() -> void:
	var config := ConfigFile.new()
	var err := config.load(OPTIONS_PATH)
	if err != OK:
		language = detect_system_language()
		phone_guy_voice = detect_phone_guy_voice()
		save_options()
		return
	fullscreen = bool(config.get_value("options", "fullscreen", fullscreen_default))
	antialiasing = clamp(int(config.get_value("options", "antialiasing", antialiasing_default)), 0, 3)
	vsync = bool(config.get_value("options", "vsync", vsync_default))
	upscaler = clamp(int(config.get_value("options", "upscaler", upscaler_default)), 0, 3)
	language = str(config.get_value("options", "language", language_default))
	if language == "env":
		language = "en"
	if not LANGUAGE_CODES.has(language):
		language = language_default
	mastervol = clamp(int(config.get_value("options", "mastervol", mastervol_default)), 0, 100)
	musicvol = clamp(int(config.get_value("options", "musicvol", musicvol_default)), 0, 100)
	babyscare = bool(config.get_value("options", "babyscare", babyscare_default))
	perspective = bool(config.get_value("options", "perspective", perspective_default))
	particles = bool(config.get_value("options", "particles", particles_default))
	radar = bool(config.get_value("options", "radar", radar_default))
	hiderewards = bool(config.get_value("options", "hiderewards", hiderewards_default))
	performance_mode = bool(config.get_value("options", "performance_mode", performance_mode_default))
	toxicity_scale = bool(config.get_value("options", "toxicity_scale", toxicity_scale_default))
	phone_guy_voice = str(config.get_value("options", "phone_guy_voice", detect_phone_guy_voice()))
	if not PHONE_GUY_VOICE_CODES.has(phone_guy_voice):
		phone_guy_voice = phone_guy_voice_default


func save_options() -> void:
	var config := ConfigFile.new()
	config.set_value("options", "fullscreen", fullscreen)
	config.set_value("options", "antialiasing", antialiasing)
	config.set_value("options", "vsync", vsync)
	config.set_value("options", "upscaler", upscaler)
	config.set_value("options", "language", language)
	config.set_value("options", "mastervol", mastervol)
	config.set_value("options", "musicvol", musicvol)
	config.set_value("options", "babyscare", babyscare)
	config.set_value("options", "perspective", perspective)
	config.set_value("options", "particles", particles)
	config.set_value("options", "radar", radar)
	config.set_value("options", "hiderewards", hiderewards)
	config.set_value("options", "performance_mode", performance_mode)
	config.set_value("options", "toxicity_scale", toxicity_scale)
	config.set_value("options", "phone_guy_voice", phone_guy_voice)
	config.save(OPTIONS_PATH)


func apply_options() -> void:
	if Engine.is_editor_hint():
		return
	if uses_performance_mode():
		Engine.max_fps = LOW_END_ANDROID_FPS if is_low_end_android_device() else PERFORMANCE_FPS
	else:
		Engine.max_fps = TARGET_FPS
	_apply_window_stretch()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if effective_fullscreen() else DisplayServer.WINDOW_MODE_WINDOWED)
	if not effective_fullscreen():
		DisplayServer.window_set_size(WINDOWED_SIZE)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)
	_apply_antialiasing()
	_apply_upscaler_backend()


func _apply_window_stretch() -> void:
	var window := get_tree().root
	window.content_scale_size = WINDOWED_SIZE
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE if uses_fill_screen_stretch() else Window.CONTENT_SCALE_ASPECT_KEEP


func _apply_antialiasing() -> void:
	var viewport := get_tree().root
	var effective_antialiasing := 0 if uses_performance_mode() else antialiasing
	match effective_antialiasing:
		1:
			viewport.msaa_2d = Viewport.MSAA_2X
		2:
			viewport.msaa_2d = Viewport.MSAA_4X
		3:
			viewport.msaa_2d = Viewport.MSAA_8X
		_:
			viewport.msaa_2d = Viewport.MSAA_DISABLED


func _apply_upscaler_backend() -> void:
	var viewport_rid := get_tree().root.get_viewport_rid()
	var render_scale := upscaler_render_scale()
	match effective_upscaler_mode():
		UPSCALER_FSR1:
			RenderingServer.viewport_set_scaling_3d_mode(viewport_rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR)
			RenderingServer.viewport_set_scaling_3d_scale(viewport_rid, render_scale)
			upscaler_backend_status = "FSR1 2D render scale %.2f + 3D FSR" % render_scale
		UPSCALER_FSR2:
			RenderingServer.viewport_set_scaling_3d_mode(viewport_rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
			RenderingServer.viewport_set_scaling_3d_scale(viewport_rid, render_scale)
			upscaler_backend_status = "FSR2 2D render scale %.2f + 3D FSR2" % render_scale
		UPSCALER_DLSS:
			RenderingServer.viewport_set_scaling_3d_mode(viewport_rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR)
			RenderingServer.viewport_set_scaling_3d_scale(viewport_rid, 1.0)
			upscaler_backend_status = "DLSS unsupported: install a DLSS/Streamline plugin"
		_:
			RenderingServer.viewport_set_scaling_3d_mode(viewport_rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR)
			RenderingServer.viewport_set_scaling_3d_scale(viewport_rid, 1.0)
			upscaler_backend_status = "Performance 2D render scale %.2f" % render_scale if render_scale < 1.0 else "Off"
