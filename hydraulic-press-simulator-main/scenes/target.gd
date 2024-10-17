extends Node2D

@export var minDistance:float = 650
@export var maxDistance:float = 700
@export var moveTime:float = 3
@export var holdTimeMax:float = 4
@export var holdTimeMin:float = 2

func _ready():
	randomize()

func targetLoop(minDistance, maxDistance, moveTime, holdTimeMax, holdTimeMin) -> bool:
	var selfTarget = randf_range(0, get_parent().get_parent().maxBarY)
	
	while (abs(self.position.y - selfTarget) < minDistance) or (abs(self.position.y - selfTarget) > maxDistance):
		selfTarget = randf_range(0, get_parent().get_parent().maxBarY)
		
	print(self.position.y - selfTarget)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0,selfTarget), moveTime).set_trans(Tween.TRANS_EXPO)

	var timerVar = randf_range(holdTimeMin,holdTimeMin)
	await get_tree().create_timer(timerVar).timeout
	return true
