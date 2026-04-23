extends Node2D

const DURADA_ANIMACIO_ENTRADA: float = 1.4
var nom_personatge: Personatge.Nom

func entra_personatge(nom: Personatge.Nom) -> void:
	var sprite = Personatge.DADES[nom]["sprite"].instantiate()
	add_child(sprite, true)
	sprite.self_modulate = Color.TRANSPARENT
	sprite.position = Vector2(-500.0, 0.0)
	var tween_fade_in = get_tree().create_tween()
	tween_fade_in.tween_property(sprite, "self_modulate", Color.WHITE, DURADA_ANIMACIO_ENTRADA).set_ease(Tween.EASE_OUT)
	var tween_translacio = get_tree().create_tween()
	tween_translacio.tween_property(sprite, "position", Vector2.ZERO, DURADA_ANIMACIO_ENTRADA).set_ease(Tween.EASE_OUT)
