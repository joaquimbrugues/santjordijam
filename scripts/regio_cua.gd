extends StaticBody2D

func _on_mouse_entered() -> void:
	if not arrossegament.arrossegant:
		var peça = get_node("PeçaArrossegable")
		if peça != null:
			peça.scale = Vector2(1.05, 1.05)
			peça.pot_arrossegar = true

func _on_mouse_exited() -> void:
	if not arrossegament.arrossegant:
		var peça = get_node("PeçaArrossegable")
		if peça != null:
			peça.scale = Vector2(1.0, 1.0)
			peça.pot_arrossegar = false
