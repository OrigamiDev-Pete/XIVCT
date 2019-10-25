extends AudioStreamPlayer

var state : int = 0
var overlay_state : int = 0
var current_volume = -5.0



func _on_Panels_gatherable():
	if OS.window_minimized:
		match state:
			0:
				volume_db = current_volume / 0.5
				play()
			1:
				return
			2:
				volume_db = current_volume
				play()
	elif !get_parent().get_node("OverlayMode/VBoxContainer").visible:
		match overlay_state:
			0:
				return
			1:
				volume_db = current_volume / 0.5
				play()
			2:
				volume_db = current_volume
				play()
	else:
		volume_db = current_volume
		play()


func _on_HSlider_value_changed(value):
	current_volume = log(value) * 20

func _on_OptionButton_item_selected(ID):
	state = ID

func load():
	current_volume = log(SaveLoad.settings[1]) * 20
	state = SaveLoad.settings[4]
	overlay_state = SaveLoad.settings[5]

func _on_HiddenSound_item_selected(ID):
	overlay_state = ID
