extends Node2D

# Carrega els elements de l'escena
@onready var peça: TileMapLayer = $Capes/Peça
@onready var tic_caiguda: Timer = $TicCaiguda

# Possibles següents moviments de la peça, segons l'input de la jugadora del teclat
enum Moviments {Caiguda, Avall, Frena, Esquerra, Dreta, Gir}
var proper_moviment: Moviments = Moviments.Caiguda

func _ready() -> void:
	peça.crea_exemple()
	peça.dibuixa_peça()

# Aquesta funció es crida a cada tic del joc de tetris, i executarà el darrer moviment
# que tingui desat a la variable `proper_moviment`,
# a més de resetejar aquesta variable a Caiguda
func _on_tic_caiguda_timeout() -> void:
	match proper_moviment:
		Moviments.Caiguda:
			peça.posicio_seguent = peça.posicio + Vector2i.DOWN
			print("La peça cau avall")
		Moviments.Avall:
			#TODO
			print("La peça cau 3 posicions avall!")
		Moviments.Frena:
			#TODO
			print("La peça cau 1 posició avall!")
		Moviments.Esquerra:
			#TODO
			print("La peça es mou 1 posició a l'esquerra!")
		Moviments.Dreta:
			#TODO
			print("La peça es mou 1 posició a la dreta!")
		Moviments.Gir:
			#TODO
			print("La peça gira 90 graus en sentit horari!")
	
	#TODO: Comprovar col·lisions aquí
	
	# Aplica el moviment de la peça
	peça.actualitza()
	# Reinicialitza la variable de proper_moviment a Caiguda (per defecte)
	proper_moviment = Moviments.Caiguda
