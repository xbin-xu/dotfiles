#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 0. Global
; ==============================================================================
; Turns on the detection of hidden windows
DetectHiddenWindows True

; CapsLock -> Ctrl
CapsLock::Ctrl

; ==============================================================================
; 1. im-select
; ==============================================================================
; `Ctrl+[` -> `Esc` + switch IME("EN")
^[:: {
	send "{Esc}"
	switchIME("EN")
}

; `Esc` -> `Esc` + switch IME("EN")
~Esc:: switchIME("EN")

; `LShift` -> `LShift` + switch IME
~LShift:: {
	try {
		if !isMicrosoftPinyinLayout() {
			switchIME("ZH")
		}
	} catch {
	}
}

; ------------------------------------------------------------------------------
; im-select implement
; ------------------------------------------------------------------------------
; 输入法对应的键盘布局 layout
global keyboardLayoutMap := Map(
	"微软拼音", 0x08040804,
	"美式键盘", 0x04090409,
)

; 输入法对应的中英文模式 mode
global IMEConversionModeMap := Map(
	"微软拼音", Map("EN", 0, "ZH", 1025),
	"美式键盘", Map("EN", 1025, "ZH", 1025),
)

switchIME(mode) {
	try setIMEConversionMode(mode)
}

isMicrosoftPinyinLayout() {
	return getKeyboardLayout() = keyboardLayoutMap["微软拼音"]
}

; 获取当前窗口的 IMEID
getKeyboardLayout() {
	threadID := DllCall("GetWindowThreadProcessId", "UInt", winGetID("A"), "UInt", 0)
	inputLocaleID := DllCall("GetKeyboardLayout", "UInt", threadID, "UInt")
	return inputLocaleID
}

; 切换到对应的输入法
switchKeyboardLayout(layout) {
	PostMessage(0x50, 0, layout, , WinGetID("A"))
}

; 获取当前输入法的模式
getIMEConversionMode() {
	return SendMessage(
		0x283, ; Message: WM_IME_CONTROL
		0x001, ; wParam: IMC_GETCONVERSIONMODE
		0,     ; lParam: (NoArgs)
		,      ; Control: (Window)
		"ahk_id " DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", winGetId("A"), "Uint")
	)
}

; 设置当前输入法的模式
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

; ==============================================================================
; 2. Raycast Navigation Binding
; ==============================================================================

#HotIf WinActive("ahk_exe Raycast.exe")
^o::^k      ; Ctrl+o -> Ctrl+k(actions)
^h::Left    ; Ctrl+h -> Left
^j::Down    ; Ctrl+j -> Down
^k::UP      ; Ctrl+k -> Up
^l::Right   ; Ctrl+l -> Right
#HotIf

; ==============================================================================
; 3. Herdr: Simulate switch_ascii_input_source_in_prefix
; ==============================================================================
; Press prefix in Herdr (a default window_title "<hostname>: ...")
; -> pass prefix through + switchIME("EN").
; Double press prefix within timeout (ms) means: herdr sends a literal prefix
; ->  restore the IME recorded by the first press.

global herdrIMEWasZh := false       ; IME was ZH when Ctrl+a was pressed
global herdrPrefixTimeout := 600    ; double-press window in ms
global herdrPrefixPrevTick := 0     ; tick of that first press
global herdrAwaitingDouble := false ; a first press is pending

#HotIf WinActive(A_ComputerName ": ")
~^a:: {
	global herdrIMEWasZh, herdrAwaitingDouble, herdrPrefixPrevTick, herdrPrefixTimeout

	try {
		if (herdrAwaitingDouble && A_TickCount - herdrPrefixPrevTick < herdrPrefixTimeout) {
			; double press within timeout: restore the IME state
			if (herdrIMEWasZh) {
				switchIME("ZH")
			}
			herdrIMEWasZh := false
			herdrAwaitingDouble := false
		} else {
			; first press: record the IME state, switch to EN
			herdrIMEWasZh := isMicrosoftPinyinLayout() && getIMEConversionMode() = 1025
			switchIME("EN")
			herdrAwaitingDouble := true
			herdrPrefixPrevTick := A_TickCount
		}
	} catch {
	}
}
#HotIf
