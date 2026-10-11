# Stage 11 automatic tests on Windows (PowerShell 5.1+). Builds the Stage 11 deliverables and runs the Stage 6/7, 8, 9
# and 10 suites (regression, Stage 11 runtime in "frozen" mode), the Stage 11 suite (original runtime vs the ORIGINAL code:
# session start, synchronized frame/event snapshots, full-state restarts, closed-loop runs, determinism), the adapter mock,
# the five patch mocks, then a syntax compile.
# Usage: powershell -ExecutionPolicy Bypass -File tools\run_stage11_tests.ps1 -Luau C:\path\luau.exe [-Python py]
param([string]$Luau = "luau", [string]$Python = "python")
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
$compile = "luau-compile"
$luauDir = Split-Path $Luau -Parent
if ($luauDir -and (Test-Path (Join-Path $luauDir "luau-compile.exe"))) { $compile = Join-Path $luauDir "luau-compile.exe" }
function Run($exe, [string[]]$argv) { & $exe @argv; if ($LASTEXITCODE -ne 0) { throw "FAILED: $exe $argv" } }
Run $Python @("tools/build_stage11.py")
Run $Python @("tools/make_patch11_mock.py")
Run $Luau @("-O2", "--codegen", "tests/stage67/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage8/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage9/run.luau")
Run $Luau @("-O2", "tests/stage10/run_setup.luau")
Run $Luau @("-O2", "--codegen", "tests/stage10/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage11/run.luau")
Run $Luau @("-O2", "--codegen", "tests/stage67/adapter_mock.luau")
Run $Luau @("-O2", "tests/stage67/patch_mock.luau")
Run $Luau @("-O2", "tests/stage8/patch8_mock.luau")
Run $Luau @("-O2", "tests/stage9/patch9_mock.luau")
Run $Luau @("-O2", "tests/stage10/patch10_mock.luau")
Run $Luau @("-O2", "--codegen", "tests/stage11/patch11_mock.luau")
$files = @(Get-ChildItem core\*.lua, core\NR2003Cup\*.lua, roblox\*.lua) + @(Get-Item PATCH_STAGE11*.lua)
foreach ($f in $files) { & $compile --null $f.FullName | Out-Null; if ($LASTEXITCODE -ne 0) { throw "SYNTAX FAIL $($f.Name)" } }
"syntax OK"
