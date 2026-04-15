extends Node2D

@onready var peça: TileMapLayer = $Capes/Peça

func _ready() -> void:
	peça.crea_exemple()
	peça.dibuixa_peça()
