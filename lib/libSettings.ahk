global keymap := Map()
global globalConfig := Map()
global remapMap := Map()
global tapAction := "keyFunc_imeSwitch"
global tapThresholdMs := 500
FilePath := "./conf.ini"
capsLockSectionName := "keys"
globalConfigSectionName := "global"
remapSectionName := "remap"

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
    ; 根据全局配置设置自动启动
    autostartLink := A_StartupCommon . "\haloCaps.lnk"
    if parseConfigBool(globalConfig.Get("autostart", "false")) {
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

    ; 根据全局配置设置 tapAction 和 tapThresholdMs
    global globalConfig, tapAction, tapThresholdMs
    rawAction := Trim(globalConfig.Get("tap_action", "keyFunc_imeSwitch"))
    if (rawAction != "") {
        tapAction := rawAction
    } else {
        tapAction := "keyFunc_imeSwitch"
    }

    tapThresholdMs := parseConfigInt(globalConfig.Get("tap_threshold_ms", "500"), 500, 50)
