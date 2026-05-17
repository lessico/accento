#include "shared.au3"

If Not $CmdLine[0] = 3 Then Exit 10
Local $exe_location = $CmdLine[1]
Local $klc_to_compile = $CmdLine[2]
Local $rooted_workspace = $CmdLine[3]

If Not StringInStr($rooted_workspace, ":\") = 2 Then Exit 11
ExitIfError("Invalid arguments given to StringInStr for parsing rooted workspace.", 2)
If Not StringInStr($rooted_workspace, "\", 0, 1, 4) = 0 Then Exit 12
ExitIfError("Invalid arguments given to StringInStr for parsing rooted workspace.", 2)
Local $drive_letter = StringLeft($rooted_workspace, 1)
Local $workspace = StringMid($rooted_workspace, 4)

; Start the program and get a handle to the main window
Local $msklc_pid = RunFromLocalFolder($exe_location)
OnAutoItExitRegister("Cleanup")

Func Cleanup()
    ProcessClose($msklc_pid)
EndFunc

Local $main_wnd = WinWaitActive("Keyboard Layout Creator 1.4")
Const $dialog_id = "[CLASS:#32770]"

Func WaitForDialog()
    WinWaitNotActive($main_wnd)
    WinWaitActive($dialog_id)
EndFunc

; Set the working directory for the compilation output
If Not FileExists($rooted_workspace) Then
    If Not DirCreate($rooted_workspace) Then Exit 13
EndIf

Func GetControlViewIndex($prefix, $target)
    Local $i = 0
    While True
        Sleep(500)
        Local $item = ControlTreeView($dialog_id, "", "[CLASS:SysTreeView32; INSTANCE:1]", "GetText", $prefix & "|#" & $i)
        If @error Then ExitLoop
        If StringInStr($item, $target) Then
            Return $i
        EndIf
        $i += 1
    WEnd
    Return -1
EndFunc

ControlClick($main_wnd, "", "[NAME:btnCurDir]")
WaitForDialog()
; Use BFFM_SETSELECTIONW (WM_USER + 103) to navigate the folder browser to
; the target path without relying on tree view navigation, which varies across
; Windows versions.
Const $BFFM_SETSELECTIONW = 0x467
Local $dlg_hwnd = WinGetHandle($dialog_id)
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $dlg_hwnd, "uint", $BFFM_SETSELECTIONW, "wparam", 1, "wstr", $rooted_workspace)
Sleep(1000)
ControlClick($dialog_id, "", "[CLASS:Button; INSTANCE:2]")
WinWaitActive($main_wnd)

; Open up the file that is being compiled
ControlSend($main_wnd, "", "", "^o")
WaitForDialog()
ControlSetText($dialog_id, "", "[CLASS:Edit; INSTANCE:1]", $klc_to_compile)
ControlSend($dialog_id, "", "", "{ENTER}")
WinWaitActive($main_wnd)

; Build the file that has been loaded and clear out the verification window
ControlSend($main_wnd, "", "", "!p")
ControlSend($main_wnd, "", "", "b")
WaitForDialog()
Local $verification_text = WinGetText($dialog_id)
Local $expected_verification_text = "Verification succeeded."
If Not StringInStr($verification_text, $expected_verification_text) Then Exit 17
ControlClick($dialog_id, "", "[CLASS:Button; INSTANCE:1]")
WinWaitActive($main_wnd)

; Check if the build is quoted as successful and clear out the build result window
WaitForDialog()
Local $build_text = WinGetText($dialog_id)
Local $expected_build_text = "The Windows Installer package was built successfully at"
If Not StringInStr($build_text, $expected_build_text) Then Exit 18
ControlSend($dialog_id, "", "", "n")