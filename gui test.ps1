using namespace System.Windows.Controls
using namespace System.Windows.Shapes
using namespace System.Windows.Media

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
# PromptNumTxtBox
# GenTypeApi
# GenTypePositive
# SetSeedTxtBox
# LastSeedTxtBox
# CopyToClipboardBtn
# TagLstBox0
# TagLstBox1
# TagLstBox2

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
foreach ($flag in $MasterGen.FlagCounts.Keys) {
    
    foreach ($groupName in $groups) {

        if ($blocks.$groupName.BlockFlag -ne $flag) {
            
            continue

        }else{

            if ($TagLstBox0.Items.Count -lt 14) {

                $TagBox = New-TagBox -InputName $groupName
                $TagBox.Width = 225
                $TagLstBox0.Items.Add($TagBox)
                $null = $TagBox

            } elseif ($TagLstBox1.Items.Count -lt 14) {

                $TagBox = New-TagBox -InputName $groupName
                $TagBox.Width = 225
                $TagLstBox1.Items.Add($TagBox)
                $null = $TagBox

            } else {

                $TagBox = New-TagBox -InputName $groupName
                $TagBox.Width = 225
                $TagLstBox2.Items.Add($TagBox)
                $null = $TagBox

            }
        }
    }
}




















[void]$window.ShowDialog()
# Remove-Variable -Name window