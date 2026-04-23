extends Node2D

const VELOCITAT_ANIMACIO: float = 30.0
var llista_dialeg: Array	#Array[String]
var index: int

func _ready() -> void:
	%Boto.set_disabled(true)
	var tween = get_tree().create_tween()
	self_modulate = Color.TRANSPARENT
	tween.tween_property(self, "self_modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_OUT)
	tween.finished.connect(dispara_primera_linia)

func set_llista_dialeg(llista: Array) -> void:
	llista_dialeg = llista
	index = 0

func dispara_primera_linia() -> void:
	dispara_text(llista_dialeg[0])

func dispara_text(text: String) -> void:
	%Boto.set_disabled(true)
	%TextDialeg.text = text
	%TextDialeg.set_visible_ratio(0.0)
	index += 1
	var tween = get_tree().create_tween()
	tween.tween_property(%TextDialeg, "visible_ratio", 1.0, text.length() / VELOCITAT_ANIMACIO).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func ():
		%Boto.set_disabled(false)
		if index == llista_dialeg.size():
			# TODO
			print("Hem de tancar aquesta bafarada!")
	)

# Dispara la seguent línia de text
func _on_boto_pressed() -> void:
	pass # Replace with function body.
