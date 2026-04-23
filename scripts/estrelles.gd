extends AnimatedSprite2D

# Nombre màxim d'estrelles que es poden mostrar en un moment donat
const MAX_MITGES_ESTRELLES: int = 6

func _ready() -> void:
	actualitza_estrelles()

func actualitza_estrelles() -> void:
	match puntuacio.puntuacio:
		0: play("default")
		1: play("0.5")
		2: play("1")
		3: play("1.5")
		4: play("2")
		5: play("2.5")
		_: play("3")
