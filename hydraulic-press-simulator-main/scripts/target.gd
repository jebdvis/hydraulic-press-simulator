extends Node2D

func _ready():
	randomize()

func targetLoop(minDistance:float, maxDistance:float, moveTime:float, holdTimeMax:float, holdTimeMin:float) -> bool:
	var selfTarget = randf_range(0, get_parent().get_parent().maxBarY)
	
	while (abs(self.position.y - selfTarget) < minDistance) or (abs(self.position.y - selfTarget) > maxDistance):
		selfTarget = randf_range(0, get_parent().get_parent().maxBarY)
		
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0,selfTarget), moveTime).set_trans(Tween.TRANS_QUINT)

	var timerVar = randf_range(holdTimeMin,holdTimeMin)
	await get_tree().create_timer(timerVar).timeout
	return true
