extends Camera3D

var drag_start_position: Vector3

const GROUND_PLANE = Plane(Vector3.UP, 0)
const RAY_LENGTH = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event):
	if event.is_action_pressed("camera_drag"):
		drag_start_position = _get_ground_click_location(event.position)
	elif event.is_action_released("camera_drag"):
		drag_start_position = Vector3.ZERO
	
	if drag_start_position and event is InputEventMouseMotion:
		var ground_position = _get_ground_click_location(event.position)
		if ground_position:
			position += drag_start_position - _get_ground_click_location(event.position)

func _get_ground_click_location(mouse_position: Vector2) -> Variant:
	var ray_from = project_ray_origin(mouse_position)
	var ray_to = ray_from + project_ray_normal(mouse_position) * far
	return GROUND_PLANE.intersects_ray(ray_from, ray_to)
