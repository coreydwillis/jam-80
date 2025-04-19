extends Node

var nameResource : Resource
var diagResource : Resource
var resourceReturner

func _ready():
	var nameDB = preload("res://assets/dbs/names_db.csv")
	var diagDB = preload("res://assets/dbs/dialog_db.csv")
	Game.name_db = return_resource(nameDB)
	Game.diag_db = return_resource(diagDB)

func return_resource(csvResource):
	resourceReturner = csvResource
	return resourceReturner
