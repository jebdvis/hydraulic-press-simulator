extends Sprite2D

@onready var playerBar:= $PlayerBarAnchor/PlayerBar
@export var barAccel:float = 10.0
@export var barGrav:float = -15.0


var barVelocity:float = 0.0
var maxBarY:float = 852.0


func _ready():
	pass


func _physics_process(delta: float) -> void:
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
