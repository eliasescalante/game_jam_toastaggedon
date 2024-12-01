extends Node2D

@onready var time_label: Label = $ui/TIEMPO  # Referencia al Label que muestra el tiempo

func _ready() -> void:
	# Obtener el tiempo guardado en el script global
	if Global.tiempo > 0:
		var game_time = Global.tiempo
		# Redondear el tiempo a 2 decimales
		game_time = floor(game_time * 100) / 100.0
		time_label.text = str(game_time) + " segundos"
	else:
		time_label.text = "0.00 segundos"  # Por si el tiempo no fue registrado correctamente
		print("Advertencia: El tiempo no se registró correctamente.")

# Función para manejar el botón de reintentar
func _on_reintentar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")

# Función para manejar el botón de salir
func _on_salir_pressed() -> void:
	get_tree().quit()
