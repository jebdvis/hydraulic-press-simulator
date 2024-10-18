extends Node

signal shakeTriggered(strength: float, fade: float)


func triggerShake(strength: float, fade:float):
	shakeTriggered.emit(strength, fade)
