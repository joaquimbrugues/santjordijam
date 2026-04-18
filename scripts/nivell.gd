extends Node2D

# Carrega els elements de l'escena
@onready var peça: TileMapLayer = $Capes/Peça
@onready var tic_caiguda: Timer = $TicCaiguda
@onready var tic_moviment: Timer = $TicMoviment
@onready var sprite_stamina: AnimatedSprite2D = $Capes/Stamina
@onready var vora_esquerra: CollisionShape2D = $Capes/FGTetris/VoresTetris/VoraEsquerra
@onready var vora_dreta: CollisionShape2D = $Capes/FGTetris/VoresTetris/VoraDreta
@onready var vora_terra: CollisionShape2D = $Capes/FGTetris/VoresTetris/VoraTerra
var VORES

# Paràmetres dels temporitzadors de caiguda i moviment
## Interval de temps (en segons) entre moviments de la peça provocats per la jugadora (esquerra-dreta i rotacions)
@export var INTERVAL_TIC: float = 0.5
## Interval de temps (en segons) entre moviments verticals de la peça, sense acceleració de la jugadora
@export var INTERVAL_CAIGUDA: float = 0.5
## Interval de temps (en segons) entre moviments verticals de la peça quan la jugadora prem "avall"
@export var INTERVAL_CAIGUDA_ACCELERAT: float = 0.25
## Interval de temps (en segons) entre moviments verticals de la peça quan la jugadora prem "amunt"
@export var INTERVAL_CAIGUDA_FRENAT: float = 0.75

# Possibles següents moviments de la peça, segons l'input de la jugadora del teclat
## Quants segons cal prèmer una tecla de moviment (esquerra, dreta, o gir) per tal de provocar
## el moviment
@export var sensibilitat_moviment: float = 0.1
# Medeix el "moviment acumulat" en cadascuna de les direccions,
# respectivament Esquerra, Dreta i Avall
var Moviments = [0.0, 0.0, 0.0]

func _ready() -> void:
	# Crea peça d'exemple
	peça.crea_exemple()
	peça.dibuixa_peça()
	
	# Inicialitza els elements del joc
	sprite_stamina.inicialitza(INTERVAL_CAIGUDA, INTERVAL_CAIGUDA_FRENAT)
	# Inicialitza col·lecció de vores (Rect2)
	VORES = [vora_esquerra, vora_dreta, vora_terra].map(func (vora) -> Rect2:
		var rect = vora.get_shape().get_rect()
		rect.position = vora.to_global(rect.position)
		return rect
		)

func _process(delta: float) -> void:
	# Reacciona als clics de la jugadora
	if Input.is_action_pressed("peça_frena") and sprite_stamina.pot_frenar():
		# Frena, augmentant l'interval entre moviments verticals
		tic_caiguda.set_wait_time(INTERVAL_CAIGUDA_FRENAT)
	elif Input.is_action_pressed("peça_avall"):
		# Accelera avall, reduïnt l'interval entre moviments verticals
		tic_caiguda.set_wait_time(INTERVAL_CAIGUDA_ACCELERAT)
	else:
		# No hi ha cap efecte sobre el moviment vertical, posem l'interval de temps per defecte
		tic_caiguda.set_wait_time(INTERVAL_TIC)
	
	# Moviments laterals/rotació
	if Input.is_action_pressed("peça_esquerra"):
		# Acumula moviment cap a l'esquerra
		Moviments[0] += delta
	if Input.is_action_pressed("peça_dreta"):
		# Acumula moviment cap a la dreta
		Moviments[1] += delta
	if Input.is_action_pressed("peça_gira"):
		# Acumula moviment cap al gir
		Moviments[2] += delta

# Retorna `true` si el moviment projectat de la peça intersecta amb una de les vores o
# amb una peça existent, o `false` altrament
func collisio() -> bool:
	# Col·lisió amb les vores
	for casella in peça.quadrats():
		for rect_vora in VORES:
			if casella.intersects(rect_vora):
				return true
	
	# Col·lisió amb la part construïda
	for p in peça.forma_seguent:
		if $Capes/Casa.get_cell_source_id(p + peça.posicio_seguent) != -1:
			return true
	
	return false

# Elimina les caselles que es troben ara mateix a `Peça` i afegeix-les a la capa
# `Casa`. Crea una nova peça
func transicio_peça() -> void:
	for index in peça.forma_actual.size():
		$Capes/Casa.set_cell(peça.posicio + peça.forma_actual[index], 0, peça.atlas[index])
	
	peça.esborra_peça()
	
	#TODO: Cua aquí
	# Crea peça d'exemple
	peça.crea_exemple()
	peça.dibuixa_peça()

# Aquest funció es crida a cada tic del joc, corresponent a la caiguda de la peça,
# i la intentarà fer baixar més.
# TODO: En aquesta funció hem de comprovar les col·lisions que poden fer que una peça passi a formar
# part de l'estructura "construïda"
func _on_tic_caiguda_timeout() -> void:
	# Prepara moviment cap avall
	peça.posicio_seguent = peça.posicio + Vector2i.DOWN
	
	# Comprova col·lisions
	if collisio():
		transicio_peça()
	else:
		# Aplica el moviment de la peça
		peça.actualitza()

# Aquesta funció es crida a cada tic del joc de tetris, i executarà el darrer moviment
# que tingui desat a la variable `proper_moviment`,
# a més de resetejar aquesta variable a Caiguda
func _on_tic_moviment_timeout() -> void:
	# Prepara el proper moviment de la peça en la direcció que sigui pertinent
	if Moviments[0] > sensibilitat_moviment:
		peça.posicio_seguent = peça.posicio + Vector2i.LEFT
		Moviments[0] = 0.0	# Reinicialitza el medidor del moviment
	elif Moviments[1] > sensibilitat_moviment:
		peça.posicio_seguent = peça.posicio + Vector2i.RIGHT
		Moviments[1] = 0.0	# Reinicialitza el medidor del moviment
	elif Moviments[2] > sensibilitat_moviment:
		peça.gir_horari()
		Moviments[2] = 0.0	# Reinicialitza el medidor del moviment
	
	# Comprova col·lisions
	if collisio():
		# La peça no es pot moure
		peça.reset()
	else:
		# Aplica el moviment de la peça
		peça.actualitza()
