extends Node2D

const DURADA_ANIMACIO_ENTRADA: float = 1.4
var nom_personatge: Personatge.Nom
var sprite

func entra_personatge(nom: Personatge.Nom) -> void:
	# Instancia el personatge i afegeix-lo a l'arbre
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
	await tween_translacio.finished
	inicia_dialeg()

func inicia_dialeg() -> void:
	#TODO
	await get_tree().create_timer(1.0).timeout
	sortida_personatge()

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
