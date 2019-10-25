extends LineEdit

var mouse_in := false

func _ready():
	pass


func _on_LineEdit_focus_entered():
	mouse_in = true



func _on_LineEdit_mouse_exited():
	mouse_in = false


func _input(event):
	if event is InputEventMouseButton and mouse_in == false:
		release_focus()