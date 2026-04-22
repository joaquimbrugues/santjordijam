extends Area2D

const dimensions: Vector2i = Vector2i(9, 5)

var regions_ocupades: Array[Vector2i]

func _ready() -> void:
	reset()

func reset() -> void:
	regions_ocupades = []

# Calcula les coordenades locals en la graella del taller com a caselles enteres
# Arrodonim les coordenades fraccionals per forçar-les a la graella
func coordenades_enteres(coords: Vector2) -> Vector2i:
	var posicio_local = to_local(coords) / 36.0
	return Vector2i(roundi(posicio_local.x), roundi(posicio_local.y))

func omple_peces(pos_global: Vector2, forma: Array[Vector2i]) -> void:
	var coords_enteres = coordenades_enteres(pos_global)
	for f in forma:
		regions_ocupades.append(f + coords_enteres)

func dins_rectangle(casella: Vector2i) -> bool:
	return casella.x >= 0 and casella.x < dimensions.x and casella.y >= 0 and casella.y < dimensions.y

# Si la construcció és buida, retorna True
# Si hi ha peces construïdes, retorna False si hi ha alguna de les caselles es solapa amb les peces
# Altrament, retorna True només si alguna casella és adjacent a la part construïda (és a dir, es troba exactament a distància entera 1)
func adjacent_a_construccio(caselles: Array[Vector2i]) -> bool:
	if regions_ocupades.is_empty():
		return true
	else:
		var adjacent = false
		for casella in caselles:
			for regio in regions_ocupades:
				if casella == regio:
					return false
				else:
					adjacent = adjacent or ((regio - casella).length_squared() == 1)
		return adjacent

func _process(_delta: float) -> void:
	if arrossegament.peça_arrossegant != null:
		var posicio_entera = coordenades_enteres(arrossegament.peça_arrossegant.global_position)
		var caselles: Array[Vector2i] = []
		for p in arrossegament.peça_arrossegant.forma:
			caselles.append(p + posicio_entera)
		# Comprova que totes les caselles es trobin dins del rectangle i que es troben adjacents al que ja està construït
		if caselles.all(dins_rectangle) and adjacent_a_construccio(caselles):
			var posicio_global = to_global(posicio_entera * 36)
			arrossegament.peça_arrossegant.fixa_objectiu(posicio_global, self)
		else:
			arrossegament.peça_arrossegant.te_objectiu = false
