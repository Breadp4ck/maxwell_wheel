extends Node2D


export(String) var name_y = "Y"
export(bool) var auto_y = true
export(float, 0.001, 100.0) var max_y = 0.001
export(float, 0.001, 100.0) var max_fun = 0.001
export(String) var y_name = ""
export(String) var y_name_suffix = ""
export(String) var sig_name = "update_plot"

var axis: Line2D
var h_lines = []
var v_lines = []

var h_labels = []
var v_labels = []

var zero: Label
var x_label: Label
var y_label: Label

var y_constants = [0.1, 0.5, 1.0, 2.5, 5.0, 10.0, 20.0]
var fun: Line2D

var mult_koef: float = 0.0

var arr = []
var cur_pos: int
var is_filled: bool = false

var triangle_x: Sprite
var triangle_y: Sprite
var circle: Sprite

func _ready() -> void:
	var v_size_x: float = get_viewport().size.x
	var v_size_y: float = get_viewport().size.y
	
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://fonts/RobotoMono/RobotoMono-Bold.ttf")
	
	zero = Label.new()
	x_label = Label.new()
	y_label = Label.new()
	
	zero.text = "0"
	x_label.text = "t, " + tr("SECONDS")
	y_label.text = y_name + ", " + tr(y_name_suffix)
	
	zero.add_color_override("font_color", Color("222"))
	zero.add_font_override("font", dynamic_font)
	zero.get("custom_fonts/font").size = 13
	zero.align = HALIGN_CENTER
	#zero.rect_position.x = v_size_x * 0.08
	#zero.rect_position.y = v_size_y * 0.92
	
	x_label.add_color_override("font_color", Color("222"))
	x_label.add_font_override("font", dynamic_font)
	x_label.get("custom_fonts/font").size = 15
	x_label.align = HALIGN_CENTER
	#x_label.rect_position.x = v_size_x * 0.87
	#x_label.rect_position.y = v_size_y * 0.94
	
	y_label.add_color_override("font_color", Color("222"))
	y_label.add_font_override("font", dynamic_font)
	y_label.get("custom_fonts/font").size = 15
	y_label.align = HALIGN_CENTER
	#y_label.rect_position.x = v_size_x * 0.005
	#y_label.rect_position.y = v_size_y * 0.01
	
	axis = Line2D.new()
	fun = Line2D.new()
	
	axis.width = 5.0
	fun.width = 3.0
	
	axis.default_color = Color("333")
	fun.default_color = Color("E44")
	
	WheelParameters.connect(sig_name, self, "_on_parameters_updated")
	
	update_mult_koef()
	
	axis.set_name("Axis")
	axis.add_point(Vector2(v_size_x * 0.1, v_size_y * 0.1))
	axis.add_point(Vector2(v_size_x * 0.1, v_size_y * 0.9))
	axis.add_point(Vector2(v_size_x * 0.9, v_size_y * 0.9))
	
	for i in range(12):
		v_lines.append(Line2D.new())
		v_lines[i].width = 1.0
		v_lines[i].default_color = Color("999")
		v_lines[i].set_name("VLine")
		v_lines[i].add_point(Vector2(v_size_x * 0.1 + v_size_x * (i-1) * 0.09, -v_size_y * 0.1))
		v_lines[i].add_point(Vector2(v_size_x * 0.1 + v_size_x * (i-1) * 0.09, v_size_y * 1.1))
		self.add_child(v_lines[i])
	
	for i in range(14):
		h_lines.append(Line2D.new())
		h_lines[i].width = 1.0
		h_lines[i].default_color = Color("999")
		h_lines[i].set_name("HLine")
		h_lines[i].add_point(Vector2(-v_size_x * 0.1, v_size_y * 0.9 - v_size_y * (i-1) * 0.07))
		h_lines[i].add_point(Vector2(v_size_x * 1.1, v_size_y * 0.9 - v_size_y * (i-1) * 0.07))
		self.add_child(h_lines[i])
	
	for i in range(4):
		v_labels.append(Label.new())
		v_labels[i].add_color_override("font_color", Color("444"))
		v_labels[i].add_font_override("font", dynamic_font)
		v_labels[i].get("custom_fonts/font").size = 11
		v_labels[i].align = HALIGN_CENTER
		v_labels[i].rect_position.x = v_size_x * 0.07 + v_size_x * (i+1) * 0.18
		v_labels[i].rect_position.y = v_size_y * 0.92
		self.add_child(v_labels[i])
	
	v_labels[0].text = "T/4 "
	v_labels[1].text = "T/2 "
	v_labels[2].text = "3T/4 "
	v_labels[3].text = " T  "
	
	for i in range(5):
		h_labels.append(Label.new())
		h_labels[i].text = String("%3.1f" % (max_y / 5 * (i+1)))
		h_labels[i].add_color_override("font_color", Color("444"))
		h_labels[i].add_font_override("font", dynamic_font)
		h_labels[i].get("custom_fonts/font").size = 10
		h_labels[i].align = HALIGN_CENTER
		h_labels[i].rect_position.x = v_size_x * 0.01
		h_labels[i].rect_position.y = v_size_y * 0.86 - v_size_y * (i+1) * 0.14
		self.add_child(h_labels[i])
	
	for i in range(40):
		fun.add_point(Vector2.ZERO)
	
	triangle_x = Sprite.new()
	triangle_y = Sprite.new()
	triangle_x.texture = load("res://models/triangle/triangle.svg")
	triangle_y.texture = load("res://models/triangle/triangle.svg")
	triangle_x.scale = Vector2(0.013, 0.013)
	triangle_y.scale = Vector2(0.013, 0.013)
	
	circle = Sprite.new()
	circle.texture = load("res://models/circle/circle.svg")
	circle.scale = Vector2(0.016, 0.016)
	
	self.add_child(zero)
	self.add_child(x_label)
	self.add_child(y_label)
	
	triangle_x.transform.origin = Vector2(v_size_x * 0.1, v_size_y * 0.1)
	self.add_child(triangle_x)
	
	triangle_y.transform.origin = Vector2(v_size_x * 0.9, v_size_y * 0.9)
	triangle_y.rotation = PI/2
	self.add_child(triangle_y)
	
	self.add_child(axis)
	self.add_child(fun)
	
	self.add_child(circle)


