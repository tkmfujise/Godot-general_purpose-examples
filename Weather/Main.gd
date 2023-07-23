extends Control


func _ready() -> void:
    $WeatherAPI.perform(33.6358, 130.421, 'JST')
#    var f = FileAccess.open("res://test/sample.json", FileAccess.READ)
#    var json = JSON.new()
#    json.parse(f.get_as_text())
#    _on_weather_api_completed(json.get_data())


func _on_weather_api_completed(response: Dictionary) -> void:
    print(response)
    $TemeratureTable.setup(
        format_times(response["hourly"]["time"]),
        with_unit(response["hourly"]["weathercode"], ''),
        with_unit(response["hourly"]["temperature_2m"], '°C'),
        with_unit(response["hourly"]["precipitation_probability"], '%')
    )


func _on_weather_api_failed(message: String) -> void:
    show_error_message(message)


func format_times(arr: Array) -> Array:
    return arr.map(func(str):
        var dict = Time.get_datetime_dict_from_datetime_string(str + ":00", false)
        return "{year}/{month}/{day}\n{hour}:{minute}".format({
            "year":   dict['year'],
            "month":  dict['month'],
            "day":    dict['day'],
            "hour":   ("%02d" % dict['hour']),
            "minute": ("%02d" % dict['minute']),
        })
    )


func with_unit(arr: Array, unit: String) -> Array:
    return arr.map(func(s): return str(s, ' ', unit))


# TODO クローズしてももう一回表示できる確認
func show_error_message(message: String) -> void:
    $MessageDialog.dialog_text = message
    $MessageDialog.title = 'Error'
    $MessageDialog.visible = true

