#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <Debug.au3>

_DebugSetup("is_uefi", False) ; start displaying debug environment

$systemdrive = EnvGet('systemdrive')
DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
$aArray = StringSplit(_getDOSOutput("bcdedit.exe"), @CRLF)
DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 0)
For $i = 1 To UBound($aArray) - 1
	Select
		Case StringInStr($aArray[$i], 'device partition=' & $systemdrive) And StringInStr($aArray[$i + 1], 'winload.efi')
;~ 			ConsoleWrite("UEFI mode" & @CRLF)
			MsgBox(0, "Info...", "UEFI Mode")
		Case StringInStr($aArray[$i], 'device partition=' & $systemdrive) And StringInStr($aArray[$i + 1], 'winload.exe')
;~ 			ConsoleWrite("Legacy BIOS" & @CRLF)
			MsgBox(0, "Info...", "Legacy Mode")
	EndSelect
Next

Func _getDOSOutput($command, $wd = '') ; https://www.autoitscript.com/forum/topic/190249-get-result-of-shellexecute/
	Local $text = '', $Pid = Run('"' & @ComSpec & '" /c ' & $command, $wd, @SW_HIDE, 2 + 4)
	While 1
		$text &= StdoutRead($Pid, False, False)
		If @error Then ExitLoop
		Sleep(10)
	WEnd
	Return StringStripWS($text, 7)
EndFunc   ;==>_getDOSOutput
