extends HSlider


func _on_TimeSpeedSlider_value_changed(value):
	WheelParameters.run_speed = value
