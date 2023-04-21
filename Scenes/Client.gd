extends Node

class_name Client

var network = ENetMultiplayerPeer.new()

var PORT = 9999


func ConnectToServer(ip : String):
	var err = network.create_client(ip,PORT)
	multiplayer.multiplayer_peer = network
	multiplayer.connected_to_server.connect(_on_connection_succeeded)
	multiplayer.connection_failed.connect(_on_connection_failed)
	print('connection complete')

func _on_connection_failed():
	print('failed to connect')

func _on_connection_succeeded():
	print('successfully connected')
