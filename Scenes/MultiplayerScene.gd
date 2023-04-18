extends Node2D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/TargetIP

@onready var Player = preload("res://Characters/Player.tscn")

const PORT = 9999 #need a different port?
var enet_peer = ENetMultiplayerPeer.new()


func _on_host_button_pressed():
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

func _on_join_button_pressed():
	main_menu.hide()
	#enet_peer.create_client('localhost',PORT)
	enet_peer.create_client(address_entry.text,PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		

func _unhandled_input(_event):
	if Input.is_action_pressed('ui_quit'):
		get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
		
func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, "Discovery failed: %s"%discover_result)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), "UPNP Invalid Gateway")
	
	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP Port Mapping Failed: %s"%map_result)
	
	print("Success! Join Address: %s"%upnp.query_external_address())
