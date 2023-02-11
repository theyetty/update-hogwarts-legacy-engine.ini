$configFile = "$env:LOCALAPPDATA\Hogwarts Legacy\Saved\Config\WindowsNoEditor\Engine.ini"

# These are a list of variables it will check exist in the file
$expectedVariables = @(
    "r.TextureStreaming=1",
    "PoolSizeVRAMPercentage=100",
    "r.Streaming.LimitPoolSizeToVRAM=1",
    "r.bForceCPUAccessToGPUSkinVerts=True",
    "r.GTSyncType=1",
    "r.OneFrameThreadLag=1",
    "r.FinishCurrentFrame=0"
)

if (!(Test-Path $configFile)) {
    throw "Error: The file $configFile does not exist."
}

# Get the users VRAM avaliable in kilobytes
$vram = (Get-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*" -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue)."HardwareInformation.qwMemorySize"

# Calculate  the amount of VRAM they can use
$poolSize = [math]::Round($vram / 1MB / 2)

# Check if $poolSize is less than 0 or not defined, just incase the above returns null
if ($poolSize -lt 0 -or !$poolSize) {
    $poolSize = 2048
}

# Add the value for r.Streaming.PoolSize to the expectedVariables list
$expectedVariables += "r.Streaming.PoolSize=$poolSize"

# Read the contents of the file into an array of lines
$lines = Get-Content $configFile

# Find the [SystemSettings] section and check if the expected variables exist
$systemSettingsIndex = $lines.IndexOf("[SystemSettings]")
$existingVariables = @{}
if ($systemSettingsIndex -ge 0) {
    $sectionEndIndex = $lines.Count
    for ($i = $systemSettingsIndex + 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        if ($line.StartsWith("[")) {
            $sectionEndIndex = $i
            break
        }
        elseif ($line -notmatch "^\s*;.*" -and $line -match "^(.*)=(.*)$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            $existingVariables[$key] = $i
        }
    }
}

# Add the [SystemSettings] section if it doesn't exist
if ($systemSettingsIndex -lt 0) {
    $lines += ""
    $lines += "[SystemSettings]"
    $systemSettingsIndex = $lines.Count - 1
    $sectionEndIndex = $lines.Count
}

# Remove any existing variables and add the expected variables to the end of the [SystemSettings] section
foreach ($var in $expectedVariables) {
    $varKey = $var.Split("=")[0]
    $varValue = $var.Split("=")[1]
    if ($existingVariables.ContainsKey($varKey)) {
        $lines[$existingVariables[$varKey]] = "$varKey=$varValue"
    } else {
        $lines = $lines + "$varKey=$varValue"
    }
}

# Write the updated lines back to the file
Set-Content $configFile -Value $lines

Write-Output "Succesfully updated the file $configFile"
