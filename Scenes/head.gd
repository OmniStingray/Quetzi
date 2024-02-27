class_name Head extends SnakePart

signal food_eaten # signal to tell gameplay that food was eaten.
signal collided_with_body
signal collided_with_tail
signal collided_with_wall

func _on_area_entered(area):
	# Check if collided with food or tail
	# if collided with food, remove food and spawn new food and add to tail
	if area.is_in_group("food"):
		# collided with food
		food_eaten.emit()
		area.call_deferred("queue_free")
	elif area.is_in_group("Walls"):
		collided_with_wall.emit()
	else:
		# collided with something else
		collided_with_body.emit()
		collided_with_tail.emit()
		
		pass
		
