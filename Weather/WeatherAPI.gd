extends HTTPRequest

signal completed
signal failed

const END_POINT  = 'https://api.open-meteo.com/v1/forecast'
const URL_FORMAT = "{end_point}?latitude={latitude}&longitude={longitude}&timezone={timezone}&{paramters}"

# @see https://open-meteo.com/en/docs
const WMO_CODE = {
    'CLEAR_SKY':     0,
    'MAINLY_CLEAR':  1,
    'PARTLY_CLOUDY': 2,
    'OVERCAST':      3,
    'FOG':           45,
    'DEPOSITING_RIME_FOG': 48,
    'DRIZZLE_LIGHT':       51,
    'DRIZZLE_MODERATE':    53,
    'DRIZZLE_DENSE_INTENSITY': 55,
    'FREEZING_DRIZZLE_LIGHT': 56,
    'FREEZING_DRIZZLE_DENSE_INTENSITY': 57,
}


func perform(latitude: float, longitude: float, timezone: String) -> void:
    var url = URL_FORMAT.format({
        'end_point': END_POINT,
        'latitude':  latitude,
        'longitude': longitude,
        'timezone':  timezone,
        'paramters': 'current_weather=true&hourly=temperature_2m,precipitation_probability,weathercode'
    })
    request(url)


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
#    var f = FileAccess.open("res://test/sample.json", FileAccess.WRITE)
#    f.store_string(body.get_string_from_utf8())
#    f.close()
    if result != HTTPRequest.RESULT_SUCCESS:
        emit_signal("failed", "HTTP Error")
    else:
        var json = JSON.new()
        json.parse(body.get_string_from_utf8())
        var response = json.get_data()
        emit_signal("completed", response)
