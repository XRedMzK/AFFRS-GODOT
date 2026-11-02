extends RefCounted

const FPS := 60.0


static func room_details() -> Array:
	return [
		["none", -4.0, "walk", 99, 0, 2000, 1],
		["empty", -4.0, "walk", 99, 0, 2000, 1],
		["offpath", -1.0, "walk", 4, 272, 53, 4],
		["showstage", 0.0, "walk", 3, 320, 5, 3],
		["showstagewf", 0.1, "walk", 1, 288, 5, 1],
		["backstage", 1.0, "walk", 1, 356, 141, 1],
		["backstagewc", 1.1, "walk", 1, 356, 109, 1],
		["backstagewf", 1.2, "walk", 1, 388, 109, 1],
		["backstagewb", 1.3, "walk", 1, 388, 141, 1],
		["backstagewx", 1.4, "walk", 1, 356, 141, 1],
		["dininghall", 2.0, "walk", 4, 260, 101, 2],
		["dininghallwb", 2.1, "walk", 1, 324, 101, 1],
		["dininghallwc", 2.2, "walk", 1, 324, 133, 1],
		["prizecorner", 3.0, "walk", 4, 260, 173, 2],
		["prizecornertb", 3.1, "walk", 1, 244, 173, 1],
		["prizecornerpp", 3.2, "power", 1, 324, 185, 1],
		["mainhall", 4.0, "walk", 5, 92, 45, 5],
		["kitchen", 5.0, "walk", 4, 20, 17, 2],
		["kitchenwf", 5.1, "walk", 1, 52, 49, 1],
		["kidscove", 6.0, "walk", 1, 52, 125, 1],
		["kidscovetx1", 6.1, "walk", 1, 20, 93, 1],
		["kidscovetx2", 6.2, "walk", 1, 52, 93, 1],
		["kidscovetx3", 6.3, "walk", 1, 20, 125, 1],
		["kidscovetx4", 6.4, "walk", 1, 0, 125, 1],
		["gamearea", 7.0, "walk", 6, 160, 97, 3],
		["gameareawf", 7.1, "walk", 6, 224, 129, 3],
		["westpartyroom", 8.0, "walk", 3, -8, 185, 3],
		["eastpartyroom", 9.0, "walk", 3, 160, 185, 3],
		["ventleft", 10.0, "walk", 3, 8, 257, 1],
		["ventright", 11.0, "walk", 3, 212, 257, 1],
		["left", 12.0, "view", 1, 56, 257, 1],
		["front", 13.0, "view", 1, 108, 169, 1],
		["frontwx", 13.1, "view", 1, 108, 97, 1],
		["fronttf", 13.2, "view", 1, 132, 117, 1],
		["frontwest", 13.3, "view", 1, 88, 169, 1],
		["frontclose", 13.4, "view", 1, 108, 225, 1],
		["right", 14.0, "view", 1, 160, 257, 1],
		["office", 15.0, "office", 1, 108, 245, 1],
		["officeclose", 15.1, "office", 4, 92, 277, 4],
		["officesp", 15.2, "special", 2, 76, 293, 1],
		["officetx", 15.3, "mangle", 1, 140, 293, 1],
		["you", 16.0, "you", 99, 108, 309, 1],
	]


static func make_units() -> Array:
	return make_units_from_levels({
		"tf": GameState.lvl_tf,
		"tb": GameState.lvl_tb,
		"tc": GameState.lvl_tc,
		"mangle": GameState.lvl_tx,
		"bb": GameState.lvl_bb,
		"wf": GameState.lvl_wf,
		"wb": GameState.lvl_wb,
		"wc": GameState.lvl_wc,
		"foxy": GameState.lvl_wx,
		"gf": GameState.lvl_gf,
		"puppet": GameState.lvl_pp,
	}, false)


