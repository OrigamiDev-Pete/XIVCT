extends ColorRect


func _on_size_changed(time, life):
	rect_position.x = (time * 3600 / 86400) * get_parent().rect_size.x
	rect_size.x = (80/36 * (get_parent().rect_size.x / 24)) * (life/2)