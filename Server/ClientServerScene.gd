extends Node

@onready var Server = preload("res://Server/Server.tscn")
@onready var ClientScene = preload("res://Scenes/Client.tscn")
@onready var canvas_layer = $CanvasLayer
@onready var target_ip = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/TargetIP


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_join_button_pressed():
	var client = ClientScene.instantiate()
	canvas_layer.queue_free()
	var _ip = target_ip.text
	if _ip == '':
		_ip = '127.0.0.1'
	var cl = client as Client
	add_child(client)
	cl.ConnectToServer(_ip)

func _on_host_button_pressed():
	var server = Server.instantiate()
	canvas_layer.queue_free()
	add_child(server)
