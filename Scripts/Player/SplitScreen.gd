extends Node

onready var viewport1 = $VBoxContainer/ViewportContainer/Viewport
onready var viewport2 = $VBoxContainer/ViewportContainer2/Viewport2
onready var camera1 = $VBoxContainer/ViewportContainer/Viewport/Player/pivot/PlayerCamera
onready var camera2 = $VBoxContainer/ViewportContainer2/Viewport2/Player/pivot/PlayerCamera
onready var world = $VBoxContainer/ViewportContainer/Viewport/ThePit

func _ready():
	viewport2.world = viewport1.world
