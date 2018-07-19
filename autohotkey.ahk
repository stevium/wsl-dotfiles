SetTitleMatchMode RegEx
return

; Toggle Title Bar
LWIN & B::
WinSet, Style, ^0xC00000, A
return

; Up
$^p::
If (ShouldMapArrows()) {
  send {Up}
} else {
  send ^p
}
return

; Down
$^n::
If (ShouldMapArrows()) {
  send {Down}
} else {
  send ^n
}
return

ShouldMapArrows() {
  WindowTitles := ["JetPopup", "Visual Studio", "QuickWatch", "Add Scaffold", "Cortana"]
  WindowClasses := ["ahk_class ExploreWClass|CabinetWClass"]
  ShouldMap := 0

  WinGetTitle, Title, A
  for index, element in WindowTitles
  {
    ShouldMap := ShouldMap || InStr(Title, element)
  }

  for index, element in WindowClasses
  {
    ShouldMap := ShouldMap || WinActive(element)
  }

  return ShouldMap
}

; Context Menu
Appskey::Send +{F10}

; Open Wsl when Windows Explorer is open
#If WinActive("ahk_class ExploreWClass|CabinetWClass") || IsDesktopActive() {
  ^t::OpenWsl()
}

OpenWsl() {
  currentPath := GetSelectedPath()
  if currentPath {
    Run C:\wsl-terminal\vim.exe "%currentPath%"
    return
  }

  if IsDesktopActive() {
    EnvGet, vUserProfile, USERPROFILE
    currentPath := vUserProfile . "\Desktop"
  }
  else {
    for w in ComObjCreate("Shell.Application").Windows
    currentPath := w.Document.Folder.Self.Path
  }
  Run C:\wsl-terminal\open-wsl.exe -W %currentPath%
}

IsDesktopActive() {
  MouseGetPos,,,win
  WinGetClass, class, ahk_id %win%
  if class in Progman,WorkerW
    return True
  return False
}

GetSelectedPath() { ;Get Select Path for Folder or File
  IsClipEmpty := (Clipboard = "") ? 1 : 0
  if !IsClipEmpty {
    ClipboardBackup := ClipboardAll
    While !(Clipboard = "") {
      Clipboard =
      Sleep, 10
    }
  }
  Send, ^c
  ClipWait, 0.1
  ToReturn := Clipboard, Clipboard := ClipboardBackup
  if !IsClipEmpty
    ClipWait, 0.5, 1
  return ToReturn
}
