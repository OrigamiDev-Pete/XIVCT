extends Control

onready var itemdic : Dictionary = DictionaryLoader.item_dictionary
onready var line = preload("res://Scenes/TimeBlock.tscn")

var line_array : Array = []

func _ready():
	pass

func _process(_delta):
	var time = GetClock.eorzea_time
	var seconds = time[0] * 3600 + time[1] * 60 + time[2]
	if time[3] == "pm":
		seconds = seconds + 43200
		$TimeLine.rect_position.x = (seconds / 86400.0) * rect_size.x
	if time[3] == "am" and time[0] == 12:
		seconds = seconds - 43200
		$TimeLine.rect_position.x = (seconds / 86400.0) * rect_size.x
	if time[3] == "pm" and time[0] == 12:
		seconds = seconds - 43200
		$TimeLine.rect_position.x = (seconds / 86400.0) * rect_size.x
	$TimeLine.rect_position.x = (seconds / 86400.0) * rect_size.x


func _on_ItemSelect_item_changed(item, _id):
	if line_array.has(item):
		line_array.erase(item)
		remove_line(item)
	else:
		if itemdic[item]["basic"][1] == 0:
			return
		line_array.append(item)
		add_line(item)


func add_line(item):
	var time1 = itemdic[item]["basic"][1]
	var time2 = (itemdic[item]["basic"][1] + 12)
	var life = 2
	if itemdic[item]["basic"][0] == "fishingtheme" and itemdic[item]["basic"][1] != 0:
		life = itemdic[item]["fish"][0]
		if itemdic[item]["fish"][4] == "pm":
			time1 += 12
	if itemdic[item]["basic"][0] == "fishingtheme" and itemdic[item]["fish"][4] == "am" and time1 == 12:
		time1 -= 12
	
	if time2 == 24:
		time2 = time2 - 24
	
	var new_line = line.instance()
	var new_line2 = line.instance()
	add_child_below_node($Label3, new_line, true)
	colour(item, new_line)
	add_child_below_node($Label3, new_line2, true)
	new_line.name = item
	new_line2.name = item + "1"
	new_line.set_tooltip(item)
	new_line2.set_tooltip(item)
	
	colour(item, new_line2)
	new_line.rect_position.x = ((time1 * 3600) / 86400) * rect_size.x
	new_line2.rect_position.x = ((time2 * 3600) / 86400) * rect_size.x
	y_pos(item, new_line)
	y_pos(item, new_line2)
	
	line_ready_size(new_line, time1, life)
	line_ready_size(new_line2, time2, life)
	
	connect("resized", new_line, "_on_size_changed", [time1, life])
	connect("resized", new_line2, "_on_size_changed", [time2, life])
	
	if itemdic[item]["basic"][0] == "fishingtheme":
		new_line2.queue_free()

func remove_line(item):
		if has_node(item):
			get_node(item).queue_free()
		if has_node(item + "1"):
			get_node(item + "1").queue_free()
	

func colour(item, line):
	if itemdic[item]["basic"][0] == "miningtheme":
		line.color = Color("eb9714")
	if itemdic[item]["basic"][0] == "botanytheme":
		line.color = Color("9cd438")
	if itemdic[item]["basic"][0] == "fishingtheme":
		line.color = Color("6dcee8")

func y_pos(item, line):
	if itemdic[item]["basic"][0] == "miningtheme":
		pass
	if itemdic[item]["basic"][0] == "botanytheme":
		line.rect_position.y = line.rect_position.y + 6
	if itemdic[item]["basic"][0] == "fishingtheme":
		line.rect_position.y = line.rect_position.y - 6

func line_ready_size(line, time, life):
	line.rect_position.x = (time * 3600 / 86400) * rect_size.x
	line.rect_size.x = (80/36 * (rect_size.x / 24)) * life/2


func load():
#	line_array = SaveLoad.saved_array #Breaks code for some reason
	for i in SaveLoad.saved_array.size():
		if itemdic[SaveLoad.saved_array[i]]["basic"][1] == 0:
			continue
		add_line(SaveLoad.saved_array[i])
		line_array.append(SaveLoad.saved_array[i])
