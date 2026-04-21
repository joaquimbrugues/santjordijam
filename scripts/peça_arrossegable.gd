extends TileMapLayer

var pot_arrossegar: bool = false
var offset: Vector2
var initialPos: Vector2
var te_objectiu: bool = false
var objectiu: Vector2

var forma: Array[Vector2i]
var atles: Array[Vector2i]

func crea(nova_forma: Array[Vector2i], nou_atles: Array[Vector2i]):
	forma = nova_forma
	atles = nou_atles

func deconstrueix() -> Array:
	queue_free()
	return [forma, atles]

func _process(_delta: float) -> void:
	if pot_arrossegar:
		if Input.is_action_just_pressed("clic_esquerre"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			arrossegament.arrossegant = true
		if Input.is_action_pressed("clic_esquerre"):
			global_position = get_global_mouse_position() - offset
			if Input.is_action_just_pressed("gira_arrossegant"):
				var tween = get_tree().create_tween()
				tween.tween_property(self, "rotation_degrees", rotation_degrees + 90, 0.2).set_ease(Tween.EASE_OUT)
		elif Input.is_action_just_released("clic_esquerre"):
			arrossegament.arrossegant = false
			var tween = get_tree().create_tween()
			if te_objectiu:
				tween.tween_property(self, "position", objectiu, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func dibuixa() -> void:
	for index in forma.size():
		set_cell(forma[index], 0, atles[index])
