extends Node2D

var night: Node2D
var draw_kind := 0


func _draw() -> void:
	if night == null:
		return
	night._draw_to_layer(draw_kind, self)
