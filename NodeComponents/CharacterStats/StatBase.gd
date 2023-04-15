extends Node

class_name StatBase

@export var StatValue : int = 100
@onready var base : int = StatValue

var statScalers : Dictionary
var statMultipliers : Dictionary

signal stat_updated

func RecalculateStat():
	StatValue = base
	for id in statScalers:
		StatValue += statScalers[id]
	for id in statMultipliers:
		StatValue *= statMultipliers[id]
	stat_updated.emit(StatValue)
	
func AddStatScaler(mod:int,modID:int):
	statScalers[modID] = mod
	RecalculateStat()

func RemoveStatScaler(modID:int):
	statScalers.erase(modID)
	RecalculateStat()

func AddStatMultiplier(mod:float,modID:int):
	statMultipliers[modID] = mod
	RecalculateStat()

func RemoveStatMultiplier(modID:int):
	statMultipliers.erase(modID)
	RecalculateStat()
