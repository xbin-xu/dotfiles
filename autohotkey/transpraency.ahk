#t::
{
    ExStyle := WinGetExStyle("A")
    if (ExStyle & 0x8) {
        WinSetTransparent "", "A"
        WinSetAlwaysOnTop 0, "A"
    } else {
        WinSetTransparent 245, "A"
        WinSetAlwaysOnTop 1, "A"
    }
}
