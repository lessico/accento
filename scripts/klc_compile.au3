#include "shared.au3"

If Not $CmdLine[0] = 3 Then Exit 1

Local $exe_location = $CmdLine[1]
Local $klc_to_compile = $CmdLine[2]
Local $workspace = $CmdLine[3]

; Read the keyboard short name from the first line of the KLC file (KBD<TAB><name><TAB>"<title>")
Local $klc_file = FileOpen($klc_to_compile, 0)
If $klc_file = -1 Then Exit 2
Local $first_line = FileReadLine($klc_file)
FileClose($klc_file)
Local $parts = StringSplit($first_line, @TAB)
If $parts[0] < 3 Then Exit 3
Local $kbd_name = $parts[2]

; MSKLC outputs to @MyDocumentsDir\<kbd_name> — ensure it does not already exist
Local $msklc_output = @MyDocumentsDir & "\" & $kbd_name
If FileExists($msklc_output) Then Exit 4

Local $log = FileOpen("C:\autoit_debug.txt", 2)
FileWriteLine($log, "MyDocumentsDir:  " & @MyDocumentsDir)
FileWriteLine($log, "kbd_name:        " & $kbd_name)
FileWriteLine($log, "msklc_output:    " & $msklc_output)
FileWriteLine($log, "workspace:       " & $workspace)
FileWriteLine($log, "klc_to_compile:  " & $klc_to_compile)

Local $msklc_pid = RunFromLocalFolder($exe_location)
OnAutoItExitRegister("Cleanup")

Func Cleanup()
    FileWriteLine($log, "Cleanup running")
    FileClose($log)
    ProcessClose($msklc_pid)
    DirRemove($msklc_output, 1)
EndFunc

Local $main_wnd = WinWaitActive("Keyboard Layout Creator 1.4")
Const $dialog_id = "[CLASS:#32770]"

Func WaitForDialog()
    WinWaitNotActive($main_wnd)
    WinWaitActive($dialog_id)
EndFunc

; Open the KLC file
ControlSend($main_wnd, "", "", "^o")
WaitForDialog()
ControlSetText($dialog_id, "", "[CLASS:Edit; INSTANCE:1]", $klc_to_compile)
ControlSend($dialog_id, "", "", "{ENTER}")
WinWaitActive($main_wnd)

; Build and verify
FileWriteLine($log, "Starting build")
ControlSend($main_wnd, "", "", "!p")
ControlSend($main_wnd, "", "", "b")
WaitForDialog()
Local $verification_text = WinGetText($dialog_id)
FileWriteLine($log, "Verification dialog text: " & $verification_text)
If Not StringInStr($verification_text, "Verification succeeded,") Then Exit 5
ControlClick($dialog_id, "", "[CLASS:Button; INSTANCE:2]")
WinWaitActive($main_wnd)

WaitForDialog()
Local $build_text = WinGetText($dialog_id)
FileWriteLine($log, "Build dialog text: " & $build_text)
If Not StringInStr($build_text, "The Windows Installer package was built successfully at") Then Exit 6
ControlSend($dialog_id, "", "", "n")

; Move the build output folder from Documents to the provided workspace path
Sleep(1000)
FileWriteLine($log, "msklc_output exists after build: " & FileExists($msklc_output))
Local $search = FileFindFirstFile($msklc_output & "\*")
If $search <> -1 Then
    While True
        Local $found = FileFindNextFile($search)
        If @error Then ExitLoop
        FileWriteLine($log, "  found: " & $found)
    WEnd
    FileClose($search)
EndIf
Local $move_result = DirMove($msklc_output, $workspace, 1)
FileWriteLine($log, "DirMove result: " & $move_result)
If Not $move_result Then Exit 7
