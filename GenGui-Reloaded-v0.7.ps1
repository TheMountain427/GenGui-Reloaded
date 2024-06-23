using namespace System.Windows.Controls
using namespace System.Windows.Shapes
using namespace System.Windows.Media

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()

# hide console window
# cmd process won't end unless we kill it.
# save the process to a variable so we can kill it after closing gui
# Add-Type -Name Window -Namespace Console -MemberDefinition '
# [DllImport("Kernel32.dll")]
# public static extern IntPtr GetConsoleWindow();

# [DllImport("user32.dll")]
# public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'

# [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)

# $cmdProcess = Get-Process -Name cmd | select Id, StartTime | sort StartTime -Descending | select * -First 1


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

function Measure-CmdSpeed {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cmdString
    )

    $cmd = [scriptblock]::Create($cmdString)

    $measurement = (1..20 | foreach { 
        Measure-Command {
            & $cmd
        } 
    } | Measure-Object -Property TotalMilliseconds -Average).Average

    $output = "`nCommand:`n`t$cmdString`n`nAverage Speed:`n`t$measurement ms`n"

    return $output
}

function Set-Binding {
    Param($TargetElement, $TargetProperty, $Source, $SourceProperty, $Mode)

    $Bind = [System.Windows.Data.Binding]::new()
    $Bind.Mode = $Mode
    $Bind.Source = $Source
    $Bind.Path = $SourceProperty

    [void]$TargetElement.SetBinding($TargetProperty, $Bind) 
}

$functionPath = "$PSScriptRoot\Completed Sections"
$functions = Get-ChildItem -Path $functionPath
foreach ($function in $functions) {
    . $function.FullName
}

$Path = "$PSScriptRoot\Prompt Collections\"

$MasterGen = New-DataBlock $Path

Get-AllData -MasterGen $MasterGen

Set-FlagCounts -MasterGen $MasterGen

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


function New-Tester { # test function lmao
    param( 
        [Parameter(Mandatory = $false,ValueFromPipeline)]
        [string]$Value = $null
    )
$tester = [System.Windows.Window]::new()
    $tester.Title = "tester"
    $tester.Height = 100
    $tester.Width = 200
    $tester.WindowStartupLocation = "CenterScreen"
    $test = [System.Windows.Controls.TextBox]::new()
    if ($null -ne $Value) {
        $test.Text = $Value
    }else{
        $test.Text = "It's ya boy.... Skinny Penis"
    }
    $tester.Content = $test
    $tester.ShowDialog()
}


$PromptOutputTxtBox.Add_LostFocus({ })

# Allow clicking out of text box, needs grid to have: Name, Focusable, Background(Can be transparent)
$WindowGrid.Add_MouseDown({ $WindowGrid.Focus() })



# --------- Generate Prompt Tab ---------

# Number of Prompts to Generate Text Box
# only accept int
$PromptNumTxtBox.Add_PreviewTextInput({
    $_.Handled = $_.Text -notmatch "\d" 
})

# can't be 0 or less
$PromptNumTxtBox.Add_LostFocus({
    if([int]$this.Text -le 0) {
        $this.Text = "1"
    }
})

# clear focus on enter
$PromptNumTxtBox.Add_KeyDown({
    if ($_.Key -eq [System.Windows.Input.Key]::Return) {
        $WindowGrid.Focus() # LostFocus won't fire on ClearFocus() alone, must change focus first
        [System.Windows.Input.Keyboard]::ClearFocus()
    }
})
# bind the slider to the value of $PromptNumTxtBox, surprisingly, it just works
Set-Binding -TargetElement $PromptNumSldr -TargetProperty $([System.Windows.Controls.Slider]::ValueProperty) -Source $PromptNumTxtBox -SourceProperty "Text" -Mode "TwoWay"

