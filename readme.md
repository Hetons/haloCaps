# haloCaps⌨
![Static Badge](https://img.shields.io/badge/AutoHotKey-%E6%9E%84%E5%BB%BA-blue?logo=autohotkey&link=https%3A%2F%2Fwww.autohotkey.com%2F)
![Static Badge](https://img.shields.io/badge/%E7%94%9F%E4%BA%A7%E5%8A%9B%E5%B7%A5%E5%85%B7-8A2BE2?logo=googlesearchconsole&logoColor=white&link=https%3A%2F%2Fwww.autohotkey.com%2F)
![Static Badge](https://img.shields.io/badge/%E8%BD%BB%E9%87%8F%E7%BA%A7%E5%BA%94%E7%94%A8-green?logo=fastapi&logoColor=white&link=https%3A%2F%2Fwww.autohotkey.com%2F)



是一款轻量级全局热键设置软件，主要功能是通过将**不太常用**但是**地理位置绝佳**的`CapsLock`与**其他键**组合，来达到不同的功能。例如移动光标、删除等基本操作，大大增加码字效率，缩短手指移动距离！

现在也支持将`CapsLock`短按用于输入法内部中英文状态切换（可配置），并保持原有组合导航能力。


## 使用指南
1. 下载[Releases](https://github.com/TanYongF/haloCaps/releases)最新版本，解压到任意路径
2. 修改`conf.ini`中的`[keys]`段配置，每一行配置类似`caps_a = keyFunc_moveLeft`
- `caps_a`指代的是`CapsLock+A`按键键位
- `keyFunc_moveLeft`指的该键位下所要产生的功能。
2. 双击 `haloCaps.exe`，桌面出现绿色`H`图标，如下图所示
  
![image-1](https://kauizhaotan.oss-accelerate.aliyuncs.com/blog/image-1.png?x-oss-process=style/water)

### 目前支持的键位
- `caps_[qwerasdf]` (代表`CapsLock+Q/W/E/R/A/S/D/F`

### 目前支持的功能

|  函数名称   | 功能  |
|  ----  | ----  |
|  `keyFunc_moveDown` | 下移光标 |
| `keyFunc_moveUp`  | 上移光标 |
| `keyFunc_moveLeft` | 左移光标 |
| `keyFunc_moveRight` | 右移光标 |
| `keyFunc_delete`| 回退按键 |
| `keyFunc_enter` | 回车按键 | 


## 其他配置

### 1. 自启动
如果想要自启动只需要修改`conf.ini`下的`autostart`值即可
```ini
autostart = true/false 
```

### 2. 自定义组合键映射（推荐）
你可以在 `conf.ini` 的 `[remap]` 段中按 `源组合键 = 目标组合键` 配置，例如：
```ini
[remap]
!c = ^c
!v = ^v
```

说明：
- 左侧和右侧都使用 AHK 组合键语法，统一书写
- 常用修饰符：`!`(Alt), `^`(Ctrl), `+`(Shift), `#`(Win)
- 例如：`!c = ^c` 表示 `Alt+C` 映射为 `Ctrl+C`

### 3. Caps 轻按动作与输入法内部状态切换
你可以在`conf.ini`的`[global]`段中配置：

```ini
[global]
tap_action = keyFunc_imeSwitch
tap_threshold_ms = 500
```

说明：
- `tap_action`：填写要执行的函数名（默认 `keyFunc_imeSwitch`），例如 `keyFunc_toggleCapsLock`。
- `tap_threshold_ms`：短按判定阈值（毫秒），默认 `500`。

