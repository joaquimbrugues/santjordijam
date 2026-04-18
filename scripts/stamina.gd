extends AnimatedSprite2D

# Indicador d'stamina
# Aquesta escena controla tant el display com la lògica de l'escassetat i recuperació d'stamina

## Quants tics (de durada Interval Caiguda Frenat) pot durar l'stamina de frenada com a molt
@export var tics_frenada: int = 2
## Quants tics (de durada Interval Caiguda) triga la barra d'stamina de frenada per recuperar-se de 0 a 100
@export var tics_recuperacio_frenada: int = 4

var max_stamina: float
var stamina: float
var recuperacio_stamina_per_segon: float

# Inicialitza els paràmetres interns del medidor d'stamina (màxim, actual, recuperació per segon)
func inicialitza(temps_caiguda: float, temps_frenant: float) -> void:
	max_stamina = tics_frenada * temps_frenant
	stamina = max_stamina
	recuperacio_stamina_per_segon = 1.0 / (tics_recuperacio_frenada * temps_caiguda)

func pot_frenar() -> bool:
	return stamina > 0.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("peça_frena"):
		if stamina > 0.0:
			stamina = max(0.0, stamina - delta)
			actualitza_imatge()
	else:
		if stamina < max_stamina:
			stamina = min(max_stamina, stamina + (delta * recuperacio_stamina_per_segon))
			actualitza_imatge()

func actualitza_imatge() -> void:
	var percentatge = stamina / max_stamina
	if percentatge < 0.25:
		play("0%")
	elif percentatge < 0.5:
		play("25%")
	elif percentatge < 0.75:
		play("50%")
	elif percentatge < 1.0:
		play("75%")
	else:
		play("100%")
