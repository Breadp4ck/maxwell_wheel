extends HBoxContainer

onready var rev_btn: Button = $"ReverseButton"
onready var run_btn: Button = $"RunButton"
onready var stop_btn: Button = $"StopButton"


func _ready():
	pass


func _on_World_release_stop_btn():
	rev_btn.visible = true
	run_btn.visible = true
	stop_btn.visible = false
