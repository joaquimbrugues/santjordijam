class_name Personatge extends Node

enum Nom {
	CAÇADORA,
	JUGLA,
	VELL,
	PROGRAMADORA,
	ANARKO,
	NINIOS,
	MOSSEN,
	BORRATXO,
	ENTERRADORA,
}

const DADES: Dictionary = {
	Nom.CAÇADORA: {
		"nom": "Caçadora",
		"sprite": preload("res://escenes/personatges/sprite_caçadora.tscn"),
		"icona": preload("res://escenes/personatges/icona_caçadora.tscn"),
	},
	Nom.JUGLA: {
		"nom": "Jugla",
		"sprite": preload("res://escenes/personatges/sprite_jugla.tscn"),
		"icona": preload("res://escenes/personatges/icona_jugla.tscn"),
	},
	Nom.VELL: {
		"nom": "Vell",
		"sprite": preload("res://escenes/personatges/sprite_vell.tscn"),
		"icona": preload("res://escenes/personatges/icona_vell.tscn"),
	},
	Nom.PROGRAMADORA: {
		"nom": "Programadora",
		"sprite": preload("res://escenes/personatges/sprite_programadora.tscn"),
		"icona": preload("res://escenes/personatges/icona_programadora.tscn"),
	},
	Nom.ANARKO: {
		"nom": "Anarko",
		"sprite": preload("res://escenes/personatges/sprite_anarko.tscn"),
		"icona": preload("res://escenes/personatges/icona_anarko.tscn"),
	},
	Nom.NINIOS: {
		"nom": "Ninios",
		"sprite": preload("res://escenes/personatges/sprite_ninios.tscn"),
		"icona": preload("res://escenes/personatges/icona_ninios.tscn"),
	},
	Nom.MOSSEN: {
		"nom": "Mossén",
		"sprite": preload("res://escenes/personatges/sprite_mossen.tscn"),
		"icona": preload("res://escenes/personatges/icona_mossen.tscn"),
	},
	Nom.BORRATXO: {
		"nom": "Borratxo",
		"sprite": preload("res://escenes/personatges/sprite_borratxo.tscn"),
		"icona": preload("res://escenes/personatges/icona_borratxo.tscn"),
	},
	Nom.ENTERRADORA: {
		"nom": "Enterradora",
		"sprite": preload("res://escenes/personatges/sprite_enterradora.tscn"),
		"icona": preload("res://escenes/personatges/icona_enterradora.tscn"),
	},
}

static func get_enum_from_string(string_value: String) -> int:
	var string_maj = string_value.to_upper()
	if Nom.has(string_maj):
		return Nom[string_maj]
	else:
		push_error("Nom de personatge invàlid: " + string_value)
		return -1
