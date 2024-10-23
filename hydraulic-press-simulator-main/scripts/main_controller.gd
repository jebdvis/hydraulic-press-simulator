extends Node2D

@onready var targetDetector = $MainBar/ZeroAnchor/PlayerBar/Area2D
@onready var progBar = $TextureProgressBar
@onready var maxProg = progBar.max_value
@onready var animPlayer = $AnimationPlayer
@export var diffLvls:Array[DiffLvls]

var progTracker = 0
var gameRunning: bool
var levelCount = 0
var currSoftBody:SoftBody2D
var currLvl: DiffLvls

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
	gameRunning = false
	animPlayer.play("move-hand")
	currLvl = diffLvls[0]
	currSoftBody = currLvl.softbody.instantiate()
	$Spawner.add_child(currSoftBody)
	

func _physics_process(delta):
	print(animPlayer.is_playing())
	if $Area2D.get_overlapping_bodies() and gameRunning == false:
		gameRunning = true
		animPlayer.play_backwards("move-hand")
		await animPlayer.animation_finished
		$MainBar.instNewTarg(currLvl.minDistance,currLvl.maxDistance,currLvl.moveTime,currLvl.holdTimeMax,currLvl.holdTimeMin)
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
			animPlayer.play("hydraulic-press",-1,-1,true)
			await animPlayer.animation_finished
			if levelCount -1 > diffLvls.size():
				print("uhhhh game should end")
				#end game statement
				pass
			animPlayer.play("move-hand")
			currLvl = diffLvls[levelCount]
			currSoftBody = currLvl.softbody.instantiate()
			$Spawner.add_child(currSoftBody)
			await animPlayer.animation_finished
			gameRunning = false
			
