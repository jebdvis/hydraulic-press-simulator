extends Node2D

@onready var targetDetector = $MainBar/ZeroAnchor/PlayerBar/Area2D
@onready var progBar = $TextureProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var posTargets = targetDetector.get_overlapping_areas()
	if posTargets:
		progBar.value += 3
	else:
		progBar.value -= 3
