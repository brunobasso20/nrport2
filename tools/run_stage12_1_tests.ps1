# Stage 12.1 automatic tests on Windows (PowerShell 5.1+). Rebuilds the FROZEN Stage 12 deliverables (byte-identical to
# the published ones) and the Stage 12.1 deliverables, runs the Stage 6/7, 8, 9, 10 and 11 suites (regression), the
# Stage 12 suite (original steering chain vs the ORIGINAL code + the 12.1 host options), the adapter mock, the seven
# patch mocks (6/7 .. 12, then 12 -> 12.1), then a syntax compile.
# Usage: powershell -ExecutionPolicy Bypass -File tools\run_stage12_1_tests.ps1 -Luau C:\path\luau.exe [-Python py]
param([string]$Luau = "luau", [string]$Python = "python")
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
$compile = "luau-compile"
$luauDir = Split-Path $Luau -Parent
if ($luauDir -and (Test-Path (Join-Path $luauDir "luau-compile.exe"))) { $compile = Join-Path $luauDir "luau-compile.exe" }
function Run($exe, [string[]]$argv) { & $exe @argv; if ($LASTEXITCODE -ne 0) { throw "FAILED: $exe $argv" } }
Run $Python @("tools/build_stage12.py")
Run "git" @("diff", "--quiet", "--", "PATCH_STAGE12.lua", "PATCH_STAGE12_INSTALL.lua", "PATCH_STAGE12_ROLLBACK.lua", "PATCH_STAGE12_PART1.lua", "PATCH_STAGE12_PART2.lua", "NR2003_Patch_Stage12.rbxmx")
Run $Python @("tools/build_stage12_1.py")
Run $Python @("tools/make_patch12_mock.py")
Run $Python @("tools/make_patch12_1_mock.py")
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
Run $Luau @("-O2", "--codegen", "tests/stage12/patch12_1_mock.luau")
$files = @(Get-ChildItem core\*.lua, core\NR2003Cup\*.lua, roblox\*.lua) + @(Get-Item PATCH_STAGE12*.lua)
foreach ($f in $files) { & $compile --null $f.FullName | Out-Null; if ($LASTEXITCODE -ne 0) { throw "SYNTAX FAIL $($f.Name)" } }
"syntax OK"
