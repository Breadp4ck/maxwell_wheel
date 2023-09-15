extends Label


func _on_TimeSpeedSlider_value_changed(value):
	self.text = 'x' + String("%2.1f" % value)
