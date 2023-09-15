extends Node


func _ready():
	TranslationServer.set_locale("ru")
	ProjectSettings.set_setting("application/config/name", "MAXWELLS_WHEEL")


func change_translation():
	match TranslationServer.get_locale():
		"ru":
			TranslationServer.set_locale("en")
		"en":
			TranslationServer.set_locale("ru")
	get_tree().call_group("translatable", "update_translation")
	ProjectSettings.set_setting("application/config/name", "MAXWELLS_WHEEL")
