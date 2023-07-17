extends Control


func _ready() -> void:
    $LineEdit.grab_focus()


func _on_line_edit_text_submitted(line: String) -> void:
    var args    = Array(line.strip_edges().split(" "))
    var command = args.pop_front()
    var output  = []
    var exit_code = OS.execute(command, args, output)
    print_command(command, args, output[0])
    $LineEdit.text = ""


func  print_command(command: String, args: Array, result: String):
    $RichTextLabel.text = "$ " + command + " ".join(args) + "\n" +  \
        result + $RichTextLabel.text
