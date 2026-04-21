extends Sprite2D

var escena_peça: PackedScene = preload("res://escenes/peça_arrossegable.tscn")

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

var peces = [i, zeta, essa, O, jota, ela, te]

var seguent_lliure: int

var REGIONS: Array

func _ready() -> void:
	# Prepara les regions de la cua
	REGIONS = [ $Cua1, $Cua2, $Cua3, $Cua4, $Cua5, $Cua6]
	seguent_lliure = 0

# AQUESTA FUNCIÓ ÉS TEMPORAL I NOMÉS FA LA FUNCIÓ D'EXEMPLE
func afegeix_exemple() -> void:
	var forma = peces.pick_random()
	var index = randi_range(0, 4)
	var atles: Array[Vector2i] = [Vector2i(index, 0), Vector2i(index, 0), Vector2i(index, 0), Vector2i(index, 0)]
	var peça_arrossegable = escena_peça.instantiate()
	peça_arrossegable.crea(forma, atles)
	peça_arrossegable.dibuixa()
	
	REGIONS[seguent_lliure].add_child(peça_arrossegable)
	seguent_lliure += 1

# Entrega el primer element de la cua, i elimina'l de la cua
# RETORNA un Array de la forma [Posicions: Array[Vector2i], Atles: Array[Vector2i]]
# IMPORTANT: Cridar només si has cridat hi_ha_objectes i el resultat ha estat True
func dona_primer() -> Array:
	var peça = $Cua1.get_node("PeçaArrossegable")
	$Cua1.remove_child(peça)
	var parella = peça.deconstrueix()
	
	# Hauríem de garantir que seguent_lliure > 0 (amb hi_ha_objectes)
	# (És possible que entrem en aquest bucle 0 vegades, si seguent_lliure = 1)
	for index in range(1, seguent_lliure):
		var filla = REGIONS[index].get_node("PeçaArrossegable")
		REGIONS[index].remove_child(filla)
		REGIONS[index - 1].add_child(filla, true)
	seguent_lliure -= 1
	return parella

func hi_ha_lloc() -> bool:
	return seguent_lliure < MAXIM_OBJECTES

func hi_ha_objectes() -> bool:
	return seguent_lliure > 0

# A tall d'exemple: afegeix una peça d'exemple
func _on_entra_peça_timeout() -> void:
	# Primer, mira si hi ha lloc!
	if hi_ha_lloc():
		afegeix_exemple()
