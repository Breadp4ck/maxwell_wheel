extends Node

#    ======================= height
#    |     0         0     | indent_top
#    |     |         |     | wire_len
#    |     |         |     |
#    |     |         |     |
#    |     |         |     |
#    |     |         |     |    |
#    |     |         |     |    |   mass * grav
#    |     |         |     |   \'/
#    |     |         |     |
#    |     |  sSSSs  |     | wheel (roller + rod)
#    | ------SSSSSSS------ | cur_pos
#    |       'SSSSS'       | 
#    |                     | indent_btm
#    |                     |
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

const RADIAN: float = 57.29577951308

var grav: float = 9.8 #N/kg
var max_height: float = 0.55 #m
var wire_len: float = 0.5 #m
var mass_roller: float = 0.01 #kg
var mass_disk: float = 0.1 #kg
var radius_roller: float = 0.003 #m
var radius_disk: float = 0.05 #m

var k_energy: float = 0.0 #J
var p_energy: float = 0.0 #J
var vert_vel: float = 0.0 #s
var angle_vel: float = 0.0 #rad/s
var time: float = 0.0 #s
var height: float = 0.0 #m

var time_to_floor: float = 0.0 #s
var angle_acc: float = 0.0 #rad/s^2

var run_speed: float = 1.0
var stoped: bool = true
var reversed: bool = false

const INDENT_BTM = 0.15

signal update_plot_height(arr, cur_pos, max_fun)
signal update_plot_energy_p(arr, cur_pos, max_fun)
signal update_plot_energy_k(arr, cur_pos, max_fun)
signal constants_changed(angle_acc, vertical_acc, period)


func _ready() -> void:
	update_wheel()


func get_angle(_time: float) -> float:
	var mod_time: float = 0.0
	var result: float = 0.0
	
	if _time < 0:
		_time = -_time
	
	match int(_time / get_half_period()) % 4:
		0:
			mod_time = mod(_time, get_half_period())
			result = angle_acc * 0.5*mod_time*mod_time
		1:
			mod_time = get_half_period() - mod(_time, get_half_period())
			result = -angle_acc * 0.5*mod_time*mod_time
		2:
			mod_time = mod(_time, get_half_period())
			result = -angle_acc * 0.5*mod_time*mod_time
		3:
			mod_time = get_half_period() - mod(_time, get_half_period())
			result = angle_acc * 0.5*mod_time*mod_time
	return result


func update_wheel() -> void:
	stoped = true
	angle_acc = mass_total() * grav * radius_roller / (0.5 * mass_disk * \
			(radius_disk*radius_disk + radius_roller*radius_roller) + \
			0.5 * mass_roller * radius_roller*radius_roller + \
			mass_total() * radius_roller*radius_roller)
	time_to_floor = sqrt(2*max_height/(angle_acc*radius_roller))
	emit_signal("constants_changed", angle_acc, angle_acc*radius_roller, 2*time_to_floor)


func update_output_values(_time: float, _length: float) -> void:
	time = _time
	height = max_height - _length
	if _time < 0:
		_time = -_time
	if int(_time / get_half_period()) % 2 == 0:
		angle_vel = angle_acc * mod(_time, get_half_period())
		vert_vel = angle_vel * radius_roller
	else:
		angle_vel = angle_acc * mod(get_half_period()-_time, get_half_period())
		vert_vel = angle_vel * radius_roller
	p_energy = mass_total() * grav * height
	k_energy = mass_total()*grav*max_height - mass_total()*grav*height
	update_plots()


func update_plots() -> void:
	var heights = []
	var cur_pos: int = int(mod(time, get_half_period()*2) * 20 / get_half_period())
	
	for i in range(40):
		heights.append(max_height - abs(get_angle(time_to_floor*i/20)) * radius_roller)
	emit_signal("update_plot_height", heights, cur_pos, max_height)
	
	var p_energys = []
	for i in range(40):
		p_energys.append(mass_total() * heights[i] * grav)
	emit_signal("update_plot_energy_p", p_energys, cur_pos, p_energys[0])

	var k_energys = []
	for i in range(40):
		k_energys.append(mass_total()*grav*max_height - p_energys[i])
	emit_signal("update_plot_energy_k", k_energys, cur_pos, k_energys[20])

func is_stoped() -> bool:
	return self.stoped


func get_speed() -> float:
	var k: float = run_speed
	if reversed:
		k *= -1
	return k


func mass_total() -> float:
	return mass_disk + mass_roller


func get_max_angle() -> float:
	return max_height/radius_roller


func get_half_period() -> float:
	return sqrt(2*max_height/(angle_acc*radius_roller))


func get_max_pos() -> float:
	return max_height + INDENT_BTM


func get_min_pos() -> float:
	return INDENT_BTM


func mod(x: float, y: float) -> float:
	return (x/y - floor(x/y)) * y
