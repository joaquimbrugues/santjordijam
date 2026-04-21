extends Sprite2D

# TileMapLayer amb els dibuixos dels elements de la cua
@onready var objectes_cua: TileMapLayer = $ObjectesCua

## Màxim d'objectes que pot haver-hi a la cua (independentment de si es poden renderitzar)
@export var MAXIM_OBJECTES: int = 6

#Peces bàsiques del tetris desades com a vectors de coordenades enteres
#(0,0) és el pivot
# Aquestes coordenades només serveixen com a exemple per debugar!
const i : Array[Vector2i] = [Vector2i(0,0), Vector2i(-1,0), Vector2i(-2,0), Vector2i(1,0)]
const zeta : Array[Vector2i] = [Vector2i(0,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(1,1)]
const essa : Array[Vector2i] = [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(-1,1)]
const O : Array[Vector2i] = [Vector2i(0,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(-1,1)]
const jota : Array[Vector2i] = [Vector2i(0,0), Vector2i(-1,0), Vector2i(1,0), Vector2i(1,1)]
const ela : Array[Vector2i] = [Vector2i(0,0), Vector2i(-1,0), Vector2i(-1,1), Vector2i(1,0)]
const te : Array[Vector2i] = [Vector2i(0,0), Vector2i(-1,0), Vector2i(1,0), Vector2i(0,1)]

var peces := [i, zeta, essa, O, jota, ela, te]

var CUA: Array = []

var MARCADORS: Array

func _ready() -> void:
	# Prepara els marcadors de la cua
	MARCADORS = [ $Cua1, $Cua2, $Cua3, $Cua4, $Cua5, $Cua6]

# AQUESTA FUNCIÓ ÉS TEMPORAL I NOMÉS FA LA FUNCIÓ D'EXEMPLE
func afegeix_exemple() -> void:
	var primera = peces.pick_random()
	var index = randi_range(0, 4)
	var atlas: Array[Vector2i] = [Vector2i(index, 0), Vector2i(index, 0), Vector2i(index, 0), Vector2i(index, 0)]
	CUA.push_back([primera , atlas])
	
	# Renderitza els objectes de la cua
	objectes_cua.clear()
	dibuixa_cua()

func dibuixa_cua() -> void:
	var index = 0
	while index < MARCADORS.size() and index < CUA.size():
		# Renderitza la peça CUA[index] al marcador MARCADORS[index]
		var parella = CUA[index]
		for j in parella[0].size():
			objectes_cua.set_cell(
				objectes_cua.local_to_map(MARCADORS[index].get_position()) + parella[0][j],
				0,
				parella[1][j]
			)
		index += 1

# Entrega el primer element de la cua, i elimina'l
# Torna a renderitzar els elements de la cua
# RETORNA un Array de la forma [Posicions: Array[Vector2i], Atles: Array[Vector2i]] 
func dona_primer() -> Array:
	var parella = CUA.pop_front()
	objectes_cua.clear()
	dibuixa_cua()
	return parella

func hi_ha_lloc() -> bool:
	return CUA.size() < MAXIM_OBJECTES
