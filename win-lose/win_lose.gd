extends Node2D

# Referencia al Label donde se mostrará el tiempo
@onready var time_label: Label = $ui/TIEMPO

func _ready() -> void:
	# Obtener el tiempo guardado en el script global
	var game_time = Global.tiempo

	# Redondear el tiempo a 2 decimales manualmente
	game_time = floor(game_time * 100) / 100.0

	# Mostrar el tiempo redondeado en el label
	if time_label:
		time_label.text =str(game_time)
	else:
		print("El nodo TIEMPO no se encuentra en la escena.")

# Función para manejar la acción de reintentar
func _on_reintentar_pressed() -> void:
	get_tree().change_scene("res://scenes/Level1.tscn")

# Función para salir del juego
func _on_salir_pressed() -> void:
	get_tree().quit()
