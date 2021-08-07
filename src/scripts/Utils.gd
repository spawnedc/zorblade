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


func format_number(n):
	n = String(n)
	var size = n.length()
	var s = ""

	for i in range(size):
		if (size - i) % 3 == 0 and i > 0:
			s = str(s, ",", n[i])
		else:
			s = str(s, n[i])

	return s


func load_json(path: String):
	var file = File.new()
	var file_open_result = file.open("res://data/" + path + ".json", file.READ)

	if file_open_result != OK:
		return null

	var text = file.get_as_text()
	file.close()

	return JSON.parse(text).result
