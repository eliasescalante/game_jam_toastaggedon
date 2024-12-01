extends Node

var tiempo: float = 0.0  # Tiempo transcurrido en segundos

func _ready() -> void:
	# Inicia el tiempo en 0 al comenzar el juego
	tiempo = 0.0

func _process(delta: float) -> void:
	# Incrementa el tiempo durante cada frame
	tiempo += delta
