extends Node3D

@export_range(-1, 3) var level_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		if level_index == -1:
			Global.game_controller.change_world_scene(Global.game_controller.lobby)
		else:
			Global.game_controller.change_world_scene(Global.game_controller.levels[level_index])
