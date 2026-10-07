# Ghidra headless runner for the NR2003 project (read-only, no analysis) with the Jython scripts of this folder.
# Example:
#   powershell -ExecutionPolicy Bypass -File recovery\ghidra_tools\run_headless.ps1 `
#     -Ghidra C:\tools\ghidra_11.1.2_PUBLIC -Project C:\nr\proj -JavaHome "C:\Program Files\Java\jdk-26.0.2" `
#     -postScript ExportMemoryPy.py C:\nr\mem `
#     -postScript ExportSetPy.py C:\nr\evidence C:\nr\funcs.txt 1
# -Project = folder holding OpenNR2003.gpr + OpenNR2003.rep (copy it to a SHORT path first: Ghidra/Java and the
# Windows 260-character limit do not mix well with the deep scratch folders).
param(
    [Parameter(Mandatory = $true)][string]$Ghidra,
    [Parameter(Mandatory = $true)][string]$Project,
    [string]$JavaHome = $env:JAVA_HOME,
    [string]$ProjectName = "OpenNR2003",
    [string]$Program = "NR2003.exe",
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$Rest
)
if ($JavaHome) { $env:JAVA_HOME = $JavaHome }
# the project files belong to user 'TChapman500'; Ghidra refuses to open them for anyone else
$env:JAVA_TOOL_OPTIONS = "-Duser.name=TChapman500"
$scripts = $PSScriptRoot
& (Join-Path $Ghidra "support\analyzeHeadless.bat") $Project $ProjectName -process $Program -readOnly -noanalysis -scriptPath $scripts @Rest
