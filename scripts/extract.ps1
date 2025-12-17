<#
    scripts/extract.ps1 - Reverse process for Watch Face Studio .wfs files
    Strips the validation tail from ../build/Dueling Batteries.wfs
    and extracts contents into ../src.
#>

$ProjectName = "DuelingBatteries"                        # Name of your watch face project
$SrcDir      = Join-Path $PSScriptRoot "..\src"          # Destination folder for extracted files
$BuildDir    = Join-Path $PSScriptRoot "..\build"        # Folder containing intermediate files
$WfsFile     = Join-Path $BuildDir "$ProjectName.wfs"    # Input .wfs file as modified by Watch Face Studio
$ZipFile     = Join-Path $BuildDir "$ProjectName.zip"    # Temporary zip file without tail

# -------------------------------
# Step 0: Verify .wfs file exists
# -------------------------------
if (-Not (Test-Path $WfsFile)) {
    Write-Error "Could not find $WfsFile. Did you run build.ps1 first?"
    exit 1
}


# -------------------------------
# Step 1: Strip the 16-byte validation tail
# Read the .wfs file, trim off the last 16 bytes, and write a valid zip.
# -------------------------------
$bytes = [System.IO.File]::ReadAllBytes($WfsFile)
$trimmed = $bytes[0..($bytes.Length - 17)]
[System.IO.File]::WriteAllBytes($ZipFile, $trimmed)

# -------------------------------
# Step 2: Extract the zip contents into src\
# -------------------------------
if (Test-Path $SrcDir) { Remove-Item $SrcDir -Recurse -Force }
Expand-Archive -Path $ZipFile -DestinationPath $SrcDir -Force

Write-Host "Extracted `"$WfsFile`" into $SrcDir successfully."