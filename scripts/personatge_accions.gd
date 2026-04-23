extends Node2D

const DURADA_ANIMACIO_ENTRADA: float = 1.4
var nom_personatge: Personatge.Nom
var sprite
var escena_bafarada: PackedScene = preload("res://escenes/bafarada_dialeg.tscn")

func entra_personatge(nom: Personatge.Nom) -> void:
	# Instancia el personatge i afegeix-lo a l'arbre
	nom_personatge = nom
	sprite = Personatge.DADES[nom]["sprite"].instantiate()
	add_child(sprite, true)
	# Animació d'entrada
	sprite.self_modulate = Color.TRANSPARENT
	sprite.position = Vector2(-500.0, 0.0)
	var tween_fade_in = get_tree().create_tween()
	tween_fade_in.tween_property(sprite, "self_modulate", Color.WHITE, DURADA_ANIMACIO_ENTRADA).set_ease(Tween.EASE_OUT)
	var tween_translacio = get_tree().create_tween()
	tween_translacio.tween_property(sprite, "position", Vector2.ZERO, DURADA_ANIMACIO_ENTRADA).set_ease(Tween.EASE_OUT)
	# Esperem al final de les animacions
	tween_translacio.finished.connect(inicia_dialeg)

func inicia_dialeg() -> void:
	var llista_dialeg = Personatge.DADES[nom_personatge]["dialeg"][0]	#TODO: Augmentar l'índex
	var bafarada = escena_bafarada.instantiate()
	#bafarada.set_z_index(1)
	bafarada.set_llista_dialeg(llista_dialeg)
	add_child(bafarada)
	bafarada.set_position(Vector2(-450.0, 0))
	#TODO
	#sortida_personatge()

func sortida_personatge() -> void:
	# Animacions de sortida del personatge
	var tween_fade_out = get_tree().create_tween()
	tween_fade_out.tween_property(sprite, "self_modulate", Color.TRANSPARENT, DURADA_ANIMACIO_ENTRADA).set_ease(Tween.EASE_OUT)
	var tween_translacio = get_tree().create_tween()
	tween_translacio.tween_property(sprite, "position", Vector2(-500.0, 0.0), DURADA_ANIMACIO_ENTRADA).set_ease(Tween.EASE_OUT)
	await tween_fade_out.finished
	# Allibera tots els fills
	for n in get_children():
		n.queue_free()
	# Prepara l'entrada del proper personatge
	%EntradaNPCs.start()
