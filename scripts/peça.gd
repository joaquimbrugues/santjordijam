extends TileMapLayer

# SUPER IMPORTANT: El TileMapLayer `Peça` HA DE COMPARTIR TileSet amb el
# TileMapLayer `Casa`, que representa les peces que ja s'han dipositat a l'estructura
# Els dos TileMapLayers també han de compartir origen de coordenades (position)

## Posició (horitzonal) on ha d'aparèixer la peça, respecte al centre del tauler de tetris
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

# Importa a partir d'un vector de forma i un d'atles (textures)
func importa(forma: Array[Vector2i], atl: Array[Vector2i]):
	forma_actual = forma
	forma_seguent = forma_actual.duplicate()
	posicio = Vector2i(ENTRADA_X, 0)
	posicio_seguent = posicio
	atlas = atl

# Renderitza la peça
func dibuixa_peça():
	for index in forma_actual.size():
		set_cell(posicio + forma_actual[index], 0, atlas[index])

# "Oblida" la posicio i forma seguents
func reset():
	forma_seguent = forma_actual.duplicate()
	posicio_seguent = posicio

# Mou i/o rota la peça
func actualitza():
	clear()
	forma_actual = forma_seguent.duplicate()
	posicio = posicio_seguent
	dibuixa_peça()

# Prepara una rotació en sentit horari
func gir_horari():
	for index in forma_actual.size():
		forma_seguent[index].x = - forma_actual[index].y
		forma_seguent[index].y = forma_actual[index].x

# Obten els rectangles Rect2 (en aquest cas, quadrats) de col·lisió de la peça en la
# posició i forma que tindrà tot seguit, en coordenades globals
func quadrats() -> Array:
	var tile_size = Vector2(tile_set.get_tile_size())
	return forma_seguent.map(func (coord):
		var pos = coord + posicio_seguent
		var coords_abs = to_global(map_to_local(pos) - (tile_size / 2.0))
		return Rect2(coords_abs, tile_size)
	)
