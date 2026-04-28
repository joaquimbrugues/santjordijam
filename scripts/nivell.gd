extends Node2D

# Carrega els elements de l'escena
@onready var peça: TileMapLayer = $Capes/Peça
@onready var cua_objectes: Sprite2D = $Capes/CuaObjectes
@onready var tic_caiguda: Timer = $TicCaiguda
@onready var tic_moviment: Timer = $TicMoviment
@onready var sprite_stamina: AnimatedSprite2D = $Capes/Stamina
@onready var vora_esquerra: CollisionShape2D = $Capes/FGTetris/VoresTetris/VoraEsquerra
@onready var vora_dreta: CollisionShape2D = $Capes/FGTetris/VoresTetris/VoraDreta
@onready var vora_terra: CollisionShape2D = $Capes/FGTetris/VoresTetris/VoraTerra
@onready var estrelles: AnimatedSprite2D = $Capes/Estrelles
@onready var animacio_entrada: AnimationPlayer = $AnimacioTransicioEscena/AnimationPlayer
var VORES

#Efectes de so
@onready var música_nivell = preload("res://sons/Pufino - Warriors (freetouse.com).wav")
@onready var drac1 = preload("res://sons/drac1.wav")
@onready var plof = preload("res://sons/plof.wav")
@onready var woosh = preload("res://sons/woosh.wav")

# Paràmetres dels temporitzadors de caiguda i moviment
## Interval de temps (en segons) entre moviments de la peça provocats per la jugadora (esquerra-dreta i rotacions)
@export var INTERVAL_TIC: float = 0.5
## Interval de temps (en segons) entre moviments verticals de la peça, sense acceleració de la jugadora
@export var INTERVAL_CAIGUDA: float = 0.5
## Interval de temps (en segons) entre moviments verticals de la peça quan la jugadora prem "avall"
@export var INTERVAL_CAIGUDA_ACCELERAT: float = 0.25
## Interval de temps (en segons) entre moviments verticals de la peça quan la jugadora prem "amunt"
@export var INTERVAL_CAIGUDA_FRENAT: float = 0.75

# Possibles següents moviments de la peça, segons l'input de la jugadora del teclat
## Quants segons cal prèmer una tecla de moviment (esquerra, dreta, o gir) per tal de provocar
## el moviment
@export var sensibilitat_moviment: float = 0.1
# Medeix el "moviment acumulat" en cadascuna de les direccions,
# respectivament Esquerra, Dreta i Avall
var Moviments = [0.0, 0.0, 0.0]

# Paràmetre: Alçada de final del joc
## A quantes files d'alçada s'acaba el nivell
@export var FILES_ALÇADA_FINAL: int = 20

## Quantes files s'han d'omplir per tal de guanyar un punt (mitja estrella)
@export var FILES_PER_PUNT: int = 1
# Files emplenades no comptades a la puntuació
var files_plenes: Array
const COLUMNES: int = 14

# Identificador del darrer NPC que ha entrat
@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
var darrer_npc: Personatge.Nom = -1
# Les opcions d'NPC
var candidats_npc: Array[Personatge.Nom]
# Indica si es poden seleccionar NPCs
var npc_seleccionables: bool = false

# Caselles prohibides: la fila només es considera "plena" si la zona es troba __buida__
# Com a prova de concepte, farem un diccionari constant. De cara al futur podríem
# fer formes més complicades
const CASELLES_PROHIBIDES: Array[Vector2i] = [
	Vector2i(3,-1),
	Vector2i(4,-1),
	Vector2i(5,-1),
	Vector2i(6,-1),
	Vector2i(3,-2),
	Vector2i(4,-2),
	Vector2i(5,-2),
	Vector2i(6,-2),
	Vector2i(3,-3),
	Vector2i(4,-3),
	Vector2i(5,-3),
	Vector2i(6,-3),
	Vector2i(3,-4),
	Vector2i(4,-4),
	Vector2i(5,-4),
	Vector2i(6,-4),
	Vector2i(3,-5),
	Vector2i(4,-5),
	Vector2i(5,-5),
	Vector2i(6,-5),
	Vector2i(3,-6),
	Vector2i(4,-6),
	Vector2i(5,-6),
	Vector2i(6,-6),
	Vector2i(10,-14),
	Vector2i(11,-14),
	Vector2i(10,-15),
	Vector2i(11,-15),
	Vector2i(13,-18),
	Vector2i(0,-18),
	Vector2i(1,-18),
]

