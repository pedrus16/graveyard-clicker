class_name Pickup extends Node

@export var rigidBody: RigidBody3D

const GROUND_PLANE = Plane(Vector3.UP, 0.0)
const RAY_LENGTH = 1000.0

var picking: bool = false
var pickup_offset: Vector2 = Vector2.ZERO
var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not rigidBody: return

	camera = get_viewport().get_camera_3d()
	rigidBody.connect("input_event", _on_collision_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if picking:
		var mouse_position = get_viewport().get_mouse_position()
		var ground_location = _get_ground_click_location(mouse_position - pickup_offset)
		rigidBody.global_position = ground_location + Vector3(0, 1, 0)


func _on_collision_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		if not picking:
			_start_pickup(event.position)
			

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed:
		picking = false
		rigidBody.freeze = false


func _start_pickup(position: Vector2) -> void:
	picking = true
	pickup_offset = position - camera.unproject_position(rigidBody.global_position)
	rigidBody.freeze = true


func _get_ground_click_location(mouse_position: Vector2) -> Variant:
	var ray_from = camera.project_ray_origin(mouse_position)
	var ray_to = ray_from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	return GROUND_PLANE.intersects_ray(ray_from, ray_to)
