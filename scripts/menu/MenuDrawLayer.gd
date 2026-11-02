extends Node2D

var menu: Node2D
var draw_kind := 0


func _draw() -> void:
	if menu == null:
		return
	menu._draw_to_layer(draw_kind, self)
