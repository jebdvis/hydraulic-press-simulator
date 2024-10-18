extends Sprite2D

@onready var playerBar:= $ZeroAnchor/PlayerBar
@export var barAccel:float = 13.0
@export var barGrav:float = -15.0
@onready var targetInst = preload("res://scenes/target.tscn")


var barVelocity:float = 0.0
var maxBarY:float = 852.0
var readyToMoveTarg:bool = false
var newTargInst


func targetMover(minDistance, maxDistance, moveTime, holdTimeMax, holdTimeMin):
	if readyToMoveTarg == true:
		readyToMoveTarg = false
		readyToMoveTarg = await get_node("ZeroAnchor").get_node("target").targetLoop(minDistance, maxDistance, moveTime, holdTimeMax, holdTimeMin)

func _ready():
	newTargInst = targetInst.instantiate()
	newTargInst.set_name("target")
	get_node("ZeroAnchor").add_child(newTargInst)
	newTargInst.position.y = randf_range(0, maxBarY)
	readyToMoveTarg = true


func _physics_process(delta: float) -> void:
	if readyToMoveTarg == true:
		readyToMoveTarg = false
		readyToMoveTarg = await get_node("ZeroAnchor").get_node("target").targetLoop(200,600,3,4,2)
	if playerBar.position.y <= 0:
		barVelocity = barVelocity * -.5
	elif playerBar.position.y >= maxBarY:
		barVelocity = 0
		playerBar.position.y = maxBarY - 1
		
	if Input.is_action_pressed("onebutton"):
		barVelocity += barAccel * delta
	else:
		barVelocity += barGrav * delta
		
	var testPos = playerBar.position.y + barVelocity
	if testPos <= 0:
		barVelocity = barVelocity * -.5
	elif playerBar.position.y >= maxBarY:
		barVelocity = 0
		playerBar.position.y = maxBarY
	else:
		playerBar.position.y += barVelocity
		
