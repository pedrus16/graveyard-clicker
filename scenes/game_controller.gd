class_name GameController extends Node

@onready var world = %World

@export var lobby: Node3D
@export var level_scenes: Array[PackedScene]
@export var gui: Control

var current_world_scene: Node3D
var current_gui_scene: Control
var levels: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_controller = self
	current_world_scene = lobby
	current_gui_scene = gui
	for scene in level_scenes:
		levels.append(scene.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func change_world_scene(node: Node3D) -> void:
	if current_world_scene != null:
		world.remove_child(current_world_scene)
	current_world_scene = node
	world.add_child(node)
