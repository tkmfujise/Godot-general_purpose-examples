extends HBoxContainer


func _ready() -> void:
    clear_chidlren()
    show_loading()


func setup(times: Array, codes: Array, temperatures: Array, precipitations: Array) -> void:
    clear_chidlren()
    $ScrollContainer/Rows.columns = times.size()
    setup_rows(times, $ScrollContainer/Rows/Time)
    setup_rows(codes, $ScrollContainer/Rows/Code)
    setup_rows(temperatures, $ScrollContainer/Rows/Temperature)
    setup_rows(precipitations, $ScrollContainer/Rows/Precipitation)
    hide_loading()


func setup_rows(arr: Array, target: Node) -> void:
    for value in arr:
        var column = target.duplicate()
        if target == $ScrollContainer/Rows/Code:
            column.get_node("Label").text = value + "\n "
            column.get_node("WeatherIcon").set_code(value)
        else:
            column.get_node("Label").text = str(value)
        column.visible = true
        $ScrollContainer/Rows.add_child(column)


func clear_chidlren() -> void:
    for child in $ScrollContainer/Rows.get_children():
        if ["Time", "Code", "Temperature", "Precipitation"].has(child.name):
            child.visible = false
        else:
            child.queue_free()


func show_loading() -> void:
    $Spinner.play()
    $Spinner.visible = true


func hide_loading() -> void:
    $Spinner.visible = false
    $Spinner.stop()
