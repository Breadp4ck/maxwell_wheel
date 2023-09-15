extends Button

onready var stop_btn: Button = $"../StopButton"
onready var run_btn: Button = $"../RunButton"

func _pressed():
	WheelParameters.stoped = false
	WheelParameters.reversed = true
	stop_btn.visible = true
	run_btn.visible = false
	self.visible = false
