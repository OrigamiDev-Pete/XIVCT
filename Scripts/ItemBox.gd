extends CheckBox

var item : String = ""
var regex = RegEx.new()
var hidden_by : String

onready var itemdic : Dictionary = DictionaryLoader.item_dictionary

func _ready():
	add_to_group("load", true)
	group(item)

func _hide(hider):
	if hidden_by.empty():
		hidden_by = hider
	hide()

func _show(hider):
	if hider == hidden_by:
		show()
		hidden_by.erase(0, 20)
	else:
		return

func _on_searched(hider):
	_hide(hider)

func _on_found(search_text, hider):
	regex.compile(search_text)
	var result = regex.search("(?i)" + item)
	if result:
		_show(hider)

func clear():
	if pressed:
		pressed = false
		emit_signal("pressed")

func load():
	if SaveLoad.saved_array.has(name):
		pressed = true
	else:
		return

func group(item):
	if itemdic[item]["basic"][0] == "miningtheme":
		add_to_group("Mining", true)
	if itemdic[item]["basic"][0] == "botanytheme":
		add_to_group("Botany", true)
	if itemdic[item]["basic"][0] == "fishingtheme":
		add_to_group("Fishing", true)
	
	if itemdic[item]["basic"][9] == "white":
		add_to_group("White", true)
	if itemdic[item]["basic"][9] == "yellow":
		add_to_group("Yellow", true)

func _on_SpinboxM_value_changed(value, hider):
	if is_in_group("Mining"):
		if itemdic[item]["basic"].size() > 10:
			if itemdic[item]["basic"][10] > value:
				_hide(hider)
			if itemdic[item]["basic"][10] <= value:
				_show(hider)

func _on_SpinboxB_value_changed(value, hider):
	if is_in_group("Botany"):
		if itemdic[item]["basic"].size() > 10:
			if itemdic[item]["basic"][10] > value:
				_hide(hider)
			if itemdic[item]["basic"][10] <= value:
				_show(hider)

func _on_SpinboxF_value_changed(value, hider):
	if is_in_group("Fishing"):
		if itemdic[item]["basic"].size() > 10:
			if itemdic[item]["basic"][10] > value:
				_hide(hider)
			if itemdic[item]["basic"][10] <= value:
				_show(hider)