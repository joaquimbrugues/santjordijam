extends Control

@onready var animacio_transicio = $AnimacioTransicioEscena/AnimationPlayer
@onready var estrelles: AnimatedSprite2D = $Estrelles

func _ready() -> void:
	animacio_transicio.play("fade_out")
	Música.stop()
	Música_Intro.play_music_level()
	animacio_transicio.animation_finished.connect(func (_nom):
		$AnimacioTransicioEscena.set_visible(false)
		estrelles.actualitza_estrelles()
	)

func _on_texture_button_pressed() -> void:
	$AnimacioTransicioEscena.set_visible(true)
	animacio_transicio.play("fade_in")
	animacio_transicio.animation_finished.connect(carrega_nivell)

func carrega_nivell(_animacio: StringName) -> void:
	get_tree().change_scene_to_file("res://escenes/nivell.tscn")
