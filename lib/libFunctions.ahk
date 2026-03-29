;运行函数字符串
runFunc(str){
    funcExpr := Trim(str)
    if funcExpr = ""
        return

    funcName := RegExReplace(funcExpr, "\s*\(\s*\)$")
    try {
        %funcName%()
    }
}

parseConfigBool(value, defaultValue := false) {
    normalized := StrLower(Trim(value))
    if normalized = "true" || normalized = "1" || normalized = "yes" || normalized = "on" {
        return true
    }
    if normalized = "false" || normalized = "0" || normalized = "no" || normalized = "off" {
        return false
    }
    return defaultValue
}

parseConfigInt(rawValue, defaultValue, minValue := "", maxValue := "") {
    value := Trim(rawValue)
    if !RegExMatch(value, "^\d+$") {
        return defaultValue
    }

    parsed := value + 0
    if (minValue != "" && parsed < minValue) {
        return minValue
    }
    if (maxValue != "" && parsed > maxValue) {
        return maxValue
    }
    return parsed
}


;检查单例程序，如果已有其他实例运行则退出
checkSingleInstance() {
    DetectHiddenWindows true
    
    ; 遍历所有ahk窗口
    hwnd := 0
    foundInstances := 0
    selfPath := StrLower(A_ScriptFullPath)
    Loop {
        hwnd := DllCall("FindWindowEx", "ptr", 0, "ptr", hwnd, "str", "AutoHotkey", "ptr", 0)
        if hwnd = 0
            break
        
        ; 获取窗口的进程ID和脚本路径
        pid := WinGetPID("ahk_id " hwnd)
        
        ; 检查是否是同一个脚本
        try {
            if A_IsCompiled {
                processPath := StrLower(ProcessGetPath(pid))
                if processPath = selfPath {
                    foundInstances++
                }
            } else {
                title := WinGetTitle("ahk_id " hwnd)
                if InStr(title, A_ScriptFullPath) {
                    foundInstances++
                }
            }
        }
    }
    
    DetectHiddenWindows false
    
    ; 如果找到多于1个实例，则退出当前实例
    if foundInstances > 1 {
        MsgBox("另一个haloCaps实例已在运行，程序即将退出。", "haloCaps")
        ExitApp
    }
}