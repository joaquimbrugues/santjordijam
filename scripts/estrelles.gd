extends AnimatedSprite2D

# Compta el nombre de (mitges) estrelles que s'haurien d'estar mostrant en aquest moment
var num_mitges_estrelles: int = 0

# Nombre màxim d'estrelles que es poden mostrar en un moment donat
const MAX_MITGES_ESTRELLES: int = 6

func actualitza_estrelles(estrelles: int = 0) -> void:
	num_mitges_estrelles = estrelles
	print(num_mitges_estrelles)
	match num_mitges_estrelles:
		0: play("default")
		1: play("0.5")
		2: play("1")
		3: play("1.5")
		4: play("2")
		5: play("2.5")
		_: play("3")
