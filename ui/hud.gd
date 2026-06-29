extends Control

func update_bones(amount: int) -> void:
	%Label.text = "%d" % amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Main.bones_changed.connect(update_bones)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
