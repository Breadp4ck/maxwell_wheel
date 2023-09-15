extends AcceptDialog

onready var rich_text_label: RichTextLabel = $RichTextLabel


func _ready() -> void:
	update_translation()


func update_translation() -> void:
	rich_text_label.text = ""
	for i in range (1, 7):
		rich_text_label.text += tr("MANUAL_TEXT_" + str(i)) + "\n\n"
	self.window_title = tr("MANUAL_BTN")


func _on_InstructionsButton_pressed() -> void:
	self.popup_centered()
	self.show()
