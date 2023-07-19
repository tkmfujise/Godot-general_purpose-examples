extends HTTPRequest

signal completed

const URL = 'https://api.open-meteo.com/v1/forecast'

func perform(latitude: float, longitude: float) -> void:
    var url_format = "{url}?latitude={latitude}&longitude={longitude}&{paramters}"
    var url = url_format.format({
        'url': URL,
        'latitude':  latitude,
        'longitude': longitude,
        'paramters': 'current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m'
    })
    request(url)


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
    if result != HTTPRequest.RESULT_SUCCESS:
        push_error("HTTP error")
    var json = JSON.new()
    json.parse(body.get_string_from_utf8())
    var response = json.get_data()
    emit_signal("completed", response)
