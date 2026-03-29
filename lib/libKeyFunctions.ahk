keyFunc_moveUp(){
    SendInput "{Up}"
    return
}

keyFunc_moveDown(){
    SendInput "{Down}"
}

keyFunc_moveLeft(){
    SendInput "{Left}"
}

keyFunc_moveRight(){
    SendInput "{Right}"
}

keyFunc_delete(){
    SendInput "{Backspace}"
}

keyFunc_enter(){
    SendInput "{Enter}"
}

keyFunc_toggleCapsLock(){
    SetCapsLockState GetKeyState("CapsLock","T") ? "Off" : "On"
}

keyFunc_imeSwitch() {
    ; Toggle CN/EN mode inside current IME by sending Shift tap.
    SendInput "{LShift down}{LShift up}"
    return true
}