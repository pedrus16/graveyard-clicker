extends Node

signal bones_changed(new_amount: int)

var game_controller: GameController

var bones: int = 0:
	set(value):
		bones = value
		bones_changed.emit(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
