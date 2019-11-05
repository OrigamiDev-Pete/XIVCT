extends VBoxContainer

var minicon_on := preload("res://UI/Icons/Miner_Icon_Yellow.png")
var minicon_off := preload("res://UI/Icons/Miner_Icon_Blue.png")
var boticon_on := preload("res://UI/Icons/Botanist_Icon_Yellow.png")
var boticon_off := preload("res://UI/Icons/Botanist_Icon_Blue.png")
var fishicon_on := preload("res://UI/Icons/Fisher_Icon_Yellow.png")
var fishicon_off := preload("res://UI/Icons/Fisher_Icon_Blue.png")

var mining_show : bool = true
var botany_show : bool = true
var fishing_show : bool = true
var yellow_show : bool = true
var white_show : bool = true

func _ready():
	($GatherType/Mining as CheckBox).pressed = true
	($GatherType/Botany as CheckBox).pressed = true
	($GatherType/Fishing as CheckBox).pressed = true
	($ScripType/White as CheckBox).pressed = true
	($ScripType/Yellow as CheckBox).pressed = true
	
	icon_check()


func icon_check():
	if ($GatherType/Mining as CheckBox).pressed == true:
		($GatherType/Mining/Icon as TextureRect).texture = minicon_on
	else:
		($GatherType/Mining/Icon as TextureRect).texture = minicon_off
	
	if ($GatherType/Botany as CheckBox).pressed == true:
		($GatherType/Botany/Icon as TextureRect).texture = boticon_on
	else:
		($GatherType/Botany/Icon as TextureRect).texture = boticon_off
	
	if ($GatherType/Fishing as CheckBox).pressed == true:
		($GatherType/Fishing/Icon as TextureRect).texture = fishicon_on
	else:
		($GatherType/Fishing/Icon as TextureRect).texture = fishicon_off


func _on_LineEdit_focus_entered():
	if rect_size < Vector2(590,40):
		hide()


func _on_LineEdit_focus_exited():
	if visible == false:
		show()


func _on_Mining_pressed(hider):
	if ($GatherType/Mining as CheckBox).pressed == true:
		($GatherType/Mining/Icon as TextureRect).texture = minicon_on
		get_tree().call_group("Mining", "_show", hider)
	else:
		($GatherType/Mining/Icon as TextureRect).texture = minicon_off
		get_tree().call_group("Mining", "_hide", hider)


func _on_Botany_pressed(hider):
	if ($GatherType/Botany as CheckBox).pressed == true:
		($GatherType/Botany/Icon as TextureRect).texture = boticon_on
		get_tree().call_group("Botany", "_show", hider)
	else:
		($GatherType/Botany/Icon as TextureRect).texture = boticon_off
		get_tree().call_group("Botany", "_hide", hider)


func _on_Fishing_pressed(hider):
	if ($GatherType/Fishing as CheckBox).pressed == true:
		($GatherType/Fishing/Icon as TextureRect).texture = fishicon_on
		get_tree().call_group("Fishing", "_show", hider)
	else:
		($GatherType/Fishing/Icon as TextureRect).texture = fishicon_off
		get_tree().call_group("Fishing", "_hide", hider)

func _on_Yellow_pressed(hider):
	if ($ScripType/Yellow as CheckBox).pressed == true:
		get_tree().call_group("Yellow", "_show", hider)
	else:
		get_tree().call_group("Yellow", "_hide", hider)
		print("here")


func _on_White_pressed(hider):
	if ($ScripType/White as CheckBox).pressed == true:
		get_tree().call_group("White", "_show", hider)
	else:
		get_tree().call_group("White", "_hide", hider)
