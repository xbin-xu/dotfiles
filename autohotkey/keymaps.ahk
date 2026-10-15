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
; Herdr prefix mode with no timeout.
;   1st prefix    -> enter prefix mode
;   prefix again  -> herdr sends a literal prefix to the pane, exits prefix
;   any other key -> herdr consumes it as the command, exits prefix
; This script never intercepts or re-sends keys. One InputHook observes every
; keydown and mirrors herdrInPrefix; all IME work is deferred ~10ms via
; SetTimer so it can never race the in-flight keystroke:
;   1st prefix    -> record the IME state, switch to EN
;   prefix again  -> restore the recorded state
;   any other key -> only clear the flag, IME untouched
; Bare modifiers are invisible to terminals (CapsLock counts as one because
; section 0 remaps it to Ctrl); Alt/Win combos other than the configured
; prefix don't reliably reach herdr, so they are ignored.

global herdrWinTitle := A_ComputerName ": "
global herdrInPrefix := false ; mirror of herdr's prefix mode
global herdrIMEWasZH := false ; IME was ZH when entering prefix mode
global herdrIMEDelayMs := 10  ; defer IME work: deliver the in-flight key first
global herdrPrefix := "ctrl+a" ; keep in sync with herdr config [keys] prefix
global herdrPfx := herdrParsePrefix(herdrPrefix) ; parsed once: {vk, mods}

global MODIFIER_VKS := Map(
	GetKeyVK("LCtrl"), true, GetKeyVK("RCtrl"), true,
	GetKeyVK("LShift"), true, GetKeyVK("RShift"), true,
	GetKeyVK("LAlt"), true, GetKeyVK("RAlt"), true,
	GetKeyVK("LWin"), true, GetKeyVK("RWin"), true,
	GetKeyVK("CapsLock"), true, ; remapped to Ctrl in section 0
)

; "ctrl+a" in herdr's own config syntax -> {vk, mods}, parsed once at
; startup. Also accepts "alt+a", "f12", "-", ... ; modifier names:
; ctrl/shift/alt/win (win also answers to super/cmd/meta).
; mods come out in herdrMods()'s canonical order regardless of input order.
herdrParsePrefix(prefix) {
	parts := StrSplit(prefix, "+")
	key := Trim(parts.Pop())
	c := false, s := false, a := false, w := false
	for _, m in parts {
		switch StrLower(Trim(m)) {
			case "ctrl", "control": c := true
			case "shift": s := true
			case "alt": a := true
			case "win", "super", "cmd", "meta": w := true
			default: throw ValueError('herdrPrefix: unknown modifier "' m '"')
		}
	}
	vk := GetKeyVK(key)
	if (!vk) {
		throw ValueError('herdrPrefix: unknown key "' key '"')
	}
	mods := (c ? "^" : "") (s ? "+" : "") (a ? "!" : "") (w ? "#" : "")
	return { vk: vk, mods: mods }
}

herdrMods() {
	mods := ""
	if (GetKeyState("Ctrl"))
		mods .= "^"
	if (GetKeyState("Shift"))
		mods .= "+"
	if (GetKeyState("LAlt") || GetKeyState("RAlt"))
		mods .= "!"
	if (GetKeyState("LWin") || GetKeyState("RWin"))
		mods .= "#"
	return mods
}

herdrObserveKey(_ih, vk, _sc) {
	global herdrInPrefix, herdrIMEDelayMs

	if (!WinActive(herdrWinTitle)) {
		return
	}

	if (MODIFIER_VKS.Has(vk)) {
		return
	}

	if (vk = herdrPfx.vk && herdrMods() = herdrPfx.mods) {
		hwnd := WinExist("A")
		if (herdrInPrefix) {
			herdrInPrefix := false
			SetTimer(() => herdrRestoreIME(hwnd), -herdrIMEDelayMs)
		} else {
			herdrInPrefix := true
			SetTimer(() => herdrEnterPrefixIME(hwnd), -herdrIMEDelayMs)
		}
		return
	}

	; other Alt/Win chords are skipped: the OS/shell eats the common ones
	; (alt+tab, win+d) and herdr's config docs call the rest unreliable
	if (GetKeyState("LAlt") || GetKeyState("RAlt") || GetKeyState("LWin") || GetKeyState("RWin")) {
		return
	}

	; herdr consumes this key and leaves prefix mode
	herdrInPrefix := false
}

herdrEnterPrefixIME(hwnd) {
	global herdrIMEWasZH
	if (WinExist("A") != hwnd) {
		return ; focus already moved on: never IME-switch a foreign window
	}
	try {
		herdrIMEWasZH := isMicrosoftPinyinLayout() && getIMEConversionMode() = 1025
		switchIME("EN")
	} catch {
	}
}

herdrRestoreIME(hwnd) {
	global herdrIMEWasZH
	if (WinExist("A") != hwnd) {
		return
	}
	if (herdrIMEWasZH) {
		switchIME("ZH")
	}
	herdrIMEWasZH := false
}

; V = pass keys through untouched
; L0 = collect no text
; I1 = ignore this script's own Send
ih := InputHook("V L0 I1")
ih.KeyOpt("{All}", "N") ; KeyOpt N = notify non-text keys too
ih.OnKeyDown := herdrObserveKey
ih.Start()
