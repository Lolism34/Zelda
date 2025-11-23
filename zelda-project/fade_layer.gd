extends CanvasLayer

@onready var fade_rect: ColorRect = $Fade

func fade_and_restart() -> void:
	fade_rect.visible = true
	fade_rect.modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 5.5, 0.0)
	tween.finished.connect(_on_fade_finished)
	
func _on_fade_finished() -> void:
	get_tree().reload_current_scene()
