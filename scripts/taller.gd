extends Area2D

const dimensions: Vector2i = Vector2i(9, 5)

func _process(_delta: float) -> void:
	if arrossegament.peça_arrossegant != null:
		var posicio_local = to_local(arrossegament.peça_arrossegant.global_position) / 36.0
		var posicio_entera = Vector2i(roundi(posicio_local.x), roundi(posicio_local.y))
		if arrossegament.peça_arrossegant.forma.all(func (casella):
			# TODO: Adaptar aquesta lambda a mesura que s'acumulin peces al taller
			var cas = posicio_entera + casella
			return cas.x >= 0 and cas.x < dimensions.x and cas.y >= 0 and cas.y < dimensions.y
		):
			var posicio_global = to_global(posicio_entera * 36)
			arrossegament.peça_arrossegant.fixa_objectiu(posicio_global, self)
		else:
			arrossegament.peça_arrossegant.te_objectiu = false
