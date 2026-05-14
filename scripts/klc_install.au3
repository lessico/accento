#include "shared.au3"

If Not $CmdLine[0] = 3 Then Exit 1
Local $exe_location = $CmdLine[1]
Local $extract_location = $CmdLine[2]
Local $install_location = $CmdLine[3]

If FileExists($extract_location & "\MSKLC") Then Exit 1

Const $extract_to_location_control = "[CLASS:Edit; INSTANCE:1]"
Const $extract_button_control = "[CLASS:Button; INSTANCE:2]"

Local $install_msklc_pid = RunFromLocalFolder($exe_location)
Local $main_wnd = WinWaitActive("7-Zip self-extracting archive")

ControlSetText($main_wnd, "", $extract_to_location_control, $extract_location)
ControlClick($main_wnd, "", $extract_button_control)
WinWaitNotActive($main_wnd)

If Not FileExists($install_location) Then
    If Not DirCreate($install_location) Then Exit 1
EndIf
Local $msi_install_cmd = "msiexec /i " & $extract_location & "\MSKLC\MSKLC.msi /qn /l* msklc_install.log TARGETDIR=""" & $install_location & """ MSIINSTALLPERUSER=1"

Local $exit_code = RunWait(@ComSpec & " /c " & $msi_install_cmd , "", @SW_HIDE)
If (@error <> 0 Or $exit_code <> 0) Then Exit 1