static func make_units_from_levels(levels: Dictionary, visible_inactive: bool = false) -> Array:
	var units: Array = []
	units.append(_toy_freddy(int(levels.get("tf", 0))))
	units.append(_toy_bonnie(int(levels.get("tb", 0))))
	units.append(_toy_chica(int(levels.get("tc", 0))))
	units.append(_mangle(int(levels.get("mangle", 0))))
	units.append(_balloon_boy(int(levels.get("bb", 0))))
	units.append(_withered_freddy(int(levels.get("wf", 0))))
	units.append(_withered_bonnie(int(levels.get("wb", 0))))
	units.append(_withered_chica(int(levels.get("wc", 0))))
	units.append(_withered_foxy(int(levels.get("foxy", 0))))
	units.append(_golden_freddy(int(levels.get("gf", 0))))
	units.append(_puppet(int(levels.get("puppet", 0))))
	if visible_inactive:
		for ai in units:
			if int(ai.get("difficulty", 0)) <= 0:
				ai["active"] = true
				ai["in"] = str(ai.get("start", "none"))
				ai["move"] = 0.0
				ai["story_visible_inactive"] = true
	return units


static func _base_ai(ai_id: String, difficulty: int, start_room: String, target_room: String) -> Dictionary:
	return {
		"id": ai_id,
		"short": ai_id.substr(3),
		"start": start_room,
		"in": start_room if difficulty > 0 else "none",
		"target": target_room,
		"difficulty": difficulty,
		"inmax": difficulty > 10,
		"active": difficulty > 0,
		"perseverance": 1.0,
		"move": 0.0,
		"whenwalk": 21600.0,
		"whenview": 21600.0,
		"freezetime": 0.0,
		"freezelimit": 0.0,
		"lifetime": 0.0,
		"lifelimit": 0.0,
		"staretime": 0.0,
		"starelimit": 360.0,
		"starenotice": 180.0,
		"movedelay": 0.0,
		"movesound_group": "",
		"detersound_group": "",
		"scaretype": "",
		"scaresound": "",
		"scare_sprite": "",
		"maskable": false,
		"frozen_on_view": false,
		"frozen_on_flash": false,
		"damage_on_view": false,
		"damage_on_flash": false,
		"damage_push": false,
		"fast_on_view": false,
		"loner": false,
		"office_wait": false,
		"mask_wait": false,
		"can_stare": false,
		"must_stare": false,
		"no_looked_cams": false,
		"no_looked_views": false,
		"officevisible": false,
		"looktime": 0.0,
		"looklimit": 180.0,
		"walkmap": [["none", 0, [start_room], [start_room]]],
		"indetails": ["none", -4.0, "walk", 99, 0, 0, 1],
		"walkpath": ["none", 0, [start_room], [start_room]],
	}


