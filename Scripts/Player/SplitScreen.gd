extends Node

onready var viewport1 = $VPortsContainer/ViewportContainer1/Viewport
onready var viewport2 = $VPortsContainer/ViewportContainer2/Viewport
onready var camera1 = $VPortsContainer/ViewportContainer1/Viewport/Player/pivot/PlayerCamera
onready var camera2 = $VPortsContainer/ViewportContainer2/Viewport/Player/pivot/PlayerCamera
onready var world = $VPortsContainer/ViewportContainer1/Viewport/ThePit

func _ready():
	viewport2.world = viewport1.world
