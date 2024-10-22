extends Sprite2D

@onready var playerBar:= $ZeroAnchor/PlayerBar
@export var barAccel:float = 13.0
@export var barGrav:float = -15.0
@onready var targetInst = preload("res://scenes/target.tscn")

var minDistance:float
var maxDistance:float
var moveTime:float
var holdTimeMax:float
var holdTimeMin:float

var barVelocity:float = 0.0
var maxBarY:float = 852.0
var readyToMoveTarg:bool = false
var newTargInst




func instNewTarg(minDistance:float, maxDistance:float, moveTime:float, holdTimeMax:float, holdTimeMin:float):
	newTargInst = targetInst.instantiate()
	newTargInst.set_name("target")
	get_node("ZeroAnchor").add_child(newTargInst)
	newTargInst.position.y = randf_range(0, maxBarY)
	readyToMoveTarg = true
	self.minDistance = minDistance
	self.maxDistance = maxDistance
	self.moveTime = moveTime
	self.holdTimeMax = holdTimeMax
	self.holdTimeMin = holdTimeMin
	

func _ready():
	pass


func _physics_process(delta: float) -> void:
	if get_parent().gameRunning:
		if readyToMoveTarg == true:
			readyToMoveTarg = false
			readyToMoveTarg = await get_node("ZeroAnchor").get_node("target").targetLoop(minDistance, maxDistance, moveTime, holdTimeMax, holdTimeMin)
			
	if Input.is_action_pressed("onebutton") and get_parent().gameRunning:
		barVelocity += barAccel * delta
	else:
		barVelocity += barGrav * delta
			
	var testPos = playerBar.position.y + barVelocity
	if testPos <= 0:
		barVelocity = barVelocity * -.5
	elif playerBar.position.y > maxBarY:
		barVelocity = 0
		playerBar.position.y = maxBarY
	else:
		playerBar.position.y += barVelocity
			
