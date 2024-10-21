extends Node2D

@onready var targetDetector = $MainBar/ZeroAnchor/PlayerBar/Area2D
@onready var progBar = $TextureProgressBar
@onready var maxProg = progBar.max_value
@onready var animPlayer = $AnimationPlayer

var progTracker = 0

func _ready():
	animPlayer.set_current_animation("hydraulic-press")
	animPlayer.pause()

func _physics_process(delta):
	print(str(progTracker) + "   " + str(progBar.value))        
	var posTargets = targetDetector.get_overlapping_areas()
	if posTargets:
		progBar.value += 3
		if progBar.value > progTracker:
			progTracker += 3
	else:
		progBar.value -= 3
	ShakeBus.triggerShake(($TextureProgressBar.value/$TextureProgressBar.max_value) * 8, 0)
	if progTracker <= progBar.value and progTracker > 0:
		animPlayer.play()
	else:
		animPlayer.pause()
