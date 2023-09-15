extends Spatial

onready var camera_controller = $CameraController
onready var mw = $MaxwellsWheel

signal release_stop_btn()

# Resume camera
func _on_ViewportContainer_mouse_entered():
	camera_controller.is_mouse_entered = true

# Stop camera
func _on_ViewportContainer_mouse_exited():
	camera_controller.is_mouse_entered = false


func _on_ChangeCameraButton_pressed():
	camera_controller.update_state()


func _on_RollerMass_value_changed(signalled_value):
	WheelParameters.mass_disk = signalled_value
	WheelParameters.update_wheel()
	mw.rebuild()
	emit_signal("release_stop_btn")


func _on_RodMass_value_changed(signalled_value):
	WheelParameters.mass_roller = signalled_value
	WheelParameters.update_wheel()
	mw.rebuild()
	emit_signal("release_stop_btn")


func _on_RollerRadius_value_changed(signalled_value):
	WheelParameters.radius_disk = signalled_value
	WheelParameters.update_wheel()
	mw.rebuild()
	emit_signal("release_stop_btn")


func _on_RodRadius_value_changed(signalled_value):
	WheelParameters.radius_roller = signalled_value
	WheelParameters.update_wheel()
	mw.rebuild()
	emit_signal("release_stop_btn")


func _on_MaxHeight_value_changed(signalled_value):
	WheelParameters.max_height = signalled_value
	WheelParameters.update_wheel()
	mw.rebuild()
	emit_signal("release_stop_btn")


func _on_DropButton_pressed():
	WheelParameters.update_wheel()
	mw.rebuild()
	emit_signal("release_stop_btn")
