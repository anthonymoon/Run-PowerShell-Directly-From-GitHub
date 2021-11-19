# Demo of PowerShell download and run directly from GitHub
# Note, from a security point of view this is a really bad idea, you shouldn't run code
# before reviewing it carefully and understanding it, and anyone who has access to the 
# GitHub repo could  change the code at any time 
# (which is a benefit for updating, but a risk for running it)

# Anyway, don't do it. This is just a proof of concept :-)

# Tom Arbuthnot tontalks.uk

# You can run this script directly from GitHub with these two commands:

# $ScriptFromGithHub = Invoke-WebRequest https://raw.githubusercontent.com/tomarbuthnot/Run-PowerShell-Directly-From-GitHub/master/Run-FromGitHub-SamplePowerShell.ps1
# Invoke-Expression $($ScriptFromGithHub.Content)

$Version = "21.07.5"
$Workdir = "C:\DST\WFH\"
$Installer = "$Workdir\pcoip-client_$Version.exe"
$Clientbin = "C:\DST\WFH\Client\bin\pcoip_client.exe"
Write-Host " "
Write-Host "Bootstraping..."
Write-Host " "

if ( -not ( Test-Path -Path $Workdir ) )
{
    New-Item -ItemType Directory -Force -Path "$Workdir"
}
if ( -not ( Test-Path -Path $Installer ) )
{
    Invoke-WebRequest -Uri https://dl.teradici.com/JpftnIRNhRANkfjd/pcoip-client/raw/names/pcoip-client-exe/versions/$Version/pcoip-client_$Version.exe -OutFile $Installer
}
if ( -not ( Test-Path -Path $Clientbin ) )
{
    Start-Process -FilePath "$Installer" -ArgumentList "/S /force" -Verb RunAs
}
if ( -not ( Get-NetFirewallRule -DisplayName "Allow PCoIP Client Outbound" ) )
{
    New-NetFirewallRule -DisplayName "Allow PCoIP Client Outbound" -Direction Outbound -Program "$Clientbin" -RemoteAddress Any -Action Allow
    New-NetFirewallRule -DisplayName "Allow PCoIP Client Inbound" -Direction Inbound -Program "$Clientbin" -RemoteAddress Any -Action Allow
}

# $ScriptFromGithHub = Invoke-WebRequest https://raw.githubusercontent.com/tomarbuthnot/Run-PowerShell-Directly-From-GitHub/master/Run-FromGitHub-SamplePowerShell.ps1
# Invoke-Expression $($ScriptFromGithHub.Content)
