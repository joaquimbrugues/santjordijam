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

func _process(_delta: float) -> void:
	if arrossegament.peça_arrossegant != null:
		var posicio_entera = coordenades_enteres(arrossegament.peça_arrossegant.global_position)
		if arrossegament.peça_arrossegant.forma.all(func (casella):
			var cas = posicio_entera + casella
			if not (cas.x >= 0 and cas.x < dimensions.x and cas.y >= 0 and cas.y < dimensions.y):
				return false
			else:
				if regions_ocupades.find(cas) != -1:
					return false
			return true
		):
			var posicio_global = to_global(posicio_entera * 36)
			arrossegament.peça_arrossegant.fixa_objectiu(posicio_global, self)
		else:
			arrossegament.peça_arrossegant.te_objectiu = false
