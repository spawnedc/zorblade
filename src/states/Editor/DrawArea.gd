extends Node2D

var current_path: Path2D


func _draw():
	if current_path:
		draw_polyline(current_path.curve.get_baked_points(), Color.aquamarine, 1)

		for i in current_path.curve.get_point_count():
			var pos = current_path.curve.get_point_position(i)
			draw_circle(pos, 5, Color.aquamarine)
