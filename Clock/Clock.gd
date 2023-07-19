extends Control


func _ready() -> void:
    adjust_rotation()


func _process(delta: float) -> void:
    adjust_rotation()
    # adjust_rotation_degrees() # Another solution


# calc by radian
func adjust_rotation() -> void:
    var time = Time.get_time_dict_from_system()
    $SecondHand.rotation = time['second'] * (2 * PI) / 60
    $MinuteHand.rotation = time['minute'] * (2 * PI) / 60
    $HourHand.rotation   = (time['hour'] * (2 * PI) / 12) \
        + time['minute'] * (2 * PI / 12) / 60


# calc by degree
func adjust_rotation_degrees() -> void:
    var time = Time.get_time_dict_from_system()
    $SecondHand.rotation_degrees = time['second'] * (360 / 60)
    $MinuteHand.rotation_degrees = time['minute'] * (360 / 60)
    $HourHand.rotation_degrees   = time['hour'] * (360 / 12) \
        + time['minute'] * (360 / 12) / 60
