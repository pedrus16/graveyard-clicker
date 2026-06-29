extends Node3D

@export var content: int = 4

var Bone = preload("res://scenes/Bone.tscn")

var rng = RandomNumberGenerator.new()
var _open = false

func open(position: Vector3) -> void:
	if _open: return
	_open = true
	%CoffinLid/RigidBody3D.freeze = false
	%CoffinLid/RigidBody3D.apply_impulse(Vector3(0, 10.0, 0), position - %CoffinLid/RigidBody3D.global_position)
	%CoffinLid/RigidBody3D.input_ray_pickable = false
	%AudioStreamPlayer3D.play(0.13)
	
	for i in content:
		var bone: Node3D = Bone.instantiate()
		get_tree().root.add_child(bone)
		bone.global_position = global_position + Vector3(0, 0.2, 0)
		var random_angle = rng.randf_range(0, PI * 2)
		bone.global_rotation += Vector3(0, random_angle, 0)
		var force = 2.0 
		bone.apply_impulse(Vector3(cos(random_angle) * force, 4, sin(random_angle) * force))
		
		var camera = get_viewport().get_camera_3d()
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "global_position", camera.project_position(Vector2(get_viewport().get_visible_rect().size.x * 0.5, 20.0), 2.0), 0.5).set_delay(1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_callback(
			func ():
				bone.queue_free()
				Main.bones += 1
		)
		#get_tree().create_timer(1.0).timeout.connect(
			#func():
			#var camera = get_viewport().get_camera_3d()
			#var tween = get_tree().create_tween()
			#tween.tween_property(bone, "global_position", camera.project_position(Vector2(get_viewport().get_visible_rect().size.x * 0.5, 20.0), 2.0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			#tween.tween_callback(
				#func ():
					#bone.queue_free()
					#Main.bones += 1
			#)
		#)
		await get_tree().create_timer(0.1).timeout


	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		open(event_position)


func _on_rigid_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		open(event_position)