func _ready() -> void:
	Música_Intro.stop()
	Música.play_music_level()
	animacio_entrada.play("fade_out")
	animacio_entrada.animation_finished.connect(func (_nom):
		$AnimacioTransicioEscena.set_visible(false)
	)
	# Inicialitza els elements del joc
	sprite_stamina.inicialitza(INTERVAL_CAIGUDA, INTERVAL_CAIGUDA_FRENAT)
	# Inicialitza col·lecció de vores (Rect2)
	VORES = [vora_esquerra, vora_dreta, vora_terra].map(func (vora) -> Rect2:
		var rect = vora.get_shape().get_rect()
		rect.position = vora.to_global(rect.position)
		return rect
		)
	
	# En cas de reset: inicialitza les files plenes a 0
	files_plenes = []

func _process(delta: float) -> void:
	# Reacciona als clics de la jugadora
	if Input.is_action_pressed("peça_frena") and sprite_stamina.pot_frenar():
		# Frena, augmentant l'interval entre moviments verticals
		tic_caiguda.set_wait_time(INTERVAL_CAIGUDA_FRENAT)
	elif Input.is_action_pressed("peça_avall"):
		# Accelera avall, reduïnt l'interval entre moviments verticals
		tic_caiguda.set_wait_time(INTERVAL_CAIGUDA_ACCELERAT)
	else:
		# No hi ha cap efecte sobre el moviment vertical, posem l'interval de temps per defecte
		tic_caiguda.set_wait_time(INTERVAL_TIC)
	
	# Moviments laterals/rotació
	if Input.is_action_pressed("peça_esquerra"):
		# Acumula moviment cap a l'esquerra
		Moviments[0] += delta
	if Input.is_action_pressed("peça_dreta"):
		# Acumula moviment cap a la dreta
		Moviments[1] += delta
	if Input.is_action_pressed("peça_gira"):
		# Acumula moviment cap al gir
		Moviments[2] += delta
	if Input.is_action_pressed("NPC1") and npc_seleccionables:
		$Capes/NPCs/BotoQ.play("premut")
	elif Input.is_action_just_released("NPC1") and npc_seleccionables:
		$Capes/NPCs/BotoQ.play("lliure")
		tria_npc(candidats_npc[0])
	elif Input.is_action_pressed("NPC2") and npc_seleccionables:
		$Capes/NPCs/BotoW.play("premut")
	elif Input.is_action_just_released("NPC2") and npc_seleccionables:
		$Capes/NPCs/BotoW.play("lliure")
		tria_npc(candidats_npc[1])
	elif Input.is_action_pressed("NPC3") and npc_seleccionables:
		$Capes/NPCs/BotoE.play("premut")
	elif Input.is_action_just_released("NPC3") and npc_seleccionables:
		$Capes/NPCs/BotoE.play("lliure")
		tria_npc(candidats_npc[2])

# Retorna `true` si el moviment projectat de la peça intersecta amb una de les vores o
# amb una peça existent, o `false` altrament
func collisio() -> bool:
	# Col·lisió amb les vores
	for casella in peça.quadrats():
		for rect_vora in VORES:
			if casella.intersects(rect_vora):
				return true
	
	# Col·lisió amb la part construïda
	for p in peça.forma_seguent:
		if $Capes/Casa.get_cell_source_id(p + peça.posicio_seguent) != -1:
			return true
	
	return false