func _on_parameters_updated(_arr, _cur_pos, _max_fun) -> void:
	cur_pos = _cur_pos
	arr = _arr
	max_fun = _max_fun
	is_filled = true
	update_mult_koef()
	update_size()


func update_mult_koef() -> void:
	if auto_y:
		for i in y_constants:
			if max_fun < i:
				max_y = i
				break
	mult_koef = 0.7 / max_y


func update_size() -> void:
	var v_size_x: float = get_viewport().size.x
	var v_size_y: float = get_viewport().size.y
	
	axis.set_point_position(0, Vector2(v_size_x * 0.1, v_size_y * 0.1))
	axis.set_point_position(1, Vector2(v_size_x * 0.1, v_size_y * 0.9))
	axis.set_point_position(2, Vector2(v_size_x * 0.9, v_size_y * 0.9))
	
	for i in range(12):
		v_lines[i].set_point_position(0, Vector2(v_size_x * 0.1 + v_size_x * (i-1) * 0.09, -v_size_y * 0.1))
		v_lines[i].set_point_position(1, Vector2(v_size_x * 0.1 + v_size_x * (i-1) * 0.09, v_size_y * 1.1))
	
	for i in range(14):
		h_lines[i].set_point_position(0, Vector2(-v_size_x * 0.1, v_size_y * 0.9 - v_size_y * (i-1) * 0.07))
		h_lines[i].set_point_position(1, Vector2(v_size_x * 1.1, v_size_y * 0.9 - v_size_y * (i-1) * 0.07))
	
	for i in range(4):
		v_labels[i].rect_position.x = v_size_x * 0.07 + v_size_x * (i+1) * 0.18
		v_labels[i].rect_position.y = v_size_y * 0.92
	
	for i in range(5):
		h_labels[i].rect_position.x = v_size_x * 0.01
		h_labels[i].rect_position.y = v_size_y * 0.86 - v_size_y * (i+1) * 0.14
	
	for i in range(5):
		h_labels[i].text = String("%4.2f" % (max_y / 5 * (i+1)))
	
	triangle_x.transform.origin = Vector2(v_size_x * 0.1, v_size_y * 0.1)
	triangle_y.transform.origin = Vector2(v_size_x * 0.9, v_size_y * 0.9)
	
	zero.rect_position.x = v_size_x * 0.08
	zero.rect_position.y = v_size_y * 0.92
	x_label.rect_position.x = v_size_x * 0.87
	x_label.rect_position.y = v_size_y * 0.94
	y_label.rect_position.x = v_size_x * 0.005
	y_label.rect_position.y = v_size_y * 0.01
	
	if is_filled:
		for i in range(40):
			fun.set_point_position(i, Vector2(v_size_x*0.1 + v_size_x * 0.018 * i, \
					v_size_y * 0.9 - v_size_y * arr[i] * mult_koef))
		circle.transform.origin = Vector2(v_size_x*0.1 + v_size_x * 0.018 * cur_pos, \
				v_size_y * 0.9 - v_size_y * arr[cur_pos] * mult_koef)


func update_translation() -> void:
	x_label.text = "t, " + tr("SECONDS")
	y_label.text = y_name + ", " + tr(y_name_suffix)


func _on_Viewport_size_changed() -> void:
	update_size()
