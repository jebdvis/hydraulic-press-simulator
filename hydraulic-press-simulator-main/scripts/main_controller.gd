extends Node2D

@onready var targetDetector = $MainBar/ZeroAnchor/PlayerBar/Area2D
@onready var progBar = $TextureProgressBar
@onready var maxProg = progBar.max_value
@onready var animPlayer = $AnimationPlayer

var progTracker = 0
var gameRunning: bool
var levelCount: int
var currSoftBody:SoftBody2D

func playing():
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

func _ready():
	levelCount = 0
	gameRunning = false
	currSoftBody = $SoftBody2D
	animPlayer.play("move-hand")

func _physics_process(delta):
	if $Area2D.get_overlapping_bodies() and gameRunning == false:
		gameRunning = true
		animPlayer.play("move-hand",-1,-1,true)
		await animPlayer.animation_finished
		$MainBar.instNewTarg(300,400,3,4,2)
		animPlayer.set_current_animation("hydraulic-press")
		animPlayer.pause()
		levelCount += 1
	if gameRunning == true and levelCount > 0:
		playing()
		if progBar.value == maxProg:
			$MainBar.newTargInst.queue_free()
			currSoftBody.queue_free()
			progBar.value = 0
			progTracker = 0
			ShakeBus.triggerShake(($TextureProgressBar.value/$TextureProgressBar.max_value) * 8, 1)
			gameRunning = false
			animPlayer.animation_set_next("hydraulic-press","move-hand")
			animPlayer.play_backwards("hydraulic-press")
		
	pass
