extends Resource
class_name CarPart

@export_enum("Weapon","Body","Wheels") var TypeOfPart : String
@export var part_name: String = "Unnamed Part"
@export var icon: Texture2D