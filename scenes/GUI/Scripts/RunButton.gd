extends Button

onready var stop_btn: Button = $"../StopButton"
onready var rev_btn: Button = $"../ReverseButton"

func _pressed():
	WheelParameters.stoped = false
	WheelParameters.reversed = false
	stop_btn.visible = true
	rev_btn.visible = false
	self.visible = false
