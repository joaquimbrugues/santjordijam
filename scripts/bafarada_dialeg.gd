extends Node2D

const VELOCITAT_ANIMACIO: float = 30.0
var llista_dialeg: Array	#Array[String]
var index: int

func _ready() -> void:
	%Boto.set_disabled(true)
	var tween = get_tree().create_tween()
	self_modulate = Color.TRANSPARENT
	tween.tween_property(self, "self_modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_OUT)
	tween.finished.connect(dispara_text)

func set_llista_dialeg(llista: Array) -> void:
	llista_dialeg = llista
	index = 0

func dispara_text() -> void:
	if index < llista_dialeg.size():
		%Boto.set_disabled(true)
		%TextDialeg.text = llista_dialeg[index]
		%TextDialeg.set_visible_ratio(0.0)
		var tween = get_tree().create_tween()
		tween.tween_property(%TextDialeg, "visible_ratio", 1.0, llista_dialeg[index].length() / VELOCITAT_ANIMACIO).set_ease(Tween.EASE_OUT)
		tween.finished.connect(func (): %Boto.set_disabled(false))
		index += 1
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 0.3).set_ease(Tween.EASE_OUT)
		tween.finished.connect(queue_free)
		get_parent().dialeg_acabat()

# Dispara la seguent línia de text
func _on_boto_pressed() -> void:
	dispara_text()
