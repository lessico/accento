#include "shared.au3"

If Not $CmdLine[0] = 3 Then Exit 10
Local $exe_location = $CmdLine[1]
Local $klc_to_compile = $CmdLine[2]
Local $rooted_workspace = $CmdLine[3]

If Not StringInStr($rooted_workspace, ":\") = 2 Then Exit 11
ExitIfError("Invalid arguments given to StringInStr for parsing rooted workspace.", 2)
If Not StringInStr($rooted_workspace, "\", 0, 1, 4) = 0 Then Exit 12
ExitIfError("Invalid arguments given to StringInStr for parsing rooted workspace.", 2)
Local $workspace = StringMid($rooted_workspace, 4)

; Read the keyboard short name from the first line of the KLC file (format: KBD <name> "<title>")
; and verify it matches the folder name to catch mismatches early.
Local $klc_file = FileOpen($klc_to_compile, 0)
If $klc_file = -1 Then Exit 13
Local $first_line = FileReadLine($klc_file)
FileClose($klc_file)
Local $parts = StringSplit($first_line, @TAB)
If $parts[0] < 2 Then Exit 14
Local $kbd_name = $parts[2]
If $kbd_name <> $workspace Then Exit 15

If FileExists($rooted_workspace) Then Exit 16
If Not DirCreate($rooted_workspace) Then Exit 16
Local $build_complete = False

; Start the program and get a handle to the main window
Local $msklc_pid = RunFromLocalFolder($exe_location)
OnAutoItExitRegister("Cleanup")

Func Cleanup()
    ProcessClose($msklc_pid)
    If Not $build_complete Then DirRemove($rooted_workspace, 1)
EndFunc

Local $main_wnd = WinWaitActive("Keyboard Layout Creator 1.4")
Const $dialog_id = "[CLASS:#32770]"

Func WaitForDialog()
    WinWaitNotActive($main_wnd)
    WinWaitActive($dialog_id)
EndFunc

; Remove any stale output from a previous build so we can reliably detect fresh files
FileDelete(@MyDocumentsDir & "\setup.exe")
FileDelete(@MyDocumentsDir & "\" & $kbd_name & ".*")

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
If Not StringInStr($verification_text, "Verification succeeded,") Then Exit 17
ControlClick($dialog_id, "", "[CLASS:Button; INSTANCE:2]")
WinWaitActive($main_wnd)

; Check if the build is quoted as successful and clear out the build result window
WaitForDialog()
Local $build_text = WinGetText($dialog_id)
If Not StringInStr($build_text, "The Windows Installer package was built successfully at") Then Exit 18
ControlSend($dialog_id, "", "", "n")

; Move all build output from Documents to the workspace
Sleep(1000)
If Not FileMove(@MyDocumentsDir & "\setup.exe", $rooted_workspace & "\setup.exe", 1) Then Exit 19
Local $search = FileFindFirstFile(@MyDocumentsDir & "\" & $kbd_name & "*")
If $search <> -1 Then
    While True
        Local $found = FileFindNextFile($search)
        If @error Then ExitLoop
        FileMove(@MyDocumentsDir & "\" & $found, $rooted_workspace & "\" & $found, 1)
    WEnd
    FileClose($search)
EndIf

$build_complete = True
