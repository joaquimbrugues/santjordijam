extends TileMapLayer

# Posició (horitzonal) on ha d'aparèixer la peça
@export var ENTRADA_X: int = 0

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

var forma_actual: Array[Vector2i]	# Forma actual de la peça
var forma_seguent: Array[Vector2i]	# Forma de la peça al següent pas

var posicio: Vector2i	# Posició actual de la peça
var posicio_seguent: Vector2i	# Posició de la peça al següent pas

var atlas: Array[Vector2i]	# Coordenades dins del TileSet de les textures de la peça
# IMPORTANT: Els índexs d'`atlas` han de coincidir amb els de `forma_actual` i els de `forma_seguent`

# Funció usada només per a debugar
func crea_exemple():
	forma_actual = peces.pick_random()
	forma_seguent = forma_actual
	posicio_seguent = posicio
	posicio = Vector2i(ENTRADA_X, 0)
	var index = randi_range(0, 7)
	atlas = [Vector2i(index, 0), Vector2i(index, 0), Vector2i(index, 0), Vector2i(index, 0)]
	
# Renderitza la peça
func dibuixa_peça():
	for index in forma_actual.size():
		set_cell(posicio + forma_actual[index], 0, atlas[index])

# Esborra la peça
func esborra_peça():
	for p in forma_actual:
		erase_cell(posicio + p)

# Mou i/o rota la peça
func actualitza():
	esborra_peça()
	forma_actual = forma_seguent
	posicio = posicio_seguent
	dibuixa_peça()
