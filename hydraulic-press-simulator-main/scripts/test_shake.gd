extends Sprite2D

@export var shakeStrength: float = 3.0
@export var fadeRate:float = 5.0

var rng = RandomNumberGenerator.new()
var currentStrength: float = 0.0

func _ready():
	ShakeBus.shakeTriggered.connect(doShake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentStrength > 0.0:
		#currentStrength = lerp(currentStrength, 0.0, fadeRate * delta)
		offset = Vector2(rng.randf_range(-currentStrength, currentStrength),rng.randf_range(-currentStrength, currentStrength))


func doShake(shakeStrength:float, fade:float):
	currentStrength = shakeStrength
	fadeRate = fade
	
func _input(event):
	pass
