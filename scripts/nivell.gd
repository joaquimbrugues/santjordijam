extends Node2D

# Carrega els elements de l'escena
@onready var peça: TileMapLayer = $Capes/Peça
@onready var tic_caiguda: Timer = $TicCaiguda
@onready var tic_moviment: Timer = $TicMoviment
@onready var sprite_stamina: AnimatedSprite2D = $Capes/Stamina

# Paràmetres dels temporitzadors de caiguda i moviment
## Interval de temps entre moviments de la peça provocats per la jugadora (esquerra-dreta i rotacions)
@export var INTERVAL_TIC: float = 0.5
## Interval de temps entre moviments verticals de la peça, sense acceleració de la jugadora
@export var INTERVAL_CAIGUDA: float = 0.5
## Interval de temps entre moviments verticals de la peça quan la jugadora prem "avall"
@export var INTERVAL_CAIGUDA_ACCELERAT: float = 0.25
## Interval de temps entre moviments verticals de la peça quan la jugadora prem "amunt"
@export var INTERVAL_CAIGUDA_FRENAT: float = 0.75

# Possibles següents moviments de la peça, segons l'input de la jugadora del teclat
enum Moviments {Cap, Esquerra, Dreta, Gir}
var proper_moviment: Moviments = Moviments.Cap

func _ready() -> void:
	# Crea peça d'exemple
	peça.crea_exemple()
	peça.dibuixa_peça()
	sprite_stamina.inicialitza(INTERVAL_CAIGUDA, INTERVAL_CAIGUDA_FRENAT)



func _process(_delta: float) -> void:
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
			# Mou peça cap a l'esquerra
			proper_moviment = Moviments.Esquerra
		elif Input.is_action_pressed("peça_dreta"):
			# Mou peça cap a la dreta
			proper_moviment = Moviments.Dreta
		elif Input.is_action_pressed("peça_gira"):
			# Gira la peça 90 graus en sentit horari
			#TODO: Possible bug? Sembla que de vegades la peça gira dos cops seguits...
			proper_moviment = Moviments.Gir

# Aquest funció es crida a cada tic del joc, corresponent a la caiguda de la peça,
# i la intentarà fer baixar més.
# TODO: En aquesta funció hem de comprovar les col·lisions que poden fer que una peça passi a formar
# part de l'estructura "construïda"
func _on_tic_caiguda_timeout() -> void:
	# Prepara moviment cap avall
	peça.posicio_seguent = peça.posicio + Vector2i.DOWN
	
	#TODO: Comprovar col·lisions aquí
	# Pla: mirar el mètode _on_tic_moviment_timeout().
	# Addicionalment, cal crear un nou TileMapLayer amb coordenades consistents
	# amb les de Peça, i copiant-ne el TileSet. Afegir l'estructura a la comprovació
	# de col·lisions (és més fàcil que els rectangles), i programar la lògica de
	# despawnejar la Peça i spawnejar a aquest TileMapLayer nou.
	
	# Aplica el moviment de la peça
	peça.actualitza()

# Aquesta funció es crida a cada tic del joc de tetris, i executarà el darrer moviment
# que tingui desat a la variable `proper_moviment`,
# a més de resetejar aquesta variable a Caiguda
func _on_tic_moviment_timeout() -> void:
	match proper_moviment:
		Moviments.Esquerra:
			peça.posicio_seguent = peça.posicio + Vector2i.LEFT
		Moviments.Dreta:
			peça.posicio_seguent = peça.posicio + Vector2i.RIGHT
		Moviments.Gir:
			#TODO: Possible bug? Sembla que de vegades la peça gira dos cops seguits...
			peça.gir_horari()
	
	#TODO: Comprovar col·lisions aquí
	# PLA: Fer servir TileMapLayer.map_to_local() per cada coordenada de peça.posicio_seguent,
	# i tot seguit potser Node2D.to_global() per obtenir la posició absoluta de
	# cada cel·la. Cal testejar si això retorna la posició de la cantonada o el centre
	# de la cel·la. Crear el Rectangle2D (quadrat) de la cel·la en coords absolutes
	# Aleshores, per cadascuna de les tres Vores, extreure'n el Rectangle2D.
	# Llavors ja és fàcil: solament cal utilitzar el mètode Rect2D.intersects()
	
	# Aplica el moviment de la peça
	peça.actualitza()
	# Reinicialitza la variable de proper_moviment a Caiguda (per defecte)
	proper_moviment = Moviments.Cap
