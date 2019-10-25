extends Control

var localtime = GetClock.earth_time
var eorzeatime = GetClock.eorzea_time


func _process(_delta):
	var localtime = GetClock.earth_time
	var eorzeatime = GetClock.eorzea_time
	
	($LocalTime as Label).text = "Local Time - " + str(localtime[0]) + ":" + str("%02d" % localtime[1]) + ":" + localtime[3] #+ str("%02d" % localtime[2]) 
	($EorzeaTime as Label).text = "Eorzea Time - " + str(eorzeatime[0]) + ":" + str("%02d" % eorzeatime[1]) + ":" + eorzeatime[3] #+ str("%02d" % eorzeatime[2])