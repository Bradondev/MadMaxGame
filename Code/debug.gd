extends Node
func _input(event):
    if event.is_action_pressed("Quit"):
        get_tree().quit()
        pass
