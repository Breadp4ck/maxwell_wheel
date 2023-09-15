extends Spatial

onready var p_top = $PointerTop
onready var p_btm = $PointerBottom
onready var wires = $Wires
onready var wheel = $Wheel
onready var disk = $Wheel/disk
onready var roller = $Wheel/roller

var time: float = 0.0
var angle: float = 0.0
var length: float = 0.0

func _ready() -> void:
	update_MW()
	rebuild()
	WheelParameters.update_output_values(time, length)


func update_MW() -> void:
	p_top.global_transform.origin.y = WheelParameters.get_max_pos()
	p_btm.global_transform.origin.y = WheelParameters.get_min_pos()
	wheel.global_transform.origin.y = WheelParameters.get_max_pos()
	wires.scale.y = 1 - WheelParameters.get_max_pos()


func _physics_process(delta) -> void:
	if !WheelParameters.is_stoped():
		time += delta * WheelParameters.get_speed()
		angle = WheelParameters.get_angle(time)
		length = abs(angle * WheelParameters.radius_roller)
		
		wheel.rotation_degrees.x = rad2deg(angle)
		wheel.global_transform.origin.y = WheelParameters.get_max_pos()-length
		wires.scale.y = length + 1 - WheelParameters.max_height - WheelParameters.get_min_pos()
		
		WheelParameters.update_output_values(time, length)


func rebuild() -> void:
	time = 0.0
	length = 0.0
	
	disk.scale.y = WheelParameters.radius_disk * 10
	disk.scale.z = WheelParameters.radius_disk * 10
	disk.scale.x = WheelParameters.radius_disk * 8
	
	roller.scale.y = WheelParameters.radius_roller * 333.33
	roller.scale.z = WheelParameters.radius_roller * 333.33
	
	p_top.global_transform.origin.y = WheelParameters.get_max_pos()
	p_btm.global_transform.origin.y = WheelParameters.get_min_pos()
	wheel.global_transform.origin.y = WheelParameters.get_max_pos()
	wires.scale.y = 1 - WheelParameters.get_max_pos()
	
	WheelParameters.update_output_values(time, length)
