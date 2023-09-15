extends Button

onready var rev_btn: Button = $"../ReverseButton"
onready var run_btn: Button = $"../RunButton"

func _pressed():
	WheelParameters.stoped = true
	rev_btn.visible = true
	run_btn.visible = true
	self.visible = false
