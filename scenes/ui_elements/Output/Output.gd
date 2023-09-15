extends Control

export(String) var label = "Cutic energy"
export(String) var suffix = "J"

onready var name_label: Label = $HBoxContainer/Name
onready var value_label: Label = $HBoxContainer/Value

var value: float = 0.0


func _ready() -> void:
	update_translation()


func update_translation() -> void:
	name_label.text = tr(label)
	update_value_label()


func update_value(_value) -> void:
	value = _value
	update_value_label()


func update_value_label() -> void:
	value_label.text = String("%6.3f" % value) + ' ' + tr(suffix)
