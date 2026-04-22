extends Node2D

var escena_peça = preload("res://escenes/peça_arrossegable.tscn")

const dimensions: Vector2i = Vector2i(9, 5)

var regions_ocupades: Array[Vector2i]
var peces: Array[Node2D]

var boto_clicable: bool = false

func _ready() -> void:
	reset()

func reset() -> void:
	regions_ocupades = []
	peces = []
	boto_clicable = false

# Calcula les coordenades locals en la graella del taller com a caselles enteres
# Arrodonim les coordenades fraccionals per forçar-les a la graella
func coordenades_enteres(coords: Vector2) -> Vector2i:
	var posicio_local = to_local(coords) / 36.0
	return Vector2i(roundi(posicio_local.x), roundi(posicio_local.y))

func omple_peces(node: Node2D) -> void:
	var coords_enteres: Vector2i = coordenades_enteres(node.global_position)
	for f in node.forma:
		regions_ocupades.append(f + coords_enteres)
	peces.append(node)

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
	else:
		# No estem arrossegant. Vols prèmer el botó?
		if boto_clicable and Input.is_action_just_pressed("clic_esquerre"):
			$BotoTaller.play("premut")
			$CampanaTaller.play("Tocant")
			if not %Fabricada.has_node("PeçaArrossegable"):
				construeix_peça()
		elif not boto_clicable or Input.is_action_just_released("clic_esquerre"):
			$BotoTaller.play("lliure")
			$CampanaTaller.play("Quieta")

# Calcula la forma de la peça construïda
# Calcula el baricentre de la peça i calcula totes les posicions relatives a
# aquest baricentre de cara a calcular el vector de forma
# A més, calcula l'atles de la peça i retorna'l
# A més a més, retorna el baricentre
func crea_forma_i_atles() -> Array:
	var forma: Array[Vector2i] = []
	var atles: Array[Vector2i] = []
	# Càlcul del baricentre
	var acc: Vector2i = Vector2i.ZERO
	for coord in regions_ocupades:
		acc += coord
	var baricentre = Vector2(acc)/ regions_ocupades.size()
	baricentre = Vector2i(floori(baricentre.x), floori(baricentre.y))
	
	for p in peces:
		var pos = p.position / 36.0
		pos = Vector2i(floori(pos.x), floori(pos.y))
		for f in p.forma:
			var ff = pos + f - baricentre
			forma.append(ff)
		atles.append_array(p.atles)
	return [forma, atles, baricentre]

# Acció a dur a terme quan es prem el botó
func construeix_peça() -> void:
	if peces.size() > 0:
		# Crea la nova peça assemblada
		var res = crea_forma_i_atles()
		var peça_nova = escena_peça.instantiate()
		peça_nova.crea(res[0], res[1])
		peça_nova.dibuixa()
		# Posa la peça nova a l'arbre i imposa-li la posició correcta
		%Fabricada.add_child(peça_nova, true)
		peça_nova.global_position = to_global(Vector2(res[2]))
		# Mou la peça fins al seu lloc
		var tween = get_tree().create_tween()
		var prop = tween.tween_property(peça_nova, "position", Vector2(res[2]) * 36.0, 0.2)
		prop.set_ease(Tween.EASE_OUT)
		# Matar fills
		for p in peces:
			p.queue_free()
		# Buidar
		reset()

# Si el ratolí entra a la regió del botó i no estem arrossegant, fem-lo clicable
func _on_area_boto_mouse_entered() -> void:
	boto_clicable = arrossegament.peça_arrossegant == null

# Si el ratolí abandona la regió del botó, ja no és clicable
func _on_area_boto_mouse_exited() -> void:
	boto_clicable = false
