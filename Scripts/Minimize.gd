extends TextureButton

var position : int = 0 setget set_pos # 0 - Adaptive, 1 - Left, 2 - Right

func _ready():
	pass

func set_pos(value):
	position = value
	match position:
		0:
			if OS.window_position.x + (OS.window_size.x/2) > OS.get_screen_size(1).x / 2:
				rect_position.x = 57.5
			elif OS.window_position.x + (OS.window_size.x/2) < OS.get_screen_size(1).x / 2:
				rect_position.x = 558

		1:
			rect_position.x = 57.5
		2:
			rect_position.x = 558