# Retorna si la casella puntua:
# Opció 1: la casella és prohibida i està buida
# Opció 2: la casella no és prohibida i està ocupada
func casella_puntua(casella: Vector2i) -> bool:
	var buida: bool = $Capes/Casa.get_cell_source_id(casella) == -1
	var prohibida: bool = CASELLES_PROHIBIDES.find(casella) != -1
	return buida == prohibida

# Elimina les caselles que es troben ara mateix a `Peça` i afegeix-les a la capa
# `Casa`. Crea una nova peça.
# Compta quantes files noves s'han afegit i actualitza les estrelles de la puntuació
# A més, si alguna de les caselles queda per damunt de la línia de final, triggereja el final del joc
func transicio_peça() -> void:
	var final = false
	for index in peça.forma_actual.size():
		$Capes/Casa.set_cell(peça.posicio + peça.forma_actual[index], 0, peça.atlas[index])
		
		# Comprovem el final del joc
		# (RECORDATORI: AL GODOT TOTES LES ALÇADES SÓN NEGATIVES, LA GRAVETAT ÉS POSITIVA
		if peça.posicio.y - peça.forma_actual[index].y <= - FILES_ALÇADA_FINAL:
			final = true
	
	# Esborrem la peça de la seva capa
	peça.clear()
	
	# Desactivem els timers de caiguda i de moviment
	tic_moviment.stop()
	tic_caiguda.stop()
	
	# Comprovem totes les files del tauler per veure quines hem omplert
	# I, també, si hem fastidiat alguna fila omplint un forat prohibit!
	# (Val, el missatge ha quedat estrany)
	files_plenes = range(1, FILES_ALÇADA_FINAL).filter(func (fila):
		var puntua: bool = true
		var indx: int = 0
		while puntua and indx < COLUMNES:
			puntua = puntua and casella_puntua(Vector2i(indx, - fila))
			indx += 1
		return puntua
	)
	# Sumem els punts i actualitzem el marcador
	@warning_ignore("integer_division")
	puntuacio.puntuacio = files_plenes.size() / FILES_PER_PUNT
	estrelles.actualitza_estrelles()
	
	# Si hem arribat al final del joc, no cal activar res. Mostra la pantalla de final
	if final:
		$AnimacioTransicioEscena.set_visible(true)
		Música.stop()
		animacio_entrada.play("fade_in")
		animacio_entrada.animation_finished.connect(func (_nom):
			get_tree().change_scene_to_file("res://escenes/pantalla_final.tscn")
		)
	else:
		# Activem el timer de reset
		$RetardReset.start()

# Instancia el Personatge seleccionat, i recorda'l de cara a la propera tria
func tria_npc(personatge: Personatge.Nom) -> void:
	# Executa només si l'obsequi està buit
	Efectes.play_FX(woosh, 4.0)
	if no_hi_ha_obsequi():
		# Inicialitza escena del personatge
		%Personatge.entra_personatge(personatge)
		# Reseteja les variables de tria de personatge
		for pare in [$Capes/NPCs/NPC1, $Capes/NPCs/NPC2, $Capes/NPCs/NPC3]:
			for n in pare.get_children():
				n.queue_free()
		darrer_npc = personatge
		candidats_npc = []
		npc_seleccionables = false

# Comprova si la jugadora ja ha tret l'obsequi de la safata
func no_hi_ha_obsequi() -> bool:
	return  not %Obsequi.has_node("PeçaArrossegable")

# Aquest funció es crida a cada tic del joc, corresponent a la caiguda de la peça,
# i la intentarà fer baixar més.
func _on_tic_caiguda_timeout() -> void:
	# Prepara moviment cap avall
	peça.posicio_seguent = peça.posicio + Vector2i.DOWN
	
	# Comprova col·lisions
	if collisio():
		Efectes.play_FX(plof, 5.0)
		transicio_peça()
	else:
		# Aplica el moviment de la peça
		peça.actualitza()

