extends MenuButton

const SHORTCUT_KEY_MAPPING = {
    0: "file_new",
    1: "file_open",
    2: "file_save",
    3: "file_save_as",
}


func _ready() -> void:
    add_shortcut_key_lables_to_popup(get_popup())


func add_shortcut_key_lables_to_popup(popup: PopupMenu) -> void:
    for i in item_count:
        var id = popup.get_item_id(i)
        if SHORTCUT_KEY_MAPPING.has(id):
            var _str = popup.get_item_text(i)
            popup.set_item_text(i, _str + \
                "  (" + shortcut_key_of(SHORTCUT_KEY_MAPPING[id]) + ")"
            )


func shortcut_key_of(event_name: String) -> String:
    var event = InputMap.action_get_events(event_name)[0]
    var _str = OS.get_keycode_string(event.get_keycode_with_modifiers())
    return _str.replace("Command", "⌘")
