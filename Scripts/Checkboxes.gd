extends VBoxContainer

var minicon_on := preload("res://UI/Icons/Miner_Icon_Yellow.png")
var minicon_off := preload("res://UI/Icons/Miner_Icon_Blue.png")
var boticon_on := preload("res://UI/Icons/Botanist_Icon_Yellow.png")
var boticon_off := preload("res://UI/Icons/Botanist_Icon_Blue.png")
var fishicon_on := preload("res://UI/Icons/Fisher_Icon_Yellow.png")
var fishicon_off := preload("res://UI/Icons/Fisher_Icon_Blue.png")

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


func _on_Mining_pressed():
	if ($GatherType/Mining as CheckBox).pressed == true:
		($GatherType/Mining/Icon as TextureRect).texture = minicon_on
		get_tree().call_group("Mining", "show")
	else:
		($GatherType/Mining/Icon as TextureRect).texture = minicon_off
		get_tree().call_group("Mining", "hide")


func _on_Botany_pressed():
	if ($GatherType/Botany as CheckBox).pressed == true:
		($GatherType/Botany/Icon as TextureRect).texture = boticon_on
		get_tree().call_group("Botany", "show")
	else:
		($GatherType/Botany/Icon as TextureRect).texture = boticon_off
		get_tree().call_group("Botany", "hide")


func _on_Fishing_pressed():
	if ($GatherType/Fishing as CheckBox).pressed == true:
		($GatherType/Fishing/Icon as TextureRect).texture = fishicon_on
		get_tree().call_group("Fishing", "show")
	else:
		($GatherType/Fishing/Icon as TextureRect).texture = fishicon_off
		get_tree().call_group("Fishing", "hide")

func _on_Yellow_pressed():
	if ($ScripType/Yellow as CheckBox).pressed == true:
		get_tree().call_group("Yellow", "show")
	else:
		get_tree().call_group("Yellow", "hide")


func _on_White_pressed():
	if ($ScripType/White as CheckBox).pressed == true:
		get_tree().call_group("White", "show")
	else:
		get_tree().call_group("White", "hide")
