extends AcceptDialog

onready var rich_text_label: RichTextLabel = $ScrollContainer/VBoxContainer/RichTextLabel


func _ready() -> void:
	update_translation()


func update_translation() -> void:
	rich_text_label.text = ""
	for i in range (1, 2):
		rich_text_label.text += tr("ABOUT_TEXT_" + str(i)) + "\n\n"
	self.window_title = tr("ABOUT_BTN")


func _on_InfoButton_pressed():
	self.popup_centered()
	self.show()
