extends GridContainer


func set_columns(value):
	columns = value
	match columns:
		1:
			$Tween.interpolate_property(self, "rect_min_size", null, Vector2(0, 290) , 0.2, Tween.TRANS_QUAD,Tween.EASE_OUT)
			$Tween.start()
			$Fish/Fish/HBoxContainer.rect_position = Vector2(152, 0)
			$Fish/Mooch.rect_position = Vector2(650, 0)
		2:
			$Tween.interpolate_property(self, "rect_min_size", null, Vector2(0, 192) , 0.2, Tween.TRANS_QUAD,Tween.EASE_OUT)
			$Tween.start()
			$Fish/Fish/HBoxContainer.rect_position = Vector2(0, 18)
			$Fish/Mooch.rect_position = Vector2(490, 18)