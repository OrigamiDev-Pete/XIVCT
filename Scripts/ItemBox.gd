extends CheckBox

var item : String = ""
var regex = RegEx.new()

func _ready():
	add_to_group("load", true)


func _on_searched():
	hide()

func _on_found(search_text):

	regex.compile(search_text)
	var result = regex.search("(?i)" + item)
	if result:
		show()

func load():
	if SaveLoad.saved_array.has(name):
		pressed = true
	else:
		return