static func _toy_freddy(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_tf if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_tf", d, "showstage", "you")
	ai["perseverance"] = 1.0
	ai["move"] = 0.0 if inmax else -float(randi_range(20, 24)) * FPS
	ai["whenwalk"] = (34.0 - (float(d) * 1.8) - (4.0 * float(inmax))) * FPS
	ai["whenview"] = (11.0 - (2.0 * float(inmax))) * FPS
	ai["freezelimit"] = FPS
	ai["starelimit"] = (6.0 - (2.0 * float(inmax))) * FPS
	ai["starenotice"] = 3.0 * FPS
	ai["movedelay"] = 0.0 if inmax else 5.0 * FPS
	ai["movesound_group"] = "toy"
	ai["detersound_group"] = "toy"
	ai["scaretype"] = "now"
	ai["scaresound"] = "scare_toy"
	ai["scare_sprite"] = "sprt_scare_tf"
	ai["maskable"] = true
	ai["frozen_on_view"] = true
	ai["frozen_on_flash"] = true
	ai["mask_wait"] = true
	ai["can_stare"] = true
	ai["fast_on_view"] = true
	ai["walkmap"] = [["none", 0, ["showstage"]], ["showstage", 2, ["offpath"]], ["offpath", 0, ["mainhall", "dininghall", "gamearea"]], ["mainhall", 24, ["fronttf", "gamearea"]], ["dininghall", 10, ["mainhall", "gamearea"]], ["gamearea", 31, ["fronttf", "dininghall", "eastpartyroom"]], ["fronttf", 2, ["frontclose", "frontclose", "kidscove", "gamearea"]], ["kidscove", 30, ["frontclose", "fronttf"]], ["westpartyroom", 36, ["frontclose"]], ["eastpartyroom", 39, ["frontclose"]], ["frontclose", 7, ["office"]], ["office", 0, ["you"], ["westpartyroom", "offpath", "offpath", "offpath", "offpath"]]]
	return ai


static func _toy_bonnie(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_tb if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_tb", d, "showstage", "you")
	ai["perseverance"] = 0.9
	ai["move"] = 0.0 if inmax else -float(randi_range(4, 8)) * FPS
	ai["whenwalk"] = (30.0 - (float(d) * 2.0) - (2.0 * float(inmax))) * FPS
	ai["whenview"] = (8.0 - (2.0 * float(inmax))) * FPS
	ai["freezelimit"] = (2.0 - float(inmax)) * FPS
	ai["starelimit"] = (6.0 - (2.0 * float(inmax))) * FPS
	ai["starenotice"] = 3.0 * FPS
	ai["movedelay"] = 0.0 if inmax else 10.0 * FPS
	ai["movesound_group"] = "toy"
	ai["detersound_group"] = "vent"
	ai["scaretype"] = "wait"
	ai["scaresound"] = "scare_toy"
	ai["scare_sprite"] = "sprt_scare_tb"
	ai["maskable"] = true
	ai["frozen_on_flash"] = true
	ai["mask_wait"] = true
	ai["can_stare"] = true
	ai["fast_on_view"] = true
	ai["walkmap"] = [["none", 0, ["showstage"]], ["showstage", 1, ["mainhall", "dininghall"]], ["mainhall", 23, ["dininghall"]], ["dininghall", 13, ["prizecorner", "gamearea", "gamearea"]], ["prizecorner", 15, ["dininghall", "dininghall", "prizecornertb"]], ["prizecornertb", 19, ["dininghall"]], ["gamearea", 32, ["eastpartyroom", "eastpartyroom", "dininghall"]], ["eastpartyroom", 40, ["ventright"]], ["ventright", 0, ["right"]], ["right", 1, ["officeclose"]], ["officeclose", 0, ["you"], ["prizecorner", "mainhall"]]]
	return ai


static func _toy_chica(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_tc if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_tc", d, "showstage", "you")
	ai["perseverance"] = 0.75
	ai["move"] = 0.0 if inmax else -float(randi_range(12, 16)) * FPS
	ai["whenwalk"] = (33.0 - (float(d) * 2.0) - (3.0 * float(inmax))) * FPS
	ai["whenview"] = (8.0 - (2.0 * float(inmax))) * FPS
	ai["freezelimit"] = (4.0 - (3.0 * float(inmax))) * FPS
	ai["starelimit"] = (6.0 - (2.0 * float(inmax))) * FPS
	ai["starenotice"] = 3.0 * FPS
	ai["movedelay"] = 0.0 if inmax else 14.0 * FPS
	ai["movesound_group"] = "toy"
	ai["detersound_group"] = "vent"
	ai["scaretype"] = "wait"
	ai["scaresound"] = "scare_toy"
	ai["scare_sprite"] = "sprt_scare_tc"
	ai["maskable"] = true
	ai["frozen_on_flash"] = true
	ai["mask_wait"] = true
	ai["can_stare"] = true
	ai["fast_on_view"] = true
	ai["walkmap"] = [["none", 0, ["showstage"]], ["showstage", 3, ["mainhall", "dininghall"]], ["dininghall", 12, ["mainhall"]], ["mainhall", 21, ["kitchen", "frontwest"]], ["kitchen", 0, ["mainhall"]], ["frontwest", 4, ["westpartyroom"]], ["westpartyroom", 37, ["ventleft"]], ["ventleft", 0, ["left"]], ["left", 1, ["officeclose"]], ["officeclose", 0, ["you"], ["kitchen", "dininghall"]]]
	return ai


static func _mangle(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_tx if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_tx", d, "kidscovetx1", "you")
	ai["perseverance"] = 0.7 + (0.3 * float(inmax))
	ai["move"] = 0.0 if inmax else -float(randi_range(10, 19)) * FPS
	ai["whenwalk"] = (30.0 - (float(d) * 1.2)) * FPS
	ai["whenview"] = float(randi_range(15, 19)) * FPS
	ai["freezelimit"] = (38.0 - (float(d) * 2.0)) * FPS
	ai["movedelay"] = 15.0 * FPS
	ai["movesound_group"] = "withered"
	ai["detersound_group"] = "withered"
	ai["scaretype"] = "wait"
	ai["scaresound"] = "scare_toyglitch"
	ai["scare_sprite"] = "sprt_scare_tx"
	ai["frozen_on_flash"] = true
	ai["walkmap"] = [["none", 0, ["kidscovetx1"]], ["kidscovetx1", 25, ["kidscovetx3" if inmax else "kidscovetx2"]], ["kidscovetx2", 26, ["kidscovetx3"]], ["kidscovetx3", 27, ["kidscovetx4"]], ["kidscovetx4", 28, ["you" if GameState.mod_insta else "officetx"]], ["officetx", 0, ["you"]]]
	return ai


static func _balloon_boy(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_bb if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_bb", d, "none", "officesp")
	ai["move"] = 0.0 if inmax else -float(1 + randi_range(0, 20)) * FPS
	ai["whenwalk"] = (16.0 - float(d) - (2.0 * float(inmax))) * FPS
	ai["whenview"] = (12.0 - (4.0 * float(inmax))) * FPS
	ai["freezelimit"] = (2.0 + (float(d) / 2.0) + (2.0 * float(inmax))) * FPS
	ai["starelimit"] = 6.0 * FPS
	ai["starenotice"] = 3.0 * FPS
	ai["movedelay"] = 0.0 if inmax else (35.0 - (float(d) * 3.0)) * FPS
	ai["movesound_group"] = "bb"
	ai["detersound_group"] = "bb"
	ai["maskable"] = true
	ai["frozen_on_view"] = true
	ai["no_looked_cams"] = true
	ai["fast_on_view"] = true
	ai["walkmap"] = [["none", 0, ["gamearea"]], ["offpath", 0, ["offpath", "offpath", "dininghall", "mainhall", "kitchen", "prizecorner", "gamearea"]], ["dininghall", 0, ["offpath", "mainhall", "kitchen", "prizecorner", "gamearea", "eastpartyroom"]], ["mainhall", 0, ["offpath", "dininghall", "kitchen", "prizecorner", "gamearea", "westpartyroom"]], ["kitchen", 0, ["offpath", "dininghall", "mainhall", "prizecorner", "gamearea", "westpartyroom", "eastpartyroom"]], ["prizecorner", 0, ["offpath", "dininghall", "mainhall", "kitchen", "gamearea", "westpartyroom", "eastpartyroom"]], ["gamearea", 0, ["offpath", "offpath", "dininghall", "mainhall", "kitchen", "prizecorner"]], ["westpartyroom", 0, ["ventleft"]], ["eastpartyroom", 0, ["ventright"]], ["ventleft", 0, ["left"]], ["ventright", 0, ["right"]], ["left", 2, ["officeclose"]], ["right", 2, ["officeclose"]], ["officeclose", 0, ["officesp"], ["none"]]]
	return ai


static func _withered_freddy(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_wf if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_wf", d, "backstagewf", "you")
	ai["move"] = 0.0 if inmax else -float(randi_range(5, 19)) * FPS
	ai["whenwalk"] = (30.0 - float(d) - (4.0 * float(inmax))) * FPS
	ai["whenview"] = (10.0 - (10.0 * float(inmax))) * FPS
	ai["freezelimit"] = (3.0 - (2.0 * float(inmax))) * FPS
	ai["lifelimit"] = (2.0 + float(inmax)) * FPS
	ai["starelimit"] = 6.0 * FPS
	ai["starenotice"] = 3.0 * FPS
	ai["movedelay"] = 10.0 * FPS
	ai["movesound_group"] = "withered"
	ai["detersound_group"] = "withered"
	ai["scaretype"] = "delay"
	ai["scaresound"] = "scare_withered"
	ai["scare_sprite"] = "sprt_scare_wf"
	ai["frozen_on_view"] = true
	ai["damage_on_flash"] = true
	ai["damage_push"] = true
	ai["loner"] = true
	ai["can_stare"] = true
	ai["must_stare"] = true
	ai["walkmap"] = [["none", 0, ["backstagewf"], ["backstagewf"]], ["backstagewf", 8, ["prizecorner"], ["backstagewf"]], ["prizecorner", 18, ["showstagewf"], ["backstagewf"]], ["showstagewf", 4, ["mainhall"], ["prizecorner"]], ["mainhall", 22, ["kitchenwf"], ["showstagewf"]], ["kitchenwf", 0, ["gameareawf"], ["mainhall"]], ["gameareawf", 34, ["office" if inmax else "frontclose"], ["kitchenwf"]], ["frontclose", 6, ["office"], ["gameareawf"]], ["office", 0, ["you"], ["backstagewf"]]]
	return ai


static func _withered_bonnie(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_wb if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_wb", d, "backstagewb", "you")
	ai["perseverance"] = 0.8 + (0.2 * float(inmax))
	ai["move"] = 0.0 if inmax else -float(randi_range(1, 7)) * FPS
	ai["whenwalk"] = (23.0 - float(d) - (2.0 * float(inmax))) * FPS
	ai["whenview"] = (2.0 - (2.0 * float(inmax))) * FPS
	ai["lifelimit"] = (1.0 + float(inmax)) * FPS
	ai["starelimit"] = 6.0 * FPS
	ai["starenotice"] = 3.0 * FPS
	ai["movedelay"] = 0.0 if inmax else 2.0 * FPS
	ai["movesound_group"] = "withered"
	ai["detersound_group"] = "withered"
	ai["scaretype"] = "delay"
	ai["scaresound"] = "scare_withered"
	ai["scare_sprite"] = "sprt_scare_wb"
	ai["damage_on_flash"] = true
	ai["loner"] = true
	ai["can_stare"] = true
	ai["must_stare"] = true
	ai["walkmap"] = [["none", 0, ["backstagewb"]], ["backstagewb", 7, ["dininghallwb", "offpath"]], ["dininghallwb", 11, ["offpath"]], ["offpath", 0, ["mainhall"]], ["mainhall", 20, ["kitchen", "westpartyroom" if inmax else "frontwest", "westpartyroom" if inmax else "frontwest"]], ["kitchen", 0, ["mainhall"]], ["frontwest", 5, ["westpartyroom"]], ["westpartyroom", 38, ["ventleft"]], ["ventleft", 0, ["office"]], ["office", 0, ["you"], ["backstagewb"]]]
	return ai


static func _withered_chica(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_wc if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_wc", d, "backstagewc", "you")
	ai["perseverance"] = 0.7 + (0.2 * float(inmax))
	ai["move"] = 0.0 if inmax else -float(randi_range(6, 15)) * FPS
	ai["whenwalk"] = (25.0 - float(d) - float(inmax)) * FPS
	ai["whenview"] = (2.0 - (2.0 * float(inmax))) * FPS
	ai["lifelimit"] = 2.0 * FPS
	ai["starelimit"] = 6.0 * FPS
	ai["starenotice"] = 3.0 * FPS
	ai["movedelay"] = 0.0 if inmax else 6.0 * FPS
	ai["movesound_group"] = "withered"
	ai["detersound_group"] = "withered"
	ai["scaretype"] = "delay"
	ai["scaresound"] = "scare_withered"
	ai["scare_sprite"] = "sprt_scare_wc"
	ai["damage_on_flash"] = true
	ai["loner"] = true
	ai["can_stare"] = true
	ai["must_stare"] = true
	ai["walkmap"] = [["none", 0, ["backstagewc"]], ["backstagewc", 9, ["dininghallwc", "prizecorner"]], ["dininghallwc", 14, ["prizecorner", "gamearea", "gamearea"]], ["prizecorner", 16, ["dininghallwc"]], ["gamearea", 33, ["eastpartyroom"]], ["eastpartyroom", 41, ["ventright"]], ["ventright", 0, ["office"]], ["office", 0, ["you"], ["backstagewc"]]]
	return ai


static func _withered_foxy(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_wx if difficulty < 0 else difficulty
	var inmax := d > 10
	var ai: Dictionary = _base_ai("ai_wx", d, "backstage", "you")
	ai["perseverance"] = 0.7 + (0.2 * float(inmax))
	ai["move"] = -float(randi_range(4, 13)) * FPS
	ai["whenwalk"] = (34.0 - (float(d) * 2.5)) * FPS
	ai["whenview"] = (11.0 + (5.0 * float(inmax))) * FPS
	ai["lifelimit"] = FPS
	ai["movedelay"] = 14.0 * FPS
	ai["movesound_group"] = "withered"
	ai["detersound_group"] = "withered"
	ai["scaretype"] = "now"
	ai["scaresound"] = "scare_withered"
	ai["scare_sprite"] = "sprt_scare_wx"
	ai["damage_on_flash"] = true
	ai["damage_push"] = true
	ai["loner"] = true
	ai["walkmap"] = [["none", 0, ["backstage"], ["backstage"]], ["backstage", 5, ["backstagewx"], ["backstage"]], ["backstagewx", 6, ["frontclose" if inmax else "frontwx"], ["backstage"]], ["frontwx", 1, ["frontclose"], ["backstage"]], ["frontclose", 3, ["you"], ["backstage", "backstagewx"]]]
	return ai


static func _golden_freddy(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_gf if difficulty < 0 else difficulty
	var ai: Dictionary = _base_ai("ai_gf", d, "none", "you")
	var inmax := d > 10
	ai["perseverance"] = 0.5 + (0.5 * float(inmax))
	ai["move"] = -float(randi_range(15, 29)) * FPS
	ai["whenwalk"] = (20.0 - float(d)) * FPS
	ai["whenview"] = (3.0 + (2.0 * float(inmax))) * FPS
	ai["looklimit"] = (3.0 - (float(d) * 0.22)) * FPS
	ai["scaresound"] = "scare_phantom"
	ai["scare_sprite"] = "sprt_scare_gf"
	ai["loner"] = true
	ai["no_looked_views"] = true
	ai["walkmap"] = [["none", 0, ["left", "right", "frontclose", "officesp"]], ["left", 3, ["none"]], ["right", 3, ["none"]], ["frontclose", 8, ["none"]], ["officesp", 0, ["none"]]]
	return ai


static func _puppet(difficulty: int = -1) -> Dictionary:
	var d := GameState.lvl_pp if difficulty < 0 else difficulty
	var ai: Dictionary = _base_ai("ai_pp", d, "prizecornerpp", "you")
	ai["whenwalk"] = 500.0
	ai["whenview"] = 700.0
	ai["scaretype"] = "now"
	ai["scaresound"] = "scare_toyglitch"
	ai["scare_sprite"] = "sprt_scare_pp"
	ai["walkmap"] = [["none", 0, ["prizecornerpp"]], ["prizecornerpp", 17, ["offpath"]], ["offpath", 0, ["front"]], ["front", 9, ["you"]]]
	return ai
