extends Node2D

@onready var targetDetector = $MainBar/ZeroAnchor/PlayerBar/Area2D
@onready var progBar = $TextureProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var posTargets = targetDetector.get_overlapping_areas()
	if posTargets:
		progBar.value += 3
	else:
		progBar.value -= 3
	ShakeBus.triggerShake(($TextureProgressBar.value/$TextureProgressBar.max_value) * 8, 0)
