extends StatBase

##as a percentage of the total
@export var CurrentHealth : int = 100

signal damaged
signal healed

func TakeDamage(damage : int):
	var f_damage = damage/StatValue
	var change = CurrentHealth - max(CurrentHealth-f_damage,0)
	CurrentHealth -= change
	damaged.emit(change)
	
func TakeHealing(healing : int):
	var f_healing = healing/StatValue
	CurrentHealth = min(CurrentHealth+f_healing,StatValue)
	healed.emit(healing)

