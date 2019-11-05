extends Control

var overlaypanel = preload("res://Scenes/PanelOverlay.tscn")

var number_of_panels : int = 4 setget set_number_of_panels

var drag_position = null
var panel_opacity : float = 50
var last_position = null
var adding_panels = false


func _ready():
	for i in get_node("/root/Main/Container/ScrollContainer/Panels").get_child_count():
			var newpanel = overlaypanel.instance()
			$VBoxContainer.add_child(newpanel, true)

func _on_Main_ready(): #Whole tree initilized
	pass


func _process(_delta):
	if drag_position:
		OS.set_window_position(OS.window_position + get_global_mouse_position() - drag_position)


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position()
		else:
			drag_position = null
	if event is InputEventMouseButton:
		if $CloseButton.position == 0: # Adaptive
			if OS.window_position.x + (OS.window_size.x/2) < OS.get_screen_size().x / 2:
				$CloseButton.rect_position.x = 27
				$Minimize.rect_position.x = 57.5
			elif OS.window_position.x + (OS.window_size.x/2) > OS.get_screen_size().x / 2:
				$CloseButton.rect_position.x = 527.5
				$Minimize.rect_position.x = 558
		if not event.pressed:
			last_position = OS.window_position


func set_number_of_panels(value):
	number_of_panels = value
	add_panels()


func add_panels():
#	var hidden_panels = 0
#	for i in $VBoxContainer.get_child_count():
#		$VBoxContainer.get_child(i).queue_free()
#	yield(get_tree().create_timer(0.05), "timeout") # delays script so that dependencies can ready
#
#	if get_node("/root/Main/Container/ScrollContainer/Panels").get_child_count() < number_of_panels:
#		for i in get_node("/root/Main/Container/ScrollContainer/Panels").get_child_count():
#			var newpanel = overlaypanel.instance()
#			$VBoxContainer.add_child(newpanel, true)
#	else:
#		for i in number_of_panels:
#			if get_node("/root/Main/Container/ScrollContainer/Panels").get_child(i).visible == false:
#				var newpanel = overlaypanel.instance()
#				$VBoxContainer.add_child(newpanel, true)
#				hidden_panels += 1
#			var newpanel = overlaypanel.instance()
#			$VBoxContainer.add_child(newpanel, true)

	for i in $VBoxContainer.get_child_count():
		$VBoxContainer.get_child(i).queue_free()
	yield(get_tree().create_timer(0.05), "timeout") # delays script so that dependencies can ready
	
	for i in get_node("/root/Main/Container/ScrollContainer/Panels").get_child_count():
		if not get_node("/root/Main/Container/ScrollContainer/Panels").get_child(i).visible:
			continue
		var newpanel = overlaypanel.instance()
		newpanel.item = get_node("/root/Main/Container/ScrollContainer/Panels").get_child(i).item
		$VBoxContainer.add_child(newpanel, true)





func _on_OptionButton_item_selected(ID):
	$CloseButton.set_position(ID)
	$Minimize.set_position(ID)


func _on_Visible_value_changed(value):
	set_number_of_panels(value)


func _on_Opacity_value_changed(value):
#	for i in $VBoxContainer.get_children():
#		i.opacity = value
	panel_opacity = value


func _on_Minimize_pressed():
	if $VBoxContainer.visible:
		$VBoxContainer.hide()
	else:
		$VBoxContainer.show()

func save():
	return [last_position, number_of_panels, panel_opacity, $CloseButton.position]

func load():
#	last_position = Vector2(SaveLoad.overlay[0])
	number_of_panels = SaveLoad.overlay[1]
	panel_opacity = SaveLoad.overlay[2]
	$CloseButton.position = SaveLoad.overlay[3]
	$Minimize.position = SaveLoad.overlay[3]

func _on_Panels_complete():
	if not adding_panels:
		adding_panels = true
		yield(get_tree().create_timer(2.5), "timeout") # delays script so that dependencies can ready
		add_panels()
		print("adding")
		$Timer.start()

func _on_Panels_gatherable():
	if not adding_panels:
		adding_panels = true
		yield(get_tree().create_timer(2.5), "timeout") # delays script so that dependencies can ready
		add_panels()
		print("gatherable")
		$Timer.start()

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		add_panels()

func _on_Timer_timeout():
	adding_panels = false
	print("reset")

