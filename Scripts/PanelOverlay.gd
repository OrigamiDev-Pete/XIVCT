extends Control

onready var target_node_parent = get_node("/root/Main/Container/ScrollContainer/Panels")

onready var itemdic : Dictionary = DictionaryLoader.item_dictionary

onready var Colour : Node = $ProgressBar/HBoxContainer/ColorRect
onready var Time : Node = $ProgressBar/HBoxContainer/Time
onready var Name : Node = $ProgressBar/HBoxContainer/Name
onready var Rating : Node = $ProgressBar/HBoxContainer/Rating
onready var Slot : Node = $ProgressBar/HBoxContainer/Slot
onready var Location : Node = $ProgressBar/HBoxContainer/Location
onready var Scrips : Node = $ProgressBar/HBoxContainer/Scrips
onready var Scriptype : Node = $ProgressBar/HBoxContainer/ScripType

var opacity : float = 50

var item : String
var time_left
var target_node = null
onready var index = get_position_in_parent()

func _ready():
	opacity()
	get_info(item)

func _process(_delta):
#	get_info(item)
#	if Time.text == "0:02":
#		get_info(item)
	get_time()
	update_progress_bar()

func get_info(item):
#	index = get_position_in_parent()
#	if target_node_parent.get_child(index) != null:
	if target_node_parent.get_node(item) != null:
		target_node = target_node_parent.get_node(item)
#		target_node = target_node_parent.get_child(index)
		if index + 1 > get_node("/root/Main/OverlayMode").number_of_panels:
			hide()
			return
#		while target_node.visible == false:
#			index += 1
#			target_node = target_node_parent.get_child(index)
#		item = target_node.item
		group(item)
		set_colour()
		get_time()
		Name.text = itemdic[item]["basic"][3]
		Rating.text = itemdic[item]["basic"][4]
		Slot.text = itemdic[item]["basic"][5]
		Location.text = itemdic[item]["basic"][6]
		Scrips.text = itemdic[item]["basic"][8]
		scrip_colour()
		active()
#		if target_node.visible == false:
#			hide()


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

func set_colour():
	if is_in_group("Mining"):
		Colour.color = Color("eb9714")
	if is_in_group("Botany"):
		Colour.color = Color("9cd438")
	if is_in_group("Fishing"):
		Colour.color = Color("6dcee8")

func get_time():
	Time.text = target_node.get_node("PanelSeparator/Timer").text

func scrip_colour():
	if is_in_group("White"):
		Scriptype.texture = ResLoader.white
	else:
		pass

func active():
	if target_node.active:
		$ProgressBar.set("custom_styles/fg", ResLoader.activeoverlaystyle)

func opacity():
	opacity = get_parent().get_parent().panel_opacity
	match opacity:
		0.0:
			$ProgressBar.self_modulate.a = 0.14
		25.0:
			$ProgressBar.self_modulate.a = 0.2
		50.0:
			$ProgressBar.self_modulate.a = 0.45
		75.0:
			$ProgressBar.self_modulate.a = 0.67
		100.0:
			$ProgressBar.self_modulate.a = 1

func update_progress_bar():
	if not is_in_group("Fishing"):
		if not target_node.active:
			var current_life = 3000.0 - int(Time.text)
			$ProgressBar.value = (current_life / 3000.0) * 100.0 # Create a percentage
		else:
			$ProgressBar.value = 100
	else:
		if not target_node.active:
			var current_life = 6000.0 - int(Time.text)
			$ProgressBar.value = (current_life / 6000) * 100 # Create a percentage
		else:
			$ProgressBar.value = 100


