extends ColorRect


func _ready() -> void:
	get_material().set_shader_param("lod", 0.0)
	set_mouse_filter(MOUSE_FILTER_IGNORE)


func _on_Button_pressed():
	$Tween.interpolate_property(get_material(), "shader_param/lod", 0.0, 3.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	set_mouse_filter(MOUSE_FILTER_STOP)

func _on_Settings_pressed():
	$Tween.interpolate_property(get_material(), "shader_param/lod", 0.0, 3.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	set_mouse_filter(MOUSE_FILTER_STOP)


func _on_Blur_focus_entered():
	$Tween.interpolate_property(get_material(), "shader_param/lod", 3.0, 0.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	set_mouse_filter(MOUSE_FILTER_IGNORE)