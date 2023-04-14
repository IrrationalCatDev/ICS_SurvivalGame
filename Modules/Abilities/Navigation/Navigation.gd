extends NavigationAgent2D

var myEntity : EntityBase = null

##set this to false when movement stats of the entity base owner have been updated
var statsClean : bool = false

##Must be called once per physics frame.
##Returns the next position in global coordinates that can be moved to.
func execute(s: EntityBase):
	if myEntity == null:
		myEntity = s
	if not statsClean:
		max_speed = myEntity.max_speed

