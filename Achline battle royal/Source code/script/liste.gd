extends ItemList

signal full
var selectedGame
var gamesIds = []

func _ready():
	pass

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var ind = 0;
	var lines = body.get_string_from_utf8().rsplit(";", false)
	
	for x in ["","id","Nom","Joueur Max","Durée d'un tour (s)","écartement","Taille Plateau","Joueurs"]:
		add_item(x)
		set_item_disabled(ind , true)
		ind+=1;
	
	for i in range(lines.size()) :
		add_item("Rejoindre")
		ind += 1;
		
		var columns = lines[i].rsplit(",", false)
		gamesIds.append(columns[0])
		for y in range(columns.size()) :
			add_item(columns[y])
			set_item_disabled(ind , true)
			ind+=1;


func _on_ItemList_item_activated(index):
	selectedGame = str(gamesIds[index/max_columns - 1])
	infosGlobales.selectedGame = selectedGame
	var headers = ["type: join","id: "+selectedGame]
	get_node("/root/Control/HTTPRequest2").request("http://www.achline.fr:58080/",headers)
	
	

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	if(body.get_string_from_utf8() != "full"):	
		infosGlobales.hoteip = body.get_string_from_utf8().rsplit(",", false)[0]
		infosGlobales.serverPort = int(body.get_string_from_utf8().rsplit(",", false)[1])
		infosGlobales.isServer = false
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scene/attente.tscn")
		print("ip : "+infosGlobales.hoteip + ", port : "+str(infosGlobales.serverPort))
	else :
		emit_signal("full")
		
	
