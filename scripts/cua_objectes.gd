extends Sprite2D

var escena_peça: PackedScene = preload("res://escenes/peça_arrossegable.tscn")

## Màxim d'objectes que pot haver-hi a la cua (independentment de si es poden renderitzar)
@export var MAXIM_OBJECTES: int = 6

var seguent_lliure: int

var REGIONS: Array

func _ready() -> void:
	# Prepara les regions de la cua
	REGIONS = [ $Cua1, $Cua2, $Cua3, $Cua4, $Cua5, $Cua6]
	seguent_lliure = 0

# Entrega el primer element de la cua, i elimina'l de la cua
# RETORNA un Array de la forma [Posicions: Array[Vector2i], Atles: Array[Vector2i]]
# IMPORTANT: Cridar només si has cridat hi_ha_objectes i el resultat ha estat True
func dona_primer() -> Array:
	var peça = $Cua1.get_node("PeçaArrossegable")
	if arrossegament.peça_arrossegant == peça:
		# Estem arrossegant la peça ques'ha d'entregar! Li haurem de prendre a la jugadora
		arrossegament.peça_arrossegant = null
		peça.z_index = 0
	$Cua1.remove_child(peça)
	var parella = peça.deconstrueix()
	
	# Hauríem de garantir que seguent_lliure > 0 (amb hi_ha_objectes)
	# (És possible que entrem en aquest bucle 0 vegades, si seguent_lliure = 1)
	for index in range(1, seguent_lliure):
		var filla = REGIONS[index].get_node("PeçaArrossegable")
		REGIONS[index].remove_child(filla)
		REGIONS[index - 1].add_child(filla, true)	# Cridem add_child amb force_readable_name = true per forçar que el nom de la filla seguirà sent PeçaArrossegable
		if arrossegament.peça_arrossegant == filla:
			# Estem arrossegant aquesta peça! Assegurem-nos d'actualitzar el seu anclatge
			filla.initialPos = REGIONS[index-1].global_position
	seguent_lliure -= 1
	return parella

func hi_ha_lloc() -> bool:
	return seguent_lliure < MAXIM_OBJECTES

func hi_ha_objectes() -> bool:
	return seguent_lliure > 0

func _process(_delta: float) -> void:
	if hi_ha_lloc():
		# Crea una peça d'un bloc nova
		var nova_peça = escena_peça.instantiate()
		nova_peça.crea_bloc()
		nova_peça.dibuixa()
		REGIONS[seguent_lliure].add_child(nova_peça)
		seguent_lliure += 1

# Acabem d'extreure un dels fills d'aquest arbre (una de les peces)
# Ara hem de reparar-lo
func repara_fulles() -> void:
	seguent_lliure -= 1
	for index in REGIONS.size() - 1:
		if not REGIONS[index].has_node("PeçaArrossegable") and REGIONS[index+1].has_node("PeçaArrossegable"):
			var fulla = REGIONS[index+1].get_node("PeçaArrossegable")
			REGIONS[index+1].remove_child(fulla)
			REGIONS[index].add_child(fulla, true)
