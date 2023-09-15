extends Button


func _pressed() -> void:
	TranslitionServerSetup.change_translation()


func update_translation() -> void:
	self.text = tr("CHANGE_LANGUAGE_BTN")
