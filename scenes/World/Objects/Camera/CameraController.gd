extends Spatial

export(float) var camera_acc = 0.5

export(float) var camrot_v_max = 45.0
export(float) var camrot_v_min = -45.0

onready var cam_dflt: Camera = $Default/Camera
onready var cam_dflt_controller: Spatial = $Default
onready var cam_ortc: Camera = $Ortographic/Camera

enum CAM_STATE {
	DEFAULT,
	ORTOGRAPHIC,
}

var camrot_h: float = 0.0
var camrot_v: float = 0.0

var is_mouse_entered: bool = true
var is_mouse_pressed: bool = false
var locked: bool = false
var scale_step: Vector3 = Vector3(0.1, 0.1, 0.1)

var state = CAM_STATE.DEFAULT

func _ready() -> void:
	cam_dflt.size = 5.0
	camrot_h += 45.0
	camrot_v += -13.0
	cam_dflt_controller.scale = Vector3(0.7, 0.7, 0.7)
	change_state(CAM_STATE.DEFAULT)

func _input(event) -> void:
	if is_mouse_entered and state == CAM_STATE.DEFAULT:
		if Input.is_action_pressed("drag_camera") and event is InputEventMouseMotion:
			camrot_h += -event.relative.x
			camrot_v += -event.relative.y
		if event.is_action_pressed("zoom_in") and cam_dflt_controller.scale.x > 0.2:
			cam_dflt_controller.scale -= scale_step
		if event.is_action_pressed("zoom_out") and cam_dflt_controller.scale.x < 1.2:
			cam_dflt_controller.scale += scale_step


func _physics_process(_delta) -> void:
	if state == CAM_STATE.DEFAULT:
		cam_dflt_controller.rotation_degrees.y = camrot_h * camera_acc
		cam_dflt_controller.rotation_degrees.x = camrot_v * camera_acc


func update_state() -> void:
	if state < CAM_STATE.size()-1:
		change_state(state+1)
	else:
		change_state(0)


func change_state(_state) -> void:
	self.state = _state
	
	match state:
		CAM_STATE.DEFAULT:
			cam_dflt.current = true
			cam_ortc.current = false
		CAM_STATE.ORTOGRAPHIC:
			cam_dflt.current = false
			cam_ortc.current = true
