[reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null
[reflection.assembly]::LoadWithPartialName("System.Windows.forms") | Out-Null
[System.Windows.forms.Application]::EnableVisualStyles()
function Button_OnClick() {

  "`$combo.SelectedItem = $($combo.SelectedItem)"
## Set menu arguments here
  if ($combo.SelectedItem -eq 'Full Screen All Monitors') {
    Start-Process -FilePath 'C:\DST\WFH\Client\bin\pcoip_client.exe' -ArgumentList '--fullscreen'
  } elseif ($combo.SelectedItem -eq 'Default') {
    Start-Process -FilePath 'C:\DST\WFH\Client\bin\pcoip_client.exe'
  }

}

$combo                    = New-Object system.Windows.forms.ComboBox
$combo.Location           = New-Object System.Drawing.Point(12,153)
$combo.Font               = New-Object System.Drawing.Font("Calibri",11)
$combo.Width              = 300
$combo.Height             = 47

## Add new menu items here
$combo.Items.Add('Default') | Out-Null
$combo.Items.Add('Full Screen All Monitors') | Out-Null
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
$pictureBox.ImageLocation = "C:\DST\WFH\DST_LOGO.png"
$pictureBox.BackColor     = "Black"
$pictureBox.SizeMode      = [System.Windows.forms.PictureBoxSizeMode]::Zoom

$label                    = New-Object System.Windows.Forms.Label
$label.Location           = New-Object System.Drawing.Point(12,135)
$label.Size               = New-Object System.Drawing.Size(280,20)
$label.Font               = New-Object System.Drawing.Font("Calibri",11)
$label.Text               = 'Please Select Session Options:'
$form.Controls.Add($label)

$button.Add_Click({ Button_OnClick ; $form.Close()})

$form                     = New-Object system.Windows.forms.form
$form.ClientSize          = New-Object System.Drawing.Point(640,190)
$form.Icon                = [System.Drawing.Icon]::ExtractAssociatedIcon('C:\DST\WFH\distilleryvfx.ico')
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