$GeneratePromptBtn.Add_Click({

    if ($GenTypePositive.IsSelected -eq $true) {

        $global:output = [System.Collections.Generic.List[object]]::new()

        $i = 1; while ([int]$PromptNumTxtBox.Text -ge $i){
            Select-Tags $MasterGen
            New-Prompt $MasterGen -SingleFlag "Positive"
            Clear-SelectedLines -MasterGen $masterGen
            $global:output.Add($MasterGen.PromptOutput.Prompt)
            $i++
        }

        [string]$global:finalOutput = "$([System.String]::Join("`n`n", $global:output))"
        $PromptOutputTxtBox.Text = $global:finalOutput


    }elseif ($GenTypeApi.IsSelected -eq $true) {

        $global:output = [System.Collections.Generic.List[object]]::new()

        $i = 1; while ([int]$PromptNumTxtBox.Text -ge $i){
            Select-Tags $MasterGen
            New-Prompt $MasterGen 
            Clear-SelectedLines -MasterGen $masterGen
            $global:output.Add($MasterGen.PromptOutput.Prompt)
            $i++
        }

        [string]$global:finalOutput = "$([System.String]::Join("`n`n", $global:output))"
        $PromptOutputTxtBox.Text = $global:finalOutput

    }
    
    # set last seed to text box
    $LastSeedTxtBox.Text = $MasterGen.PromptOutput.PromptSeed

    # Auto copy output to clipboard
    if ($AutoCopyChkBox.IsChecked -eq $true) {
        [System.Windows.Clipboard]::SetText($PromptOutputTxtBox.Text)
    }
})

$CopyToClipboardBtn.Add_Click({
    [System.Windows.Clipboard]::SetText($PromptOutputTxtBox.Text)
})




#------------------------------------


# --------- Tag Settings Tab ---------

# All tag count boxes -> Set Tag Counts
# Sets tag counts when the associated text box loses focus
Set-AllTagCounts -MasterGen $MasterGen # reset all counts to 0

# BlockName Text Box, SelectCount
$tagCountBoxes = ([System.Windows.NameScope]::GetNameScope($window)).Where({ $_.Value.Name -match ".*TagCountTxtBox$" }) # faster than Where-Object
foreach ($box in $tagCountBoxes) {

    # make the textbox only accept integer input from keyboard
    # you might think this should be $_.Text -match "\d", but actually $_.Handled needs to be false for the text to change
    $box.Value.Add_PreviewTextInput({
        $_.Handled = $_.Text -notmatch "\d" 
    })

    # when individual tag setting text box loses focus, set the associated blocks SelectCount value
    # using this instead of TextChanged cause uh, I'm not really sure anymore
    $box.Value.Add_LostFocus({ 
        if([int]$this.Text -le 0) {
            $this.Text = "0"
        }
        Set-SingleTagCount -MasterGen $MasterGen -BlockName $_.Source.Tag -InputTagCount $_.Source.Text 
    })

    # hitting enter when in a text box causes it to drop focus, instead of doing nothing
    $box.Value.Add_KeyDown({
        if ($_.Key -eq [System.Windows.Input.Key]::Return) {
            $WindowGrid.Focus()
            [System.Windows.Input.Keyboard]::ClearFocus()
        }
    })
}

# Up Buttons
# tag settings up buttons, f me, values from the routed source shit are $_.Source.<gui item> |||| addendum: instead of $_.Source, can use $this
#    "The $this variable is also used by .NET event classes that take script blocks as delegates for the event handler. 
#     In this scenario, $this represents the object originating the event, known as the event sender."
$tagCountUpBtns = ([System.Windows.NameScope]::GetNameScope($window)).Where({ $_.Value.Name -match ".*TagCountUpBtn$" })
foreach ($btn in $tagCountUpBtns) {
    $btn.Value.Add_Click({
        $btnPal = $window.FindName("$($_.Source.Tag)TagCountTxtBox") # only runs on btn generation
        $btnPal | % { $x =[int]$_.Text; $x++; $_.Text = $x }
        Set-SingleTagCount -MasterGen $MasterGen -BlockName $_.Source.Tag -InputTagCount $btnPal.Text
    })
}

# Down Buttons
# tag settings down buttons
$tagCountDownBtns = ([System.Windows.NameScope]::GetNameScope($window)).Where({ $_.Value.Name -match ".*TagCountDownBtn$" })
foreach ($btn in $tagCountDownBtns) {
    $btn.Value.Add_Click({
        $btnPal = $window.FindName("$($_.Source.Tag)TagCountTxtBox")
        $btnPal | % { $x = [int]$_.Text; $x--; if($x -lt 0){$x = 0}; $_.Text = $x }
        Set-SingleTagCount -MasterGen $MasterGen -BlockName $_.Source.Tag -InputTagCount $btnPal.Text
    })
}
#------------------------------------










[void]$window.ShowDialog()
# Remove-Variable -Name window

# kill the cmd process so it does not hang around
# and hold files hostage
# Stop-Process -Id $cmdProcess.Id

