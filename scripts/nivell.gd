extends Node2D

# Carrega els elements de l'escena
@onready var peça: TileMapLayer = $Capes/Peça
@onready var tic_caiguda: Timer = $TicCaiguda
@onready var stamina: ProgressBar = $HUD_Esquerra/ContenidorBaix/Stamina

# Constants del tic_caiguda
const INTERVAL_TIC: float = 0.5
const INTERVAL_ACCELERAT: float = 0.25
const INTERVAL_FRENAT: float = 0.75

# Constants per la frenada
@export var tics_frenada = 2	# Quants tics (frenant) aguanta la frenada
@export var recuperacio_frenada = 4	# Quants tics (normals) triga en recuperar-se l'stamina de frenada
var recuperacio_per_segon = float(tics_frenada) / recuperacio_frenada

# Possibles següents moviments de la peça, segons l'input de la jugadora del teclat
enum Moviments {Caiguda, Esquerra, Dreta, Gir}
var proper_moviment: Moviments = Moviments.Caiguda

func _ready() -> void:
	# Crea peça d'exemple
	peça.crea_exemple()
	peça.dibuixa_peça()
	
	# Inicialitza el medidor d'stamina
	stamina.max_value = tics_frenada * INTERVAL_FRENAT
	stamina.set_value_no_signal(stamina.max_value)

func _process(delta: float) -> void:
	# Reacciona als clics de la jugadora
	if Input.is_action_pressed("peça_frena"):
		if stamina.get_value() <= 0.0:
			tic_caiguda.set_wait_time(INTERVAL_TIC)
			stamina.set_value(0.0)
		else:
			tic_caiguda.set_wait_time(INTERVAL_FRENAT)
			stamina.set_value(max(0.0, stamina.get_value() - delta))
	else:
		tic_caiguda.set_wait_time(INTERVAL_TIC)
		stamina.set_value(min(stamina.max_value, stamina.get_value() + (delta * recuperacio_per_segon)))
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

# Per qüestions estètiques: fem desaparèixer la barra d'stamina quan el valor sigui màxim
func _on_stamina_value_changed(value: float) -> void:
	if value >= stamina.max_value:
		stamina.visible = false
	else:
		stamina.visible = true
