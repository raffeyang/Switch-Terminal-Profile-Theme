#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle System Appearance
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon images/Apperance Toggle.png
# @raycast.author Raffe Yang
# @raycast.authorURL https://raffeyang.com
# @raycast.description Script Command to switch between the system appearance, light and dark mode.

-- 切换 macOS 外观模式
tell application "System Events"
    tell appearance preferences
        set dark mode to not dark mode
    end tell
end tell

-- 获取当前的外观模式并保存
tell application "System Events"
    set darkMode to (dark mode of appearance preferences)
end tell

-- 保存外观模式到用户默认设置
if darkMode then
    do shell script "defaults write com.raffeyang.terminal DarkMode -bool true"
    set desiredProfile to "Basic" -- 替换为深色模式的 Profile 名称
else
    do shell script "defaults write com.raffeyang.terminal DarkMode -bool false"
    set desiredProfile to "Basic Light" -- 替换为浅色模式的 Profile 名称
end if

-- 检查终端是否已运行
tell application "System Events"
    set isTerminalRunning to (count of (application processes whose name is "Terminal")) > 0
end tell

-- 仅在 Terminal 已运行时切换终端 Profile
if isTerminalRunning then
    tell application "Terminal"
        set currentProfile to name of default settings
        if currentProfile is not equal to desiredProfile then
            set default settings to settings set desiredProfile
            set every window's current settings to settings set desiredProfile
        end if
    end tell
end if
