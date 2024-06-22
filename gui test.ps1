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
# dynamically create the tag settings list
foreach ($flag in $MasterGen.FlagCounts.Keys) {
    
    foreach ($groupName in $groups) {

        if ($blocks.$groupName.BlockFlag -ne $flag) {
            
            continue

        }else{

            if ($TagLstBox0.Items.Count -lt 14) {

                $TagBox = New-TagBox -InputName $groupName -Window $window
                $TagBox.Width = 225
                [void]$TagLstBox0.Items.Add($TagBox)

            } elseif ($TagLstBox1.Items.Count -lt 14) {

                $TagBox = New-TagBox -InputName $groupName -Window $window
                $TagBox.Width = 225
                [void]$TagLstBox1.Items.Add($TagBox)

            } else {
                $TagBox = New-TagBox -InputName $groupName -Window $window
                $TagBox.Width = 225
                [void]$TagLstBox2.Items.Add($TagBox)

            }
        }
    }
}


function tester { # test function lmao
$tester = [System.Windows.Window]::new()
    $tester.Title = "tester"
    $tester.Height = 100
    $tester.Width = 200
    $tester.WindowStartupLocation = "CenterScreen"
    $test = [TextBox]::new()
    $test.Text = "It's ya boy.... Skinny Penis"
    $tester.Content = $test
    $tester.ShowDialog()
}



$PromptOutputTxtBox.Add_LostFocus({ tester })

# Allow clicking out of text box, needs grid to have: Name, Focusable, Background(Can be transparent)
$WindowGrid.Add_MouseDown({ $WindowGrid.Focus() })

# All tag count boxes -> Set Tag Counts
# Sets tag counts when the associated text box loses focus
Set-AllTagCounts -MasterGen $MasterGen # reset all counts to 0
$tagCountBoxes = [System.Windows.NameScope]::GetNameScope($window) | Where-Object { $_.Value.Name -match ".*TagCountTxtBox" }
foreach ($box in $tagCountBoxes) {
    $box.Value.Add_LostFocus({ 
        Set-SingleTagCount -MasterGen $MasterGen -BlockName $_.Source.Tag -InputTagCount $_.Source.Text 
})
}

# tag settings up buttons, f me, values from the routed source shit are $_.Source.<gui item>
$tagCountUpBtns = [System.Windows.NameScope]::GetNameScope($window) | Where-Object { $_.Value.Name -match ".*TagCountUpBtn" }
foreach ($btn in $tagCountUpBtns) {
    $btn.Value.Add_Click({
            $btnPal = $window.FindName("$($_.Source.Tag)TagCountTxtBox")
            $btnPal | % { $x =[int]$_.Text; $x++; $_.Text = $x }
            Set-SingleTagCount -MasterGen $MasterGen -BlockName $_.Source.Tag -InputTagCount $btnPal.Text
    })
}

# tag settings down buttons
$tagCountDownBtns = [System.Windows.NameScope]::GetNameScope($window) | Where-Object { $_.Value.Name -match ".*TagCountDownBtn" }
foreach ($btn in $tagCountDownBtns) {
    $btn.Value.Add_Click({
            $btnPal = $window.FindName("$($_.Source.Tag)TagCountTxtBox")
            $btnPal | % { $x = [int]$_.Text; $x--; if($x -lt 0){$x = 0}; $_.Text = $x }
            Set-SingleTagCount -MasterGen $MasterGen -BlockName $_.Source.Tag -InputTagCount $btnPal.Text
        })
}







[void]$window.ShowDialog()
# Remove-Variable -Name window



