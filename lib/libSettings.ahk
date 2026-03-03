global keymap := Map()
global globalConfig := Map()
global remapMap := Map()
FilePath := "./conf.ini"
SectionName := "keys"
globalConfigSectionName := "global"
remapSectionName := "remap"

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

readSectionKeys(filePath, sectionName) {
    try {
        sectionContent := IniRead(filePath, sectionName)
        sectionContent := RegExReplace(sectionContent, "m`n)=.*$")
        return StrSplit(sectionContent, "`n")
    } catch {
        return []
    }
}


;读取全局配置
For index, keyName in readSectionKeys(FilePath, globalConfigSectionName) {
    value := IniRead(FilePath, globalConfigSectionName, keyName)
    globalConfig[keyName] := value
}

;读取键值对映射
For index, keyName in readSectionKeys(FilePath, SectionName) {
    value := IniRead(FilePath, SectionName, keyName)
    keymap[keyName] := value
}

;读取组合键映射 remap (示例: !c = ^c)
For index, keyName in readSectionKeys(FilePath, remapSectionName) {
    value := IniRead(FilePath, remapSectionName, keyName)
    sourceHotkey := Trim(keyName)
    targetSend := Trim(value)
    if sourceHotkey != "" && targetSend != "" {
        remapMap[sourceHotkey] := targetSend
    }
}


globalSettins:
    autostartLink := A_StartupCommon . "\haloCaps.lnk"
    if configToBool(globalConfig["autostart"]) {
        if FileExist(autostartLink) {
            FileGetShortcut(autostartLink, &lnkTarget)
            if lnkTarget != A_ScriptFullPath {
                FileCreateShortcut(A_ScriptFullPath, autostartLink, A_WorkingDir)    
            }
        } else {
            FileCreateShortcut(A_ScriptFullPath, autostartLink, A_WorkingDir)
        }
    }else{
        FileDelete autostartLink
    }
