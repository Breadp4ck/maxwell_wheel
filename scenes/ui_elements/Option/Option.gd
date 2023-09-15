extends Control

export(String) var label_text = "Cutic energy"
export(String) var suffix = "J"
export(float) var range_from = 0.5
export(float) var range_to = 2.0
export(float) var range_step = 0.1
export(float) var default_value = 1.0

onready var label: Label = $HBoxContainer/Label
onready var spin_box: SpinBox = $HBoxContainer/VBoxContainer/SpinBox
onready var slider: HSlider = $HBoxContainer/VBoxContainer/HSlider

var signalled_value: float = default_value
signal value_changed(signalled_value)

func _ready():
	spin_box.min_value = range_from
	spin_box.max_value = range_to
	spin_box.step = range_step
	spin_box.value = default_value
	

	slider.min_value = range_from
	slider.max_value = range_to
	slider.step = range_step
	slider.value = default_value
	
	update_translation()
	
	
func update_translation():
	label.text = tr(label_text)
	spin_box.suffix = tr(suffix)


func _on_SpinBox_value_changed(value):
	slider.value = value
	emit_signal("value_changed", value)


func _on_HSlider_value_changed(value):
	spin_box.value = value
	emit_signal("value_changed", value)
