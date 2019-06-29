function bool_to_num(flag: boolean)
{
    if (flag) {
        return "1"
    } else {
        return "0"
    }
}

basic.forever(function() {
    let out = ""
    out += (input.runningTime() / 1000).toString() + " "
    out += bool_to_num(input.buttonIsPressed(Button.A)) + " "
    out += bool_to_num(input.buttonIsPressed(Button.B)) + " "
    out += input.temperature().toString() + " "
    out += input.lightLevel().toString() + " "
    out += input.compassHeading().toString() + " "
    out += input.rotation(Rotation.Pitch).toString() + " "
    out += input.acceleration(Dimension.X).toString() + " "
    out += input.acceleration(Dimension.Y).toString() + " "
    out += input.acceleration(Dimension.Z).toString()
    serial.writeLine(out)
    basic.pause(10)
})
