extends Node3D

@export var loot: Array[PackedScene]
@export var graves: Array[Grave]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	
	var empty_graves: Array[Grave] = graves.duplicate()
	for item in loot:
		var random_index = rng.randi_range(0, empty_graves.size() - 1)
		empty_graves[random_index].content = item
		empty_graves.pop_at(random_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
