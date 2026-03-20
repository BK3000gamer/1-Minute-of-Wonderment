extends ProgressBar

@export var player: Emu 

func _process(_delta: float) -> void:
	if player:
		value = player.currentStamina
		
		var _sb = get_theme_stylebox("fill")
		
		if value < (max_value * 0.3):
			modulate = Color.RED
		elif value < (max_value * 0.6):
			modulate = Color.ORANGE
		else:
			modulate = Color.GREEN
