extends TileMapLayer

var pot_arrossegar: bool = false
var initialPos: Vector2
var te_objectiu: bool = false
var objectiu_pos: Vector2
var objectiu_node: Node
var offset: Vector2

var forma: Array[Vector2i]
var atles: Array[Vector2i]

func crea(nova_forma: Array[Vector2i], nou_atles: Array[Vector2i]):
	forma = nova_forma
	atles = nou_atles

func deconstrueix() -> Array:
	queue_free()
	return [forma, atles]

# Prepara una rotació en sentit horari
func gir_horari():
	var forma_seguent: Array[Vector2i] = forma.duplicate()
	for index in forma.size():
		forma_seguent[index].x = - forma[index].y
		forma_seguent[index].y = forma[index].x
	forma = forma_seguent

func _process(_delta: float) -> void:
	if pot_arrossegar:
		if Input.is_action_just_pressed("clic_esquerre"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			scale = Vector2(1.0, 1.0)
			z_index = 1
			arrossegament.peça_arrossegant = self
		if Input.is_action_pressed("clic_esquerre"):
			global_position = get_global_mouse_position() - offset
			if Input.is_action_just_pressed("gira_arrossegant"):
				var tween = get_tree().create_tween()
				tween.tween_property(self, "rotation_degrees", rotation_degrees + 90, 0.2).set_ease(Tween.EASE_OUT)
				gir_horari()
		elif Input.is_action_just_released("clic_esquerre"):
			offset = Vector2.ZERO
			arrossegament.peça_arrossegant = null
			pot_arrossegar = false
			z_index = 0
			var tween = get_tree().create_tween()
			if te_objectiu:
				tween.tween_property(self, "global_position", objectiu_pos, 0.1).set_ease(Tween.EASE_OUT)
				var pare = get_parent()
				reparent(objectiu_node, true)
				if "perd_fill" in pare:
					pare.perd_fill()
				if "omple_peces" in objectiu_node:
					objectiu_node.omple_peces(global_position, forma)
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func fixa_objectiu(pos: Vector2, node: Node) -> void:
	te_objectiu = true
	objectiu_pos = pos
	objectiu_node = node

func dibuixa() -> void:
	for index in forma.size():
		set_cell(forma[index], 0, atles[index])

func crea_bloc() -> void:
	forma = [Vector2i(0,0)]
	atles = [ATLES_TEXTURES.pick_random()]

const ATLES_TEXTURES: Array[Vector2i] = [
	Vector2i(10,1),
	Vector2i(11,1),
	Vector2i(12,1),
	Vector2i(10,2),
	Vector2i(11,2),
	Vector2i(12,2),
	Vector2i(11,3),
	Vector2i(12,3),
	Vector2i(13,3),
	Vector2i(11,4),
	Vector2i(12,4),
	Vector2i(13,4),
	Vector2i(11,5),
	Vector2i(12,5),
	Vector2i(13,5),
	Vector2i(11,6),
	Vector2i(12,6),
	Vector2i(13,6),
	Vector2i(14,6),
	Vector2i(13,7),
	Vector2i(14,7),
	Vector2i(13,8),
	Vector2i(14,8),
]
