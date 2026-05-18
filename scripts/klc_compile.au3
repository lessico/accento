#include "shared.au3"

Const $EXIT_USAGE_ERROR = 1
Const $EXIT_KLC_OPEN_ERROR = 2
Const $EXIT_KLC_FORMAT_ERROR = 3
Const $EXIT_OUTPUT_EXISTS = 4
Const $EXIT_DEST_EXISTS = 5
Const $EXIT_VERIFICATION_FAILED = 6
Const $EXIT_BUILD_FAILED = 7
Const $EXIT_MOVE_FAILED = 8
Const $EXIT_TIMEOUT_MAIN_WND = 9
Const $EXIT_TIMEOUT_OPEN_INACTIVE = 10
Const $EXIT_TIMEOUT_OPEN_DIALOG = 11
Const $EXIT_TIMEOUT_MAIN_AFTER_OPEN = 12
Const $EXIT_TIMEOUT_VERIFY_INACTIVE = 13
Const $EXIT_TIMEOUT_VERIFY_DIALOG = 14
Const $EXIT_TIMEOUT_MAIN_AFTER_VERIFY = 15
Const $EXIT_TIMEOUT_BUILD_INACTIVE = 16
Const $EXIT_TIMEOUT_BUILD_DIALOG = 17

Const $POST_ACTIVE_WAIT_MS = 2000

Const $TIMEOUT = 60
Const $dialog_id = "[CLASS:#32770]"

If Not $CmdLine[0] = 4 Then Exit $EXIT_USAGE_ERROR

Local $exe_location = $CmdLine[1]
Local $klc_to_compile = $CmdLine[2]
Local $workspace = $CmdLine[3]
Local $output_name = $CmdLine[4]

; Read the keyboard short name from the first line of the KLC file (KBD<TAB><name><TAB>"<title>")
Local $klc_file = FileOpen($klc_to_compile, 0)
If $klc_file = -1 Then Exit $EXIT_KLC_OPEN_ERROR
Local $first_line = FileReadLine($klc_file)
FileClose($klc_file)
Local $parts = StringSplit($first_line, @TAB)
If $parts[0] < 3 Then Exit $EXIT_KLC_FORMAT_ERROR
Local $kbd_name = $parts[2]

; MSKLC outputs to @MyDocumentsDir\<kbd_name> — ensure it does not already exist
Local $msklc_output = @MyDocumentsDir & "\" & $kbd_name
If FileExists($msklc_output) Then Exit $EXIT_OUTPUT_EXISTS

; Destination in the workspace must also not already exist
Local $workspace_dest = $workspace & "\" & $output_name
If FileExists($workspace_dest) Then Exit $EXIT_DEST_EXISTS

Local $msklc_pid = RunFromLocalFolder($exe_location)
OnAutoItExitRegister("Cleanup")

Func Cleanup()
    ProcessClose($msklc_pid)
    DirRemove($msklc_output, 1)
EndFunc

; Wait for the main program window to show up
Local $main_wnd = WinWaitActive("Keyboard Layout Creator 1.4", "", $TIMEOUT)
If $main_wnd = 0 Then Exit $EXIT_TIMEOUT_MAIN_WND
Sleep($POST_ACTIVE_WAIT_MS)

; Wait for open dialog to appear
ControlSend($main_wnd, "", "", "^o")
If WinWaitNotActive($main_wnd, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_OPEN_INACTIVE
If WinWaitActive($dialog_id, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_OPEN_DIALOG
Sleep($POST_ACTIVE_WAIT_MS)

; Actually open the klc file
ControlSetText($dialog_id, "", "[CLASS:Edit; INSTANCE:1]", $klc_to_compile)
ControlSend($dialog_id, "", "", "{ENTER}")
If WinWaitActive($main_wnd, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_MAIN_AFTER_OPEN
Sleep($POST_ACTIVE_WAIT_MS)

; Build and wait for next dialog about 
ControlSend($main_wnd, "", "", "!p")
ControlSend($main_wnd, "", "", "b")
If WinWaitNotActive($main_wnd, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_VERIFY_INACTIVE
If WinWaitActive($dialog_id, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_VERIFY_DIALOG
Sleep($POST_ACTIVE_WAIT_MS)

Local $dialog_text = WinGetText($dialog_id)
If Not StringInStr($dialog_text, "Verification succeeded") Then Exit $EXIT_VERIFICATION_FAILED
If StringInStr($dialog_text, "warning") Then
    ControlClick($dialog_id, "", "[CLASS:Button; INSTANCE:2]")
Else
    ControlClick($dialog_id, "", "[CLASS:Button; INSTANCE:1]")
EndIf
If WinWaitActive($main_wnd, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_MAIN_AFTER_VERIFY
Sleep($POST_ACTIVE_WAIT_MS)

If WinWaitNotActive($main_wnd, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_BUILD_INACTIVE
If WinWaitActive($dialog_id, "", $TIMEOUT) = 0 Then Exit $EXIT_TIMEOUT_BUILD_DIALOG
Sleep($POST_ACTIVE_WAIT_MS)

If Not StringInStr(WinGetText($dialog_id), "The Windows Installer package was built successfully at") Then Exit $EXIT_BUILD_FAILED
ControlSend($dialog_id, "", "", "n")

; Move the build output folder from Documents to the workspace
Sleep(1000)
If Not DirMove($msklc_output, $workspace_dest) Then Exit $EXIT_MOVE_FAILED
