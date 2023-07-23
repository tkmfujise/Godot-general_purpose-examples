extends Sprite2D

const ICON_DIR = "res://assets/icons/"


func set_code(code: String) -> void:
    set_texture(find_icon(code))


func find_icon(code: String) -> Resource:
    var icon_paths = Array(DirAccess.get_files_at(ICON_DIR))
    var regex = RegEx.new()
    var matches = icon_paths.filter(func(path):
        var pattern = "^%s_(\\w+).png$" % code.strip_edges()
        regex.compile(pattern)
        return regex.search(path)
    )
    if matches.size():
        return load(str(ICON_DIR, matches[0]))
    else:
        return load("res://assets/icons/unknown.png")
