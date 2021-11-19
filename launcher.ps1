[reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null
[reflection.assembly]::LoadWithPartialName("System.Windows.forms") | Out-Null
[System.Windows.forms.Application]::EnableVisualStyles()

$Version = '21.07.5'
$Workdir = 'C:\DST\WFH\'
$Imagedir = "$Workdir\Images\"
$Installer = "$Workdir\pcoip-client_$Version.exe"
$Clientbin = 'C:\DST\WFH\Client\bin\pcoip_client.exe'
$Opts = '--disable-usb --use-single-logfile --quit-after-disconnect --force-native-resolution -b pcoip.distilleryvfx.com'
Write-Host " "
Write-Host "Bootstrapping..."
Write-Host " "

if ( -not ( Test-Path -Path "$Workdir" ) )
{
    New-Item -ItemType Directory -Force -Path "$Workdir" | Out-Null
}
if ( -not ( Test-Path -Path "$Imagedir" ) )
{
    New-Item -ItemType Directory -Force -Path "$Imagedir" | Out-Null
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/anthonymoon/wfh/master/Images/DST_LOGO.png -OutFile $Imagedir/DST_LOGO.png
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/anthonymoon/wfh/master/Images/distilleryvfx.ico -OutFile $Imagedir/distilleryvfx.ico
}
if ( -not ( Test-Path -Path "$Installer" ) )
{
    Invoke-WebRequest -Uri https://dl.teradici.com/JpftnIRNhRANkfjd/pcoip-client/raw/names/pcoip-client-exe/versions/$Version/pcoip-client_$Version.exe -OutFile $Installer
}
if ( -not ( Test-Path -Path "$Clientbin" ) )
{
    Start-Process -FilePath "$Installer" -ArgumentList "/S /force /D=C:\DST\WFH\Client\" -Verb RunAs -Wait | Out-Null
}
if ( -not ( Get-NetFirewallRule -DisplayName "*PCoIP*" ) )
{
    New-NetFirewallRule -DisplayName "Allow PCoIP Client Outbound" -Direction Outbound -Program "$Clientbin" -RemoteAddress Any -Action Allow | Out-Null
    New-NetFirewallRule -DisplayName "Allow PCoIP Client Inbound" -Direction Inbound -Program "$Clientbin" -RemoteAddress Any -Action Allow | Out-Null
}

Write-Host " "
Write-Host "Starting..."
Write-Host " "

function Button_OnClick() {

  "`$combo.SelectedItem = $($combo.SelectedItem)"
## Set menu arguments here
  if ($combo.SelectedItem -eq 'Window Mode') {
    Start-Process -FilePath "$Clientbin" -ArgumentList '--disable-usb --use-single-logfile --quit-after-disconnect --force-native-resolution -b pcoip.distilleryvfx.com'
  } elseif ($combo.SelectedItem -eq 'Window Mode - Wacom Pressure Sensitivity') {
    Start-Process -FilePath "$Clientbin" -ArgumentList '--disable-usb --use-single-logfile --quit-after-disconnect --force-native-resolution -b pcoip.distilleryvfx.com --vidpid-auto-forward "056a,0357"'
  }
  elseif ($combo.SelectedItem -eq 'Full Screen') {
    Start-Process -FilePath "$Clientbin" -ArgumentList '--disable-usb --use-single-logfile --quit-after-disconnect --force-native-resolution -b pcoip.distilleryvfx.com -f'
  }
  elseif ($combo.SelectedItem -eq 'Full Screen - Wacom Pressure Sensitivity') {
    Start-Process -FilePath "$Clientbin" -ArgumentList '--disable-usb --use-single-logfile --quit-after-disconnect --force-native-resolution -b pcoip.distilleryvfx.com -f --vidpid-auto-forward "056a,0357"'
  }
}

$combo                    = New-Object system.Windows.forms.ComboBox
$combo.Location           = New-Object System.Drawing.Point(12,153)
$combo.Font               = New-Object System.Drawing.Font("Calibri",11)
$combo.Width              = 450
$combo.Height             = 47

## Add new menu items here
$combo.Items.Add('Window Mode') | Out-Null
$combo.Items.Add('Window Mode - Wacom Pressure Sensitivity') | Out-Null
$combo.Items.Add('Full Screen') | Out-Null
$combo.Items.Add('Full Screen - Wacom Pressure Sensitivity') | Out-Null
$combo.SelectedIndex      = 0

$button                   = New-Object -TypeName System.Windows.forms.Button
$button.location          = New-Object System.Drawing.Point(470,149)
$button.Font              = New-Object System.Drawing.Font("Calibri",11,[System.drawing.FontStyle]::Bold)
$button.Text              = 'Launch PCoIP Client'
$button.width             = 149
$button.height            = 30

$pictureBox               = New-Object system.Windows.forms.PictureBox
$pictureBox.Location      = New-Object System.Drawing.Point(22,19)
$pictureBox.Width         = 600
$pictureBox.Height        = 100
$pictureBox.ImageLocation = "$Imagedir/DST_LOGO.png"
$pictureBox.BackColor     = "Black"
$pictureBox.SizeMode      = [System.Windows.forms.PictureBoxSizeMode]::Zoom

$label                    = New-Object System.Windows.Forms.Label
$label.Location           = New-Object System.Drawing.Point(12,135)
$label.Size               = New-Object System.Drawing.Size(280,20)
$label.Font               = New-Object System.Drawing.Font("Calibri",11)
$label.Text               = 'Please Select Session Options:'

$button.Add_Click({ Button_OnClick ; $form.Close()})

$form                     = New-Object system.Windows.forms.form
$form.ClientSize          = New-Object System.Drawing.Point(640,190)
$form.Icon                = [System.Drawing.Icon]::ExtractAssociatedIcon("$Imagedir\distilleryvfx.ico")
$form.Text                = "Distillery VFX WFH Launcher"
$form.formBorderStyle     = 'Fixed3D'
$form.MaximizeBox         = $false
$form.TopMost             = $true
$form.StartPosition       = [System.Windows.forms.formStartPosition]::CenterScreen

$form.Controls.Add($combo)
$form.Controls.Add($button)
$form.Controls.Add($pictureBox)
$form.Controls.Add($label)

$form.ShowDialog() | Out-Null