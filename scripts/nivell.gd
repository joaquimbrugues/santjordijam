extends Node2D

# Carrega els elements de l'escena
@onready var peça: TileMapLayer = $Capes/Peça
@onready var tic_caiguda: Timer = $TicCaiguda

# Constants del tic_caiguda
const INTERVAL_TIC: float = 0.5
const INTERVAL_ACCELERAT: float = 0.25
const INTERVAL_FRENAT: float = 0.75

# Possibles següents moviments de la peça, segons l'input de la jugadora del teclat
enum Moviments {Caiguda, Esquerra, Dreta, Gir}
var proper_moviment: Moviments = Moviments.Caiguda

func _ready() -> void:
	peça.crea_exemple()
	peça.dibuixa_peça()

func _process(_delta: float) -> void:
	# Reacciona als clics de la jugadora
	if Input.is_action_just_pressed("peça_avall"):
		# Accelera cap avall, reduïnt l'interval de temps entre moviments
		tic_caiguda.set_wait_time(INTERVAL_ACCELERAT)
	elif Input.is_action_just_released("peça_avall"):
		# Restableix l'interval de temps entre moviments
		tic_caiguda.set_wait_time(INTERVAL_TIC)
	elif tic_caiguda.get_wait_time() == INTERVAL_TIC:
		# Fem això per assegurar que no estem accelerant ni desaccelerant
		if Input.is_action_pressed("peça_esquerra"):
			# Mou peça cap a l'esquerra
			proper_moviment = Moviments.Esquerra
		elif Input.is_action_pressed("peça_dreta"):
			# Mou peça cap a la dreta
			proper_moviment = Moviments.Dreta
		elif Input.is_action_pressed("peça_gira"):
			# Gira la peça 90 graus en sentit horari
			#TODO: Possible bug? Sembla que de vegades la peça gira dos cops seguits...
			proper_moviment = Moviments.Gir

# Aquesta funció es crida a cada tic del joc de tetris, i executarà el darrer moviment
# que tingui desat a la variable `proper_moviment`,
# a més de resetejar aquesta variable a Caiguda
func _on_tic_caiguda_timeout() -> void:
	match proper_moviment:
		Moviments.Caiguda:
			peça.posicio_seguent = peça.posicio + Vector2i.DOWN
		Moviments.Esquerra:
			peça.posicio_seguent = peça.posicio + Vector2i.LEFT
		Moviments.Dreta:
			peça.posicio_seguent = peça.posicio + Vector2i.RIGHT
		Moviments.Gir:
			#TODO: Possible bug? Sembla que de vegades la peça gira dos cops seguits...
			peça.gir_horari()
	
	#TODO: Comprovar col·lisions aquí
	
	# Aplica el moviment de la peça
	peça.actualitza()
	# Reinicialitza la variable de proper_moviment a Caiguda (per defecte)
	proper_moviment = Moviments.Caiguda
