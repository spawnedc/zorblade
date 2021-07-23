extends Node


func array_to_curve(input: Array, dist: float = 0) -> Curve2D:
	#dist determines length of controls, set dist = 0 for no smoothing
	var curve = Curve2D.new()

	#calculate first point
	var start_dir = input[0].direction_to(input[1])
	curve.add_point(input[0], -start_dir * dist, start_dir * dist)

	#calculate middle points
	for i in range(1, input.size() - 1):
		var dir = input[i - 1].direction_to(input[i + 1])
		curve.add_point(input[i], -dir * dist, dir * dist)

	#calculate last point
	var end_dir = input[-1].direction_to(input[-2])
	curve.add_point(input[-1], -end_dir, end_dir)

	return curve
