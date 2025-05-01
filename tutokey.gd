extends Interactable

func _on_interacted(_body):
	GameState.set_tovalue("tutokey", GameState.get_tuvalue("tutokey") + 1)
	queue_free()
