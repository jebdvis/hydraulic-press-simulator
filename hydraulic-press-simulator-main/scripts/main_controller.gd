extends Node2D

@onready var targetDetector = $MainBar/ZeroAnchor/PlayerBar/Area2D
@onready var progBar = $TextureProgressBar
@onready var maxProg = progBar.max_value
@onready var animPlayer = $AnimationPlayer
@onready var press_go = $press_go
@onready var press_stop = $press_stop
@onready var press_up = $press_up
@onready var hand_move = $hand_move
@onready var squish = $squish
@export var diffLvls:Array[DiffLvls]

var progTracker = 0
var gameRunning: bool
var gameStart = false
var levelCount = 0
var currSoftBody:SoftBody2D
var currLvl: DiffLvls
var press_go_playing = false
var gameEnd = false

func playing():
	var posTargets = targetDetector.get_overlapping_areas()
	if posTargets:
		if press_go_playing == false:
			press_go_playing = true
			press_go.play()
		progBar.value += 3
		if progBar.value > progTracker:
			progTracker += 3
	else:
		if press_go_playing == true:
			press_go_playing = false
			press_go.stop()
			press_stop.play()
		progBar.value -= 3
	ShakeBus.triggerShake(($TextureProgressBar.value/$TextureProgressBar.max_value) * 8, 0)
	if progTracker <= progBar.value and progTracker > 0:
		animPlayer.play()
	else:
		animPlayer.pause()

func _ready():
	gameRunning = false
	hand_move.play()
	animPlayer.play("move-hand")
	currLvl = diffLvls[0]
	currSoftBody = currLvl.softbody.instantiate()
	$Spawner.add_child(currSoftBody)
	squish.play()
	await animPlayer.animation_finished
	hand_move.stop()
	
	

func _physics_process(delta):
	if gameEnd == true:
		if Input.is_action_pressed("onebutton"):
			get_tree().reload_current_scene()
	if $Area2D.get_overlapping_bodies() and gameRunning == false:
		gameRunning = true
		await get_tree().create_timer(1).timeout
		squish.stop()  
		animPlayer.play("move-hand-back")
		hand_move.play()
		await animPlayer.animation_finished
		hand_move.stop()
		$MainBar.instNewTarg(currLvl.minDistance,currLvl.maxDistance,currLvl.moveTime,currLvl.holdTimeMax,currLvl.holdTimeMin)
		animPlayer.set_current_animation("hydraulic-press")
		animPlayer.pause()
		levelCount += 1
		gameStart = true
	if gameRunning == true and levelCount > 0 and gameStart == true:
		playing()
		if progBar.value == maxProg:
			gameStart = false
			gameRunning = false
			animPlayer.stop()
			if press_go_playing == true:
				press_go_playing = false
				press_go.stop()
			$MainBar.newTargInst.queue_free()
			animPlayer.play()
			currSoftBody.queue_free()
			progBar.value = 0
			progTracker = 0
			ShakeBus.triggerShake(($TextureProgressBar.value/$TextureProgressBar.max_value) * 8, 1)
			animPlayer.play("hydraulic-press",-1,-1, true)
			press_up.play()
			await animPlayer.animation_finished
			press_up.stop()
			if levelCount >= diffLvls.size():
				$CanvasLayer.visible = true
				gameEnd = true
			else:
				hand_move.play()
				animPlayer.play("move-hand")
				currLvl = diffLvls[levelCount]
				currSoftBody = currLvl.softbody.instantiate()
				$Spawner.add_child(currSoftBody)
				squish.play()
				await animPlayer.animation_finished
				hand_move.stop()
			
