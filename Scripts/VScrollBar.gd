extends VScrollBar


func _ready():
	pass 

func _input(event):
	if Input.is_action_just_pressed("scroll_up"):
		value -= 1
	if Input.is_action_just_pressed("scroll_down"):
		value += 1



func _on_VScrollBar_mouse_entered():
	$AnimationPlayer.play("Scroll_Grow")



func _on_VScrollBar_mouse_exited():
	$AnimationPlayer.play("Scroll_Shrink")
