extends Control
var datetime = OS.get_datetime_from_unix_time(OS.get_unix_time())

func _ready():
	pass
	
	
func _process(_delta):
	var etime = GetClock.get_eorzea_time()
	var eseconds = etime[0] * 3600 + etime[1] * 60 + etime[2]
	$Label.text = str(etime[0]) + ":" + str(etime[1])
	
	var ltime = GetClock.get_earth_time()
	var lseconds = ltime[0] * 3600 + ltime[1] * 60 + ltime[2]
	$Label2.text = str(eseconds / 20)
	
	var unix = OS.get_unix_time_from_datetime(etime[4])
	var result = (4 * 3600 / 21) - (eseconds / 21)
	$Label3.text = str(result / 60) + ":" + str(result % 60)

func _on_ColorRectC_mouse_entered():
	pass # Replace with function body.

func time_to_seconds():
	var time = (11 * 3600 + 52* 60)
	$Label.text = str(time)
	return time

func seconds_to_time():
	var seconds = time_to_seconds()
	var time = seconds / 3600
	$Label2.text = str(seconds / 3600) + ":" + str(seconds % 3600 / 60)