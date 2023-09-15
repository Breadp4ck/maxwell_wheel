extends VBoxContainer

onready var k_energy: Control = $KinematicEnergy
onready var p_energy: Control = $PotentialEnergy
onready var vert_vel: Control = $VerticalVelocity
onready var angle_vel: Control = $AngleVelocity
onready var time: Control = $Time
onready var height: Control = $Height
onready var vert_acc: Control = $VerticalAcceleration
onready var angle_acc: Control = $AngleAcceleration
onready var period: Control = $Period


func _ready() -> void:
	WheelParameters.connect("constants_changed", self, "_on_parameters_updated")


func _physics_process(_delta) -> void:
	k_energy.update_value(WheelParameters.k_energy)
	p_energy.update_value(WheelParameters.p_energy)
	vert_vel.update_value(WheelParameters.vert_vel)
	angle_vel.update_value(WheelParameters.angle_vel)
	time.update_value(WheelParameters.time)
	height.update_value(WheelParameters.height)


func _on_parameters_updated(angle_acc_val: float, vert_acc_val: float, period_val: float) -> void:
	angle_acc.update_value(angle_acc_val)
	vert_acc.update_value(vert_acc_val)
	period.update_value(period_val)
