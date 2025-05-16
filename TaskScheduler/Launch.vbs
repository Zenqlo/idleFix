' Author: Zenqlo
' Version: v0.0.3
' Date: 2025-05-16
' Description: This script launches the Fix.ps1 PowerShell script.

psScript = "Fix.ps1"

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
scriptdir = fso.GetParentFolderName(WScript.ScriptFullName)
psScript = fso.BuildPath(scriptdir, psScript)
WshShell.Run "powershell -ExecutionPolicy Bypass -File """ & psScript & """", 0, False 
