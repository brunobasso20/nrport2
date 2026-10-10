# Stage 12 automatic tests on Windows (PowerShell 5.1+). Builds the Stage 12 deliverables and runs the Stage 6/7, 8, 9,
# 10 and 11 suites (regression, Stage 12 steering in "provisional" mode = the Stage 6-11 steering contract), the Stage 12
# suite (original steering chain vs the ORIGINAL code: functions, frame-start snapshots, full-state restarts, closed-loop
# runs, deliberate mapping errors, behaviour), the adapter mock, the six patch mocks, then a syntax compile.
# Usage: powershell -ExecutionPolicy Bypass -File tools\run_stage12_tests.ps1 -Luau C:\path\luau.exe [-Python py]
param([string]$Luau = "luau", [string]$Python = "python")
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
$compile = "luau-compile"
$luauDir = Split-Path $Luau -Parent
if ($luauDir -and (Test-Path (Join-Path $luauDir "luau-compile.exe"))) { $compile = Join-Path $luauDir "luau-compile.exe" }
function Run($exe, [string[]]$argv) { & $exe @argv; if ($LASTEXITCODE -ne 0) { throw "FAILED: $exe $argv" } }
Run $Python @("tools/build_stage12.py")
Run $Python @("tools/make_patch12_mock.py")
Run $Python @("tools/make_adapter_mock.py")
Run $Luau @("-O2", "--codegen", "tests/stage67/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage8/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage9/run.luau")
Run $Luau @("-O2", "tests/stage10/run_setup.luau")
Run $Luau @("-O2", "--codegen", "tests/stage10/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage11/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage12/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage67/adapter_mock.luau")
Run $Luau @("-O2", "tests/stage67/patch_mock.luau")
Run $Luau @("-O2", "tests/stage8/patch8_mock.luau")
Run $Luau @("-O2", "tests/stage9/patch9_mock.luau")
Run $Luau @("-O2", "tests/stage10/patch10_mock.luau")
Run $Luau @("-O2", "--codegen", "tests/stage11/patch11_mock.luau")
Run $Luau @("-O2", "--codegen", "tests/stage12/patch12_mock.luau")
$files = @(Get-ChildItem core\*.lua, core\NR2003Cup\*.lua, roblox\*.lua) + @(Get-Item PATCH_STAGE12*.lua)
foreach ($f in $files) { & $compile --null $f.FullName | Out-Null; if ($LASTEXITCODE -ne 0) { throw "SYNTAX FAIL $($f.Name)" } }
"syntax OK"
