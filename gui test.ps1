[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()

# hide console window
# Add-Type -Name Window -Namespace Console -MemberDefinition '
# [DllImport("Kernel32.dll")]
# public static extern IntPtr GetConsoleWindow();

# [DllImport("user32.dll")]
# public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'

# [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)

# Wait-Debugger

Add-Type -AssemblyName PresentationCore, PresentationFramework

# grab the gui code from the xaml file
[xml]$XAML = Get-Content "$PSScriptRoot\window.xaml"

# parse it a do xaml shit idk
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# parse the xml for Name=, then set a variable to that name with the value of the gui item
# lets us do $name. to interact with the gui items
$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $window.FindName($_.Name) }

# $xaml.SelectNodes("//*[@Name]") | ForEach-Object { Write-Host $_.Name }



# FileMenu
# FileMenuOpenData
# FileMenuNewDataPath
# EditMenu
# ViewMenu
# ViewMenuHistory
# ViewMenuConsole
# PromptOutputTxtBox
# GeneratePromptBtn
# RefreshDataBtn
# RebuildBtn
# AutoCopyChkBox
# PromptNumSldr
# PromtNumTxtBox
# GenTypeApi
# GenTypePositive
# SetSeedTxtBox
# LastSeedTxtBox
# CopyToClipboardBtn
# TagNameLstBox0
# TagCountLstBox0
# TagNameLstBox1
# TagCountLstBox1
# TagNameLstBox2
# TagCountLstBox2

$functionPath = "C:\Users\sbker\OneDrive\Desktop\GenGui-Reloaded\Reloaded GenGui\GenGui-Reloaded\completed sections"
$functions = Get-ChildItem -Path $functionPath
foreach ($function in $functions) {
    . $function.FullName
}

$Path = "C:\Users\sbker\OneDrive\Desktop\GenGui-Reloaded\Classic GenGui\Prompt Collections\"

$MasterGen = New-DataBlock $Path

Get-AllData $MasterGen

$blocks = $MasterGen.Blocks
$groups = $MasterGen.Blocks.Keys

# Wait-Debugger
$i0 = 0; $i1 = 0; $i2 = 0;
foreach ($flag in $MasterGen.FlagCounts.Keys) {
    
    foreach ($groupName in $groups) {

        if ($blocks.$groupName.BlockFlag -ne $flag) {
            
            continue

        }else{

            if ($TagNameLstBox0.Items.Count -lt 15) {

                $TagNameLabel = [System.Windows.Controls.TextBlock]::new()
                $TagNameLabel.Height = 18
                $TagNameLabel.Text = $blocks.$groupName.BlockName

                $TagNameLstBox0.Items.Add($TagNameLabel)
                $TagNameLabel = $null

                $TagCountBox = [System.Windows.Controls.TextBox]::new()
                $TagCountBox.Tag = $groupName
                $TagCountBox.Name = "$($groupName)BoxCount"
                $TagCountBox.Text = "0"
                $TagCountBox.Height = 18
                $TagCountBox.Width = 30
                $TagCountBox.AutoWordSelection = $true

                $TagCountLstBox0.Items.Add($TagCountBox)
                $TagCountBox = $null

                $i0++

            }elseif ($TagNameLstBox1.Items.Count -lt 15) {

                $TagNameLabel = [System.Windows.Controls.TextBlock]::new()
                $TagNameLabel.Height = 18
                $TagNameLabel.Text = $blocks.$groupName.BlockName

                $TagNameLstBox1.Items.Add($TagNameLabel)
                $TagNameLabel = $null

                $TagCountBox = [System.Windows.Controls.TextBox]::new()
                $TagCountBox.Tag = $groupName
                $TagCountBox.Name = "$($groupName)BoxCount"
                $TagCountBox.Text = "0"
                $TagCountBox.Height = 18
                $TagCountBox.Width = 30

                $TagCountLstBox1.Items.Add($TagCountBox)
                $TagCountBox = $null

                $i1++

            }else {

                $TagNameLabel = [System.Windows.Controls.TextBlock]::new()
                $TagNameLabel.Height = 18
                $TagNameLabel.Text = $blocks.$groupName.BlockName

                $TagNameLstBox2.Items.Add($TagNameLabel)
                $TagNameLabel = $null

                $TagCountBox = [System.Windows.Controls.TextBox]::new()
                $TagCountBox.Tag = $groupName
                $TagCountBox.Name = "$($groupName)BoxCount"
                $TagCountBox.Text = "0"
                $TagCountBox.Height = 18
                $TagCountBox.Width = 30

                $TagCountLstBox2.Items.Add($TagCountBox)
                $TagCountBox = $null

                $i2++

            }
        }
    }
}




















[void]$window.ShowDialog()
Remove-Variable -Name window