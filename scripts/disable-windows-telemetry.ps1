Clear-Host

# ------------------------------------------------------------
# Disable Telemetry Services
# ------------------------------------------------------------

Write-Host "Disable Telemetry Services:" -ForegroundColor Cyan

$Services = @(
  "DiagTrack",        # Connected User Experiences & Telemetry
  "dmwappushservice"  # Device Management WAP Push
)

foreach ($Service in $Services) {
  if (Get-Service -Name $Service -ErrorAction SilentlyContinue) {
    Write-Host   "> $Service"
    Stop-Service $Service -Force
    Set-Service  $Service -StartupType Disabled
  }
}

# ------------------------------------------------------------

Write-Host ""

# ------------------------------------------------------------
# Disable Telemetry in Registry
# ------------------------------------------------------------

Write-Host "Disable Telemetry in Registry:" -ForegroundColor Cyan

$RegistryChanges = @(
  @{
    Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    Name  = "AllowTelemetry"
    Value = 0
    Type  = "DWord"
  }
)

foreach ($Reg in $RegistryChanges) {
  $Path  = $Reg.Path
  $Name  = $Reg.Name
  $Value = $Reg.Value
  $Type  = $Reg.Type

  Write-Host "> Set $Path\$Name to $Value"
  New-Item         -Path $Path -Force | Out-Null
  Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type
}

# ------------------------------------------------------------

Write-Host ""

# ------------------------------------------------------------
# Disable Telemetry in Scheduled Tasks
# ------------------------------------------------------------

Write-Host "Disable Telemetry Scheduled Tasks:" -ForegroundColor Cyan

$Tasks = @(
  @{ TaskPath = "\Microsoft\Windows\Application Experience\"; TaskName = "Microsoft Compatibility Appraiser" },
  @{ TaskPath = "\Microsoft\Windows\Application Experience\"; TaskName = "ProgramDataUpdater" },

  @{ TaskPath = "\Microsoft\Windows\Customer Experience Improvement Program\"; TaskName = "Consolidator" },
  @{ TaskPath = "\Microsoft\Windows\Customer Experience Improvement Program\"; TaskName = "UsbCeip" }
)

foreach ($Task in $Tasks) {
  $TaskPath = $Task.TaskPath
  $TaskName = $Task.TaskName

  if (Get-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -ErrorAction SilentlyContinue) {
    Disable-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName
  }
}

# ------------------------------------------------------------

Write-Host ""
