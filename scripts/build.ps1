<#
    scripts/build.ps1 - Generate a Watch Face Studio .wfs file
    Compresses ../src into a zip, appends the validation tail,
    and outputs all generated files into ../build.
#>

# -------------------------------
# Configuration variables
# -------------------------------
$ProjectName = "DuelingBatteries"                          # Name of your watch face project
$SrcDir      = Join-Path $PSScriptRoot "..\src"             # Source folder containing project files
$BuildDir    = Join-Path $PSScriptRoot "..\build"           # Where generated files should be stored
$ZipFile     = Join-Path $BuildDir "$ProjectName.zip"       # Intermediate zip file
$WfsFile     = Join-Path $BuildDir "$ProjectName.wfs"       # Final output file to open in Watch Face Studio
$TailFile    = Join-Path $BuildDir "validation-tail.bin"    # Validation file required in .wfs file by Watch Face Studio

# -------------------------------
# Step 0: Clean build directory
# -------------------------------
if (Test-Path $BuildDir) {
    Remove-Item $BuildDir -Recurse -Force
}
New-Item -ItemType Directory -Path $BuildDir | Out-Null

# -------------------------------
# Step 1: Compress source files into zip archive
# Important: use src\* so that contents are at the root of the zip,
# not nested under "src\".
# -------------------------------
Compress-Archive -Path "$SrcDir\*" -DestinationPath $ZipFile -Force

# -------------------------------
# Step 2: Generate the validation tail dynamically
# Convert the ASCII string "normal_watchface" into raw bytes
# and write them directly to a tail file.
# -------------------------------
$bytes = [System.Text.Encoding]::ASCII.GetBytes("normal_watchface")
[System.IO.File]::WriteAllBytes($TailFile, $bytes)

# -------------------------------
# Step 3: Concatenate the zip + tail into the final .wfs
# Using cmd /c copy /b for binary concatenation
# -------------------------------
cmd /c copy /b $ZipFile + $TailFile "$WfsFile"

Write-Host "Built `"$WfsFile`" successfully."