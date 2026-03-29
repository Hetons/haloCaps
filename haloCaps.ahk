#SingleInstance Ignore

;管理员身份重启
full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    ExitApp
}


#Include "lib"
#Include libKeyFunctions.ahk
#Include libFunctions.ahk
#Include libSettings.ahk

#Warn
SetStoreCapslockMode false
ProcessSetPriority "High"

checkSingleInstance()

;--::-------------------------
;  KEY_TO_NAME := {"a":"a","b":"b","c":"c","d":"d","e":"e","f":"f","g":"g","h":"h","i":"i"
;    ,"j":"j","k":"k","l":"l","m":"m","n":"n","o":"o","p":"p","q":"q","r":"r"
;    ,"s":"s","t":"t","u":"u","v":"v","w":"w","x":"x","y":"y","z":"z"
;    ,"1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","0":"0"
;    ,"f1":"f1","f2":"f2","f3":"f3","f4":"f4","f5":"f5","f6":"f6"
;    ,"f7":"f7","f8":"f8","f9":"f9","f10":"f10","f11":"f11","f12":"f12"
;    ,"f13":"f13","f14":"f14","f15":"f15","f16":"f16","f17":"f17","f18":"f18","f19":"f19"
;    ,"space":"space","tab":"tab","enter":"enter","esc":"esc","backspace":"backspace"
;    ,"`":"backQuote","-":"minus","=":"equal","[":"leftSquareBracket","]":"rightSquareBracket"
;    ,"\":"backSlash",";":"semicolon","'":"quote",",":"comma",".":"dot","/":"slash","ralt":"ralt"
;    ,"wheelUp":"wheelUp","wheelDown":"wheelDown"}

;  for k,v in KEY_TO_NAME{
;      msgbox, % v
;  }

;从conf.ini中读取键位对应的功能
; LoadKeyMapFromConf()


;-------------------core function start------------------------
global capsLockPressed := ""
global capsLockPlusUsed := "" ;判断是否使用过capslock plus功能，如果使用过那么就不会执行capslock默认操作
global capsLockLongPressed := "" ;判断是否长按capslock

registerRemapHotkeys()

; 支持按住caps键后再按其他键（一次或多次）来触发功能，超时时间为 500ms
CapsLock:: {
    global
    capsLockPressed := true ;caps键被按下
    capsLockPlusUsed := false
    capsLockLongPressed := false
    ; 在阈值内松开视为短按，超时则视为长按并取消短按动作
    releasedWithinThreshold := KeyWait("CapsLock", "T" . (tapThresholdMs / 1000))
    if !releasedWithinThreshold {
        capsLockLongPressed := true
        KeyWait "CapsLock"
    }

    capsLockPressed := false ;关闭capslock功能
    if (capsLockLongPressed && !capsLockPlusUsed) {
        keyFunc_toggleCapsLock()
    } else if !capsLockPlusUsed {
        runTapAction()
    }
    capsLockPlusUsed := true
}

; bind hotkey to functions
#HotIf capsLockPressed
q::
w::
e::
r::
a::
d::
s::
f:: {
    global
    runFunc(keymap["caps_" . A_ThisHotkey])
    capsLockPlusUsed := true

}

registerRemapHotkeys() {
    global remapMap
    for sourceHotkey, targetSend in remapMap {
        Hotkey sourceHotkey, sendRemap.Bind(targetSend)
    }
}

sendRemap(targetSend, *) {
    SendInput targetSend
}

runTapAction() {
    global tapAction
    actionName := Trim(tapAction)
    if (actionName = "") {
        keyFunc_toggleCapsLock()
        return
    }

    try {
        %actionName%()
    } catch {
        keyFunc_toggleCapsLock()
    }
}
