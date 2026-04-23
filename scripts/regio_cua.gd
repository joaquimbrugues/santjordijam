extends StaticBody2D

@export var escala: float = 1.0

func _ready() -> void:
	$CollisionShape2D.scale *= escala

func _on_mouse_entered() -> void:
	if not arrossegament.peça_arrossegant != null and has_node("PeçaArrossegable"):
		var peça = get_node("PeçaArrossegable")
		peça.scale = Vector2(1.05, 1.05)
		peça.pot_arrossegar = true

func _on_mouse_exited() -> void:
	if not arrossegament.peça_arrossegant != null and has_node("PeçaArrossegable"):
		var peça = get_node("PeçaArrossegable")
		peça.scale = Vector2(1.0, 1.0)
		peça.pot_arrossegar = false

func perd_fill():
	var pare = get_parent()
	if "repara_fulles" in pare:
		pare.repara_fulles()
