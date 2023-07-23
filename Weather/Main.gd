extends Control

@onready var LatitudeInput    = $HBoxContainer/InputFields/LatitudeInput
@onready var LongitudeIntput  = $HBoxContainer/InputFields/LongitudeIntput
@onready var TimezoneIntput   = $HBoxContainer/InputFields/TimezoneIntput
@onready var HourlyTable = $HBoxContainer/HourlyTable
@onready var CurrentWeatherIcon = $HBoxContainer/CurrentWeather/Icon/WeatherIcon
@onready var CurrentWeatherTemperature = $HBoxContainer/CurrentWeather/Temperature/Label
@onready var CurrentWeatherTime = $HBoxContainer/CurrentWeather/Time/Label

func _ready() -> void:
    refresh()
#    var f = FileAccess.open("res://test/sample.json", FileAccess.READ)
#    var json = JSON.new()
#    json.parse(f.get_as_text())
#    _on_weather_api_completed(json.get_data())


func refresh() -> void:
    HourlyTable.show_loading()
    $WeatherAPI.perform(
        float(LatitudeInput.text),
        float(LongitudeIntput.text),
        TimezoneIntput.text,
    )


func render_current_weather(current: Dictionary) -> void:
    CurrentWeatherTemperature.text = str(current["temperature"]) + " °C"
    CurrentWeatherTime.text = " ".join(current["time"].split("T"))
    CurrentWeatherIcon.set_code(str(current["weathercode"]))


func render_hourly_table(hourly: Dictionary) -> void:
    HourlyTable.setup(
        format_times(hourly["time"]),
        with_unit(hourly["weathercode"], ''),
        with_unit(hourly["temperature_2m"], '°C'),
        with_unit(hourly["precipitation_probability"], '%')
    )
    HourlyTable.hide_loading()


func format_times(arr: Array) -> Array:
    return arr.map(func(s):
        var dict = Time.get_datetime_dict_from_datetime_string(s + ":00", false)
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


func show_error_message(message: String) -> void:
    $MessageDialog.dialog_text = message
    $MessageDialog.title = 'Error'
    $MessageDialog.visible = true


func _on_load_button_pressed() -> void:
    refresh()


func _on_weather_api_completed(response: Dictionary) -> void:
    render_hourly_table(response["hourly"])
    render_current_weather(response["current_weather"])


func _on_weather_api_failed(message: String) -> void:
    show_error_message(message)
    HourlyTable.hide_loading()





