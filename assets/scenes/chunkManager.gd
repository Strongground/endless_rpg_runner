extends Node2D

var activeChunk = null

func _ready():
	pass

func setActive (active, chunk):
	if active:
		self.activeChunk = chunk.name
	else:
		self.activeChunk = null

func getActiveChunk():
	return activeChunk