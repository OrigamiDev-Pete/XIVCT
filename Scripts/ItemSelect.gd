extends Control

#warnings-disable

signal item_changed
signal searched
signal found

onready var itembox = preload("res://Scenes/ItemBox.tscn")


var screen_size = OS.window_size
var regex = RegEx.new()

#Attach these variables to global script
onready var item_array : Dictionary = DictionaryLoader.item_dictionary #{"Heavens Lemon": ["botanytheme", "res://UI/Icons/Heavens_Lemon_Icon.png"], "Pyrite": ["miningtheme", "res://UI/Icons/Pyrite_Icon.png"]}
onready var item_array_keys : Array = item_array.keys()

func _ready():
	get_viewport().connect("size_changed", self, "_on_size_changed")
	screen_size = OS.window_size
	change_column()
	
	for i in item_array.size():
		var new_itembox = itembox.instance()
		$Panel/ScrollContainer/GridContainer.add_child(new_itembox, true)
		new_itembox.name = str(item_array_keys[i])
		new_itembox.text = str(item_array_keys[i])
		new_itembox.item = str(item_array_keys[i])
		new_itembox.theme = ResLoader.get(item_array[item_array_keys[i]]["basic"][0])
		var icon = load(item_array[item_array_keys[i]]["basic"][2])
		new_itembox.get_node("Icon").texture = icon
		
		if new_itembox.text.length() > 21:
			new_itembox.text = new_itembox.text.rstrip(new_itembox.text.right(new_itembox.text.length()-7)) + "..."
		
		new_itembox.connect("pressed", self, "_on_item_checked", [new_itembox.item, new_itembox])
		connect("searched", new_itembox, "_on_searched")
		connect("found", new_itembox, "_on_found")



func _on_size_changed():
	screen_size = OS.window_size
	change_column()

#Legacy Code
#func change_column():
#	if screen_size.x < 800:
#		$Panel.rect_min_size.x = 312
#		$Panel/ScrollContainer/GridContainer.columns = 1
#	elif screen_size.x < 1200:
#		$Panel.rect_min_size.x = 616
#		$Panel/ScrollContainer/GridContainer.columns = 2
#	elif screen_size.x < 1450:
#		$Panel.rect_min_size.x = 922
#		$Panel/ScrollContainer/GridContainer.columns = 3
#	else:
#		$Panel.rect_min_size.x = 1226
#		$Panel/ScrollContainer/GridContainer.columns = 4

func change_column():
	if screen_size.x < 800:
		tween_value($Panel, "rect_min_size", null, Vector2(312,400))
		tween_value($Panel, "rect_size", null, Vector2(312,400))
		$Panel/ScrollContainer/GridContainer.columns = 1
	elif screen_size.x < 1200:
		tween_value($Panel, "rect_min_size", null, Vector2(616,400))
		tween_value($Panel, "rect_size", null, Vector2(616,400))
		$Panel/ScrollContainer/GridContainer.columns = 2
	elif screen_size.x < 1500:
		tween_value($Panel, "rect_min_size", null, Vector2(922,400))
		tween_value($Panel, "rect_size", null, Vector2(922,400))
		$Panel/ScrollContainer/GridContainer.columns = 3
	else:
		tween_value($Panel, "rect_min_size", null, Vector2(1226,400))
		$Panel/ScrollContainer/GridContainer.columns = 4
	if not $Tween.is_active():
		$Tween.start()


func tween_value(object, property, start, end):
	$Tween.interpolate_property(object, property, start, end, 0.1, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	

func _on_Blur_focus_entered():
	hide()

func _on_item_checked(item : String, id):
	emit_signal("item_changed", item, id)#.pressed)

func _on_LineEdit_text_changed(new_text):
	emit_signal("searched")
	search(new_text)


func search(text):
	regex.compile("(?i)" + text)
	var result = regex.search_all(str(item_array_keys))
	for result in regex.search_all(str(item_array_keys)):
		emit_signal("found", "(?i)" + text)