#include-once

Func ExitIfError($msg, $code = 1)
    If @error Then
        ConsoleWriteError($msg & @CRLF)
        Exit $code
    EndIf
EndFunc

Func RunFromLocalFolder($location, $code = 1)
    Local $last_separator = StringInStr($exe_location, "\", 0, -1)
    ExitIfError("Invalid arguments given to StringInStr for parsing exe location.")
    If $last_separator = 0 Then Exit $code
    Local $exe_wd = StringLeft($exe_location, $last_separator - 1)
    Local $pid = Run($location, $exe_wd)
    If $pid = 0 Then Exit $code
    return $pid
EndFunc