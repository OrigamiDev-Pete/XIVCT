extends Control

var scroll : bool = false

func _ready():
	pass

func _process(_delta):
	if $Label.text.length() > 50:
		if scroll:
			scrolltext()

func scrolltext():
	$Label.rect_position.x -= 1
	if $Label.rect_position.x < ($Label.text.length() * 5)* -1:
		$Label.rect_position.x = 0
		scroll = false
		$Timer.start(3)

func _on_Timer_timeout():
	scroll = true


func _on_TextScrollBox_visibility_changed():
	if visible:
		$Timer.start(3)
	elif not visible:
		$Timer.stop()
