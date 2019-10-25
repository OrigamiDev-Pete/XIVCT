extends Control


func _ready():
	pass

   
func _on_Button_pressed():
	($ItemSelect as Node).show()


func _on_ItemSelect_item_changed(item: String, checked: bool, arg2):
	