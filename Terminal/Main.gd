extends Control

var histories = []
var current_index = -1


func _ready() -> void:
    $LineEdit.grab_focus()


func _on_line_edit_text_submitted(line: String) -> void:
    var args    = Array(line.strip_edges().split(" "))
    var command = args.pop_front()
    if !command: return
    execute(command, args.filter(func(s): return !s.is_empty()))
    clear_input()


func execute(command: String, args: Array):
    var output    = []
    var exit_code = OS.execute(command, args, output, true)
    histories.push_back([command, args])
    current_index = histories.size()
    print_command(command, args, output[0])


func print_command(command: String, args: Array, result: String):
    $RichTextLabel.text = "$ " + command + " " + " ".join(args) \
        + "\n" + result + $RichTextLabel.text


func clear_terminal() -> void:
    $RichTextLabel.text = ""


func clear_input() -> void:
    $LineEdit.text = ""


func set_input(command: String) -> void:
    $LineEdit.text = command
    $LineEdit.set_caret_column(command.length())


func set_prev_history() -> void:
    if current_index == -1:
        set_input("")
    elif histories.size() > 0:
        current_index -= 1
        if current_index != -1:
            set_input(get_command_history(current_index))
        else:
            set_input("")


func set_next_history() -> void:
    if current_index == -1:
        if histories.size() > 0:
            current_index += 1
            set_input(get_command_history(current_index))
        else:
            set_input("")
    elif current_index + 1 < histories.size():
        current_index += 1
        set_input(get_command_history(current_index))
    else:
        current_index = histories.size()
        set_input("")


func get_command_history(index) -> String:
    var args = histories[current_index].duplicate(true)
    var command = args.pop_front()
    return command + " " + " ".join(args[0])


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("clear_terminal"):
        clear_terminal()
    elif event.is_action_pressed("clear_input"):
        clear_input()
    elif event.is_action_pressed("set_prev_history"):
        set_prev_history()
    elif event.is_action_pressed("set_next_history"):
        set_next_history()

