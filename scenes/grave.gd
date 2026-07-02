class_name Grave extends Node3D

var rng = RandomNumberGenerator.new()

@export_range(1, 1000) var clicks_to_open: int = 1
@export_range(0.0, 5.0) var min_range: float = 0.6
@export_range(0.0, 5.0) var max_range: float = 0.8
@export var curve: Curve
@export var duration: float = 0.4
@export var height: float = 1.2
@export var content: PackedScene


var dirt_height: float = -0.2
var clicks: int = 0:
	set(value):
		clicks = value
		var ratio = min(1, float(clicks) / float(clicks_to_open))
		%Grave.position = ratio * Vector3(0, dirt_height, 0)
		%"GraveHole".show()
		%"grave-border".position = Vector3(0, 0, 0)
		
		if clicks >= clicks_to_open:
			open = true

@onready var open: bool = false:
	set(value):
		if open == value: return
		open = value
		if value:
			%Grave.hide()
			%"GraveHole".show()
			#%GPUParticles3D.emitting = true
			
			if content:
				%AudioPop.play(0.13)
				var instance: Node3D = content.instantiate()
				get_tree().root.add_child(instance)
				instance.global_position = global_position
				
				var random_distance = rng.randf_range(min_range, max_range)
				var random_angle = global_rotation.y + PI
				var random_position = Vector2(cos(random_angle), sin(random_angle)) * random_distance
				var random_rotation =  rng.randf_range(-PI * 0.05, PI * 0.05)
				
				instance.global_rotation = global_rotation + Vector3(0, random_rotation, 0)
				
				var tween = get_tree().create_tween().set_parallel()
				tween.tween_property(instance, "global_position", Vector3(random_position.x, 0.0, random_position.y), duration).as_relative()
				tween.tween_property(instance, "global_position:y", height, duration).as_relative().set_custom_interpolator(
					func (progress):
						return curve.sample_baked(progress)
				)
				tween.set_parallel().tween_property(instance, "global_rotation", global_rotation + Vector3(0, random_rotation, 0), 0.25)
				tween.tween_callback(
					func ():
						pass
				)
		else:
			%Grave.show()
			%"GraveHole".hide()
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func dig() -> void:
	if (clicks >= clicks_to_open): return
	%AudioDig.play()
	var gpu_particles: GPUParticles3D = %GPUParticles3D.duplicate()
	gpu_particles.restart()
	gpu_particles.finished.connect(
		func ():
			gpu_particles.queue_free()
	)
	add_child(gpu_particles)
	
	clicks += 1
	
func reset() -> void:
	clicks = 0
	open = false

func _on_static_body_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		dig()
