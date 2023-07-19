extends Control


func _ready() -> void:
    $WeatherAPI.perform(33.6358, 130.421)


func _on_weather_api_completed(response: Dictionary) -> void:
    print(response["current_weather"])
