extends Node

var nameResource: Resource
var dialogResource: Resource
var resourceReturner

func _ready():
	var nameDB = preload("res://assets/dbs/names_db.csv")
	var dialogDB = preload("res://assets/dbs/dialog_db.csv")
	Game.name_db = return_resource(nameDB)
	Game.dialog_db = return_resource(dialogDB)

func return_resource(csvResource):
	resourceReturner = csvResource
	return resourceReturner
