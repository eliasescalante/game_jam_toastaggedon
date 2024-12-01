extends Node2D

# Variable para almacenar el tiempo del juego
var game_time: float = 0.0
# Referencia al Label donde se mostrará el tiempo
@onready var time_label: Label = $ui/TIEMPO

func _ready() -> void:
	 # Mostrar el tiempo en el label
	if time_label:
		time_label.text = "Tiempo: " + str(game_time) + " segundos"
	else:
		print("El nodo TIEMPO no se encuentra en la escena.")

# Función para recibir el tiempo de juego desde otra escena
func set_game_time(time: float) -> void:
	game_time = time
	print("Tiempo pasado a win-lose: ", game_time) 
	 # Actualizar el texto del Label
	if time_label:
		time_label.text = "Tiempo: " + str(game_time) + " segundos"
	else:
		print("El nodo TIEMPO no se encuentra en la escena.")

# Función para manejar la acción de reintentar
func _on_reintentar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")

# Función para salir del juego
func _on_salir_pressed() -> void:
	get_tree().quit()
