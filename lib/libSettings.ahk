global keymap := Map()
global globalConfig := Map()
global remapMap := Map()
FilePath := "./conf.ini"
capsLockSectionName := "keys"
globalConfigSectionName := "global"
remapSectionName := "remap"

; 判断布尔类型键值
configToBool(value, defaultValue := false) {
    normalized := StrLower(Trim(value))
    if normalized = "true" || normalized = "1" || normalized = "yes" || normalized = "on" {
        return true
    }
    if normalized = "false" || normalized = "0" || normalized = "no" || normalized = "off" {
        return false
    }
    return defaultValue
}

; 读取配置文件
readSectionKeys(filePath, sectionName) {
    try {
        sectionContent := IniRead(filePath, sectionName)
        sectionContent := RegExReplace(sectionContent, "m`n)=.*$")
        return StrSplit(sectionContent, "`n")
    } catch {
        return []
    }
}

readSectionToMap(filePath, sectionName, targetMap, trimKey := false, trimValue := false, skipEmptyValue := false) {
    try {
        sectionContent := IniRead(filePath, sectionName)
    } catch {
        return
    }

    For _, rawLine in StrSplit(sectionContent, "`n", "`r") {
        line := Trim(rawLine)
        if line = ""
            continue

        equalPos := InStr(line, "=")
        if equalPos <= 0
            continue

        keyName := SubStr(line, 1, equalPos - 1)
        value := SubStr(line, equalPos + 1)

        if trimKey
            keyName := Trim(keyName)
        if trimValue
            value := Trim(value)

        if keyName = ""
            continue
        if skipEmptyValue && value = ""
            continue

        targetMap[keyName] := value
    }
}



readKeyMapFunction:
    ;读取全局配置
    readSectionToMap(FilePath, globalConfigSectionName, globalConfig)

    ;读取键值对映射
    readSectionToMap(FilePath, capsLockSectionName, keymap)

    ;读取组合键映射 remap (示例: !c = ^c)
    readSectionToMap(FilePath, remapSectionName, remapMap, true, true, true)


globalSettings:
    autostartLink := A_StartupCommon . "\haloCaps.lnk"
    if configToBool(globalConfig.Get("autostart", "false")) {
        if FileExist(autostartLink) {
            FileGetShortcut(autostartLink, &lnkTarget)
            if lnkTarget != A_ScriptFullPath {
                FileCreateShortcut(A_ScriptFullPath, autostartLink, A_WorkingDir)    
            }
        } else {
            FileCreateShortcut(A_ScriptFullPath, autostartLink, A_WorkingDir)
        }
    }else{
        if FileExist(autostartLink) {
            FileDelete autostartLink
        }
    }