# Aquesta funció es crida a cada tic del joc de tetris, i executarà el darrer moviment
# que tingui desat a la variable `proper_moviment`,
# a més de resetejar aquesta variable a Caiguda
func _on_tic_moviment_timeout() -> void:
	# Prepara el proper moviment de la peça en la direcció que sigui pertinent
	if Moviments[0] > sensibilitat_moviment:
		peça.posicio_seguent = peça.posicio + Vector2i.LEFT
		Moviments[0] = 0.0	# Reinicialitza el medidor del moviment
	elif Moviments[1] > sensibilitat_moviment:
		peça.posicio_seguent = peça.posicio + Vector2i.RIGHT
		Moviments[1] = 0.0	# Reinicialitza el medidor del moviment
	elif Moviments[2] > sensibilitat_moviment:
		peça.gir_horari()
		Moviments[2] = 0.0	# Reinicialitza el medidor del moviment
	
	# Comprova col·lisions
	if collisio():
		# La peça no es pot moure
		peça.reset()
	else:
		# Aplica el moviment de la peça
		peça.actualitza()

# Afegeix l'objecte al capdavant de la cua com a següent peça a caure
func _on_retard_reset_timeout() -> void:
	# Reinicialitza els comandaments de moviment
	Moviments = [0.0, 0.0, 0.0]
	Efectes.play_FX(drac1, 5.0)
	# Si hi ha algun objecte a la zona fabricada, afegim-lo en lloc de l'objecte de la cua
	if %Fabricada.has_node("PeçaArrossegable"):
		var peça_nova = %Fabricada.get_node("PeçaArrossegable")
		peça.importa(peça_nova.forma, peça_nova.atles)
		peça_nova.queue_free()
		tic_caiguda.start()
		tic_moviment.start()
		peça.dibuixa_peça()
	elif cua_objectes.hi_ha_objectes():
		# Fes la transició de l'objecte a Peça
		var parella = cua_objectes.dona_primer()
		peça.importa(parella[0], parella[1])
		tic_caiguda.start()
		tic_moviment.start()
		peça.dibuixa_peça()
	else:
		#TODO: Ens hem d'assegurar de no caure mai en aquesta situació!
		print("PROBLEMA: No tenim peça per caure!")

# Selecciona tres NPCs perquè la jugadora drac pugui triar
func _on_entrada_np_cs_timeout() -> void:
	# Tria els candidats (tres de diferents, excloent el darrer npc triat)
	var exclosos = [ darrer_npc ]
	while exclosos.size() < 4:
		var nom = Personatge.Nom.values().pick_random()
		if exclosos.find(nom) == -1:
			exclosos.push_back(nom)
	candidats_npc = [ exclosos[1], exclosos[2], exclosos[3] ]
	
	# Dibuixa les icones dels candidats
	var icona1 = Personatge.DADES[candidats_npc[0]]["icona"].instantiate()
	icona1.self_modulate = Color.TRANSPARENT
	var tween_fade_in1 = get_tree().create_tween()
	tween_fade_in1.tween_property(icona1, "self_modulate", Color.WHITE, 0.6).set_ease(Tween.EASE_OUT)
	$Capes/NPCs/NPC1.add_child(icona1)
	var icona2 = Personatge.DADES[candidats_npc[1]]["icona"].instantiate()
	icona2.self_modulate = Color.TRANSPARENT
	var tween_fade_in2 = get_tree().create_tween()
	tween_fade_in2.tween_property(icona2, "self_modulate", Color.WHITE, 0.6).set_ease(Tween.EASE_OUT)
	$Capes/NPCs/NPC2.add_child(icona2)
	var icona3 = Personatge.DADES[candidats_npc[2]]["icona"].instantiate()
	icona3.self_modulate = Color.TRANSPARENT
	var tween_fade_in3 = get_tree().create_tween()
	tween_fade_in3.tween_property(icona3, "self_modulate", Color.WHITE, 0.6).set_ease(Tween.EASE_OUT)
	$Capes/NPCs/NPC3.add_child(icona3)
	
	# Esperem a que acabin les animacions d'entrada
	await tween_fade_in3.finished
	npc_seleccionables = true
