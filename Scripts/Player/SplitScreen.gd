extends Node

onready var viewport1 = $VPortsContainer/ViewportContainer/Viewport
onready var viewport2 = $VPortsContainer/ViewportContainer2/Viewport2
onready var camera1 = $VPortsContainer/ViewportContainer/Viewport/Player/pivot/PlayerCamera
onready var camera2 = $VPortsContainer/ViewportContainer2/Viewport2/Player/pivot/PlayerCamera
onready var world = $VPortsContainer/ViewportContainer/Viewport/ThePit

func _ready():
	viewport2.world = viewport1.world
