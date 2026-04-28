extends Control

@onready var animacio_transicio = $AnimacioTransicioEscena/AnimationPlayer
@onready var música_menú = preload("res://sons/Pufino - Swing (freetouse.com).mp3")

func _ready() -> void:
	Música_Intro.play_music_level()

func _on_texture_button_pressed() -> void:
	$AnimacioTransicioEscena.set_visible(true)
	animacio_transicio.play("fade_in")
	animacio_transicio.animation_finished.connect(carrega_nivell)

func carrega_nivell(_animacio: StringName) -> void:
	get_tree().change_scene_to_file("res://escenes/nivell.tscn")
