# Stage 9 automatic tests on Windows (PowerShell 5.1+). Runs the Stage 6/7 and Stage 8 suites unchanged
# (regression), the Stage 9 suite, the adapter mock and the three patch mocks, then a syntax compile.
# Usage: powershell -ExecutionPolicy Bypass -File tools\run_stage9_tests.ps1 -Luau C:\path\luau.exe [-Python py]
param([string]$Luau = "luau", [string]$Python = "python")
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
$compile = "luau-compile"
$luauDir = Split-Path $Luau -Parent
if ($luauDir -and (Test-Path (Join-Path $luauDir "luau-compile.exe"))) { $compile = Join-Path $luauDir "luau-compile.exe" }
function Run($exe, [string[]]$argv) { & $exe @argv; if ($LASTEXITCODE -ne 0) { throw "FAILED: $exe $argv" } }
Run $Python @("tools/build_stage9.py")
Run $Python @("tools/make_adapter_mock.py")
Run $Python @("tools/make_patch9_mock.py")
Run $Luau @("-O2", "--codegen", "tests/stage67/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage8/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage9/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage67/adapter_mock.luau")
Run $Luau @("-O2", "tests/stage67/patch_mock.luau")
Run $Luau @("-O2", "tests/stage8/patch8_mock.luau")
Run $Luau @("-O2", "tests/stage9/patch9_mock.luau")
$files = @(Get-ChildItem core\*.lua, core\NR2003Cup\*.lua, roblox\*.lua) + @(Get-Item PATCH_STAGE9.lua)
foreach ($f in $files) { & $compile --null $f.FullName | Out-Null; if ($LASTEXITCODE -ne 0) { throw "SYNTAX FAIL $($f.Name)" } }
"syntax OK"
