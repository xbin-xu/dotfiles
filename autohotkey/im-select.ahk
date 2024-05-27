#Requires AutoHotkey v2.0
#SingleInstance Force

; Map `CapsLock` to `Ctrl`
CapsLock::Ctrl

; `Ctrl+[` map to `Esc`
^[::{
    send "{Esc}"
    setIMEConversionMode("EN")
}

; `Esc` to switch IME("EN")
~Esc::{
    setIMEConversionMode("EN")
}

; `LShift` to switch IME
~LShift::{
    if (getKeyboardLayout() != keyboardLayoutMap["微软拼音"]) {
        setIMEConversionMode("ZH")
    }
}

; 设置脚本是否可以 "看见" 隐藏的窗口
DetectHiddenWindows True

; ------------------------------------------------------------------------------
; 输入法对应的键盘布局 layout，该值可以通过 getKeyboardLayout() 获取
; 微软拼音-0x08040804(134481924)
; 美式键盘-0x04090409(67699721)
; ------------------------------------------------------------------------------
global keyboardLayoutMap := Map(
    "微软拼音", 0x08040804,
    "美式键盘", 0x04090409,
)

; ------------------------------------------------------------------------------
; 输入法对应的中英文模式 mode，可以通过 getIMEConversionMode() 获取
; 微软拼音-0(EN), 1025(ZH)
; 美式键盘-1025(EN), 1025(ZH)
; ------------------------------------------------------------------------------
global IMEConversionModeMap := Map(
    "微软拼音", Map("EN", 0, "ZH", 1025),
    "美式键盘", Map("EN", 1025, "ZH", 1025),
)

; ------------------------------------------------------------------------------
; 获取当前窗口的 IMEID
; ------------------------------------------------------------------------------
getKeyboardLayout() {
    threadID := DllCall("GetWindowThreadProcessId", "UInt", winGetID("A"), "UInt", 0)
    inputLocaleID := DllCall("GetKeyboardLayout", "UInt", threadID, "UInt")
    return inputLocaleID
}

; ------------------------------------------------------------------------------
; 切换到对应的输入法
; ------------------------------------------------------------------------------
switchKeyboardLayout(layout) {
    PostMessage(0x50, 0, layout, , WinGetID("A"))
}

; ------------------------------------------------------------------------------
; 获取当前输入法的模式
; ------------------------------------------------------------------------------
getIMEConversionMode() {
    return SendMessage(
        0x283, ; Message: WM_IME_CONTROL
        0x001, ; wParam: IMC_GETCONVERSIONMODE
        0,     ; lParam: (NoArgs)
        ,      ; Control: (Window)
        ; Retrieves the default window handle to the IME class
        "ahk_id " DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", winGetId("A"), "Uint")
    )
}

; ------------------------------------------------------------------------------
; 设置当前输入法的模式
; ------------------------------------------------------------------------------
setIMEConversionMode(language, layout := "微软拼音") {
    switchKeyboardLayout(keyboardLayoutMap[layout])
    mode := IMEConversionModeMap[layout][language]
    return SendMessage(
        0x283, ; Message: WM_IME_CONTROL
        0x002, ; wParam: IMC_SETCONVERSIONMODE
        mode,  ; lParam: 0(EN), 1025(CN)
        ,      ; Control: (Window)
        "ahk_id " DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", winGetId("A"), "Uint")
    )
}

/*
; 使用窗口组实现批量窗口的监视
GroupAdd "enAppGroup", "ahk_exe Code.exe"               ; VSCode
GroupAdd "enAppGroup", "ahk_exe pwsh.exe"               ; Powershell
GroupAdd "enAppGroup", "ahk_exe mintty.exe"             ; Git-Bash
GroupAdd "enAppGroup", "ahk_exe WindowsTerminal.exe"    ; Windows Terminal

; 循环等待知道窗口组的窗口激活，切换当前输入法为en,之后再等待当切换出当前窗口继续监视
Loop {
    WinWaitActive "ahk_group enAppGroup"
    currentWinID := WinGetID("A")

    ; TrayTip Format("当前是 {1}, 切换为 en 输入法", WinGetTitle("A"))
    switchKeyboardLayout(keyboardLayoutMap["微软拼音"])
    setIMEConversionMode(IMEConversionModeMap["微软拼音"]["EN"])

    ; 从当且窗口切出，进行下一轮监视
    WinWaitNotActive(currentWinID)
}
*/
