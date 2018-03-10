SetTitleMatchMode RegEx
return

; Toggle Title Bar
LWIN & B::
WinSet, Style, ^0xC00000, A
return

; {Up,Down}
if ShouldMapArrows() {
  ^P::Send {Up}
  ^N::Send {Down}
}

; Context Menu
Appskey::Send +{F10}

; Open Wsl when Windows Explorer is open
#If WinActive("ahk_class ExploreWClass|CabinetWClass") || IsDesktopActive() {
  ^t::OpenWsl()
}

ShouldMapArrows() {
  WinGetTitle, Title, A
  return InStr(Title, "JetPopup")
    || InStr(Title, "Visual Studio")
    || InStr(Title, "QuickWatch")
    || InStr(Title, "Add Scaffold")
    || InStr(Title, "Cortana")
    || InStr(Title, "Run")
    || WinActive("ahk_class ExploreWClass|CabinetWClass")
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
  rlse {
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
