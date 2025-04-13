extends Node
class_name DragAndDrop

@export_category("Resource Reference")
@export_subgroup("Audio")

## Signals emitted during the drag-and-drop process.
signal drag_canceled(starting_position: Vector2)  ## Emitted when dragging is canceled, returning to the starting position.
signal drag_started  ## Emitted when dragging begins.
signal dropped(starting_position: Vector2)  ## Emitted when the object is dropped.
signal moved
@export_category("References")
## Enables or disables the drag-and-drop functionality.
@export var enabled: bool = true

## The target Area2D node that will be dragged.
@export var target: Area2D


## The initial position of the target before dragging begins.
var starting_position: Vector2

## Offset between the mouse position and the target position to maintain relative positioning.
var offset := Vector2.ZERO

## Whether the target is currently being dragged.
var dragging := false


## Called when the node is ready. Ensures the target is set and connects the input event.
func _ready() -> void:
	assert(target, "No target set for DragAndDrop Component!")  # Ensure a target is assigned.
	target.input_event.connect(_on_target_input_event.unbind(1))  # Connect input events from the target.


## Continuously updates the target’s position while dragging.
## @param _delta (float) - Time elapsed since the last frame (not used).
func _process(_delta: float) -> void:
	if dragging and target:
		target.owner.global_position = target.owner.get_global_mouse_position() + offset


## Handles input events globally.
## @param event (InputEvent) - The input event to process.
func _input(event: InputEvent) -> void:
	if dragging and event.is_action_released("select"):
		_drop()
	elif  dragging and event.is_action_released("select"):
		_cancel_dragging()



## Ends the dragging process, resetting the target’s state.
func _end_dragging() -> void:
	dragging = false
	target.remove_from_group("dragging")
	target.owner.z_index = 0  # Reset z-index to its default.


## Cancels dragging and returns the object to its original position.
func _cancel_dragging() -> void:
	_end_dragging()
	drag_canceled.emit(starting_position)  # Notify listeners that dragging was canceled.


## Starts dragging the target, adjusting its position and emitting a signal.
func _start_dragging() -> void:
	dragging = true
	starting_position = target.owner.global_position  # Store the initial position.
	target.add_to_group("dragging")
	target.owner.z_index = 99  # Bring the dragged object to the foreground.
	offset = target.owner.global_position - target.get_global_mouse_position() 
	 # Maintain relative position.
	
	drag_started.emit()

	moved.emit()  # Notify listeners that dragging has started.


## Drops the object and emits the dropped signal.
func _drop() -> void:
	_end_dragging()
	dropped.emit(starting_position)  # Notify listeners that the object was dropped.
	

## Handles input events on the target object.
## @param _viewport (Node) - The viewport receiving the event.
## @param event (InputEvent) - The event occurring on the target.
func _on_target_input_event(_viewport: Node, event: InputEvent) -> void:
	if not enabled:
		return

	# Check if another object is already being dragged.
	var dragging_object := get_tree().get_first_node_in_group("dragging")
	
	if not dragging and dragging_object:
		return  # Prevent multiple objects from being dragged simultaneously.

	if not dragging and event.is_action_pressed("select"):
		_start_dragging()  # Start dragging if the select action is pressed.
