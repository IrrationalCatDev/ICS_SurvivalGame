extends Node

var network = ENetMultiplayerPeer.new()

var PORT = 9999
var max_players = 100

func _ready():
	StartServer()
	
func StartServer():
	var err = network.create_server(PORT,max_players)
	multiplayer.multiplayer_peer = network
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	print("Server started!")
	
func player_connected(peer_id):
	print("User " + str(peer_id) + " connected")
	
func player_disconnected(peer_id):
	print("User " + str(peer_id) + " disconnected")
