using namespace System.Windows.Controls
using namespace System.Windows.Shapes
using namespace System.Windows.Media

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()


function New-TagBox {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER param1
    .PARAMETER param2
    .EXAMPLE
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    .NOTES
    #>

    [CmdletBinding()]
    #[CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$InputName,
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [System.Windows.Window]$Window
    )

    # not even gunna apologize, this one is just straight disgusting
    # it makes the boxes for the tag count list, all you really need to know
    Begin{  

        Add-Type -AssemblyName PresentationCore, PresentationFramework

        function Set-Binding {
            Param($TargetElement, $TargetProperty, $Source, $SourceProperty, $Mode)
        
            $Bind = [System.Windows.Data.Binding]::new()
            $Bind.Mode = $Mode
            $Bind.Source = $Source
            $Bind.Path = $SourceProperty

            [void]$TargetElement.SetBinding($TargetProperty, $Bind) 
        }

    }

    Process{ 

        if ($InputName -match "_{1}") { # fucking mnemonics, escape a single _
            $tagLabelContent = $InputName -replace "_", "__"
        }else{
            $tagLabelContent = $InputName
        }


        $masterGridName = $InputName + "MasterGrid"
        $borderRectangleName = $InputName + "BorderRectangle"
        $tagLabelGridName= $InputName + "TagLabelGrid"
        $tagLabelName = $InputName + "TagLabel"
        $upDownGridName= $InputName + "UpDownGrid"
        $tagCountTxtBoxGridName = $InputName + "TagCountTxtBoxGrid"
        $tagCountTxtBoxName= $InputName + "TagCountTxtBox"
        $tagCountUpDownGridName = $InputName + "TagCountUpDownGrid"
        $tagCountUpBtnName= $InputName + "TagCountUpBtn"
        $tagCountDownBtnName = $InputName + "TagCountDownBtn" 


        $masterGrid = [Grid]::new()
            $masterGrid.Name = $masterGridName 
            $Window.RegisterName($masterGrid.Name, $masterGrid) # <- oooof, FindName won't work if things are registered
            $masterGrid.Height = 20
            $masterGrid.MinHeight = 20
            $masterGrid.MaxHeight = 20
            $masterGrid.MaxWidth = 250
            $masterGrid.ColumnDefinitions.Add([ColumnDefinition]::new())
                $masterGrid.ColumnDefinitions[0].Width = "207*"
            $masterGrid.ColumnDefinitions.Add([ColumnDefinition]::new())
                $masterGrid.ColumnDefinitions[1].Width = "80"

            $borderRectangle = [Rectangle]::new()
                $borderRectangle.Name = $borderRectangleName
                $Window.RegisterName($borderRectangle.Name, $borderRectangle) # <-- gotta register :))))))))))))))))
                $borderRectangle.HorizontalAlignment = "Left"
                $borderRectangle.VerticalAlignment = "Center"
                $borderRectangle.Stroke = [Brushes]::Black
                [Grid]::SetColumnSpan($borderRectangle, 2)
                Set-Binding -TargetElement $borderRectangle -TargetProperty $([Rectangle]::MinHeightProperty) -Source $masterGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                Set-Binding -TargetElement $borderRectangle -TargetProperty $([Rectangle]::MinWidthProperty) -Source $masterGrid -SourceProperty "ActualWidth" -Mode "OneWay"
                Set-Binding -TargetElement $borderRectangle -TargetProperty $([Rectangle]::MaxWidthProperty) -Source $masterGrid -SourceProperty "ActualWidth" -Mode "OneWay"
                Set-Binding -TargetElement $borderRectangle -TargetProperty $([Rectangle]::MaxHeightProperty) -Source $masterGrid -SourceProperty "ActualHeight" -Mode "OneWay"
        [void]$masterGrid.Children.Add($borderRectangle)

            $tagLabelGrid = [Grid]::new()
                $tagLabelGrid.Name = $tagLabelGridName # <-- don't forget to register ;))))
                $Window.RegisterName($tagLabelGrid.Name, $tagLabelGrid)

                $tagLabel = [Label]::new()
                    $tagLabel.Name = $tagLabelName
                    $Window.RegisterName($tagLabel.Name, $tagLabel)
                    $tagLabel.Content = $tagLabelContent
                    $tagLabel.Width = 58
                    $tagLabel.HorizontalAlignment = "Center"
                    $tagLabel.VerticalAlignment = "Center"
                    Set-Binding -TargetElement $tagLabel -TargetProperty $([Label]::MinWidthProperty) -Source $tagLabelGrid -SourceProperty "ActualWidth" -Mode "OneWay"
                    Set-Binding -TargetElement $tagLabel -TargetProperty $([Label]::MinHeightProperty) -Source $tagLabelGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                    $tagLabel.HorizontalContentAlignment = "Center"
                    $tagLabel.VerticalContentAlignment = "Center"
                    $tagLabel.Padding = "0,0,0,0"
                    Set-Binding -TargetElement $tagLabel -TargetProperty $([Label]::MaxWidthProperty) -Source $tagLabelGrid -SourceProperty "ActualWidth" -Mode "OneWay"
                    Set-Binding -TargetElement $tagLabel -TargetProperty $([Label]::MaxHeightProperty) -Source $tagLabelGrid -SourceProperty "ActualWidth" -Mode "OneWay"
                    $tagLabel.Foreground = "#FFDEDEDE"
            [void]$tagLabelGrid.Children.Add($tagLabel)
        [void]$masterGrid.Children.Add($tagLabelGrid)

            $upDownGrid = [Grid]::new()
                $upDownGrid.Name = $upDownGridName
                $Window.RegisterName($upDownGrid.Name, $upDownGrid) # <-- always register your items :DDDD
                [Grid]::SetColumn($upDownGrid, 1)
                $upDownGrid.Height = 18
                $upDownGrid.MinHeight = 18
                $upDownGrid.MinWidth = 80
                $upDownGrid.MaxHeight = 18
                $upDownGrid.MaxWidth = 80
                $upDownGrid.HorizontalAlignment = "Left"
                $upDownGrid.VerticalAlignment = "Center"
                $upDownGrid.ColumnDefinitions.Add([ColumnDefinition]::new())
                $upDownGrid.ColumnDefinitions[0].Width = "28*"
                $upDownGrid.ColumnDefinitions.Add([ColumnDefinition]::new())
                $upDownGrid.ColumnDefinitions[1].Width = "52*"

                $tagCountTxtBoxGrid = [Grid]::new()
                    $tagCountTxtBoxGrid.Name = $tagCountTxtBoxGridName
                    $Window.RegisterName($tagCountTxtBoxGrid.Name, $tagCountTxtBoxGrid) # <-- I don't care who you are, you gotta register d:))))
                    $tagCountTxtBoxGrid.Width = 30
                    Set-Binding -TargetElement $tagCountTxtBoxGrid -TargetProperty $([Grid]::MaxHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                    Set-Binding -TargetElement $tagCountTxtBoxGrid -TargetProperty $([Grid]::MinHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                    $tagCountTxtBoxGrid.HorizontalAlignment = "Center"
                    $tagCountTxtBoxGrid.VerticalAlignment = "Center"

                    $tagCountTxtBox = [TextBox]::new()
                        $tagCountTxtBox.Name = $tagCountTxtBoxName
                        $Window.RegisterName($tagCountTxtBox.Name, $tagCountTxtBox) # making an item? register :PPP
                        $tagCountTxtBox.Tag = $InputName
                        $tagCountTxtBox.Text = 0
                        $tagCountTxtBox.Height = 17
                        $tagCountTxtBox.Width = 25
                        $tagCountTxtBox.HorizontalAlignment = "Center"
                        $tagCountTxtBox.VerticalAlignment = "Center"
                        $tagCountTxtBox.VerticalContentAlignment = "Center"
                        $tagCountTxtBox.HorizontalContentAlignment = "Center"
                        $tagCountTxtBox.Background = "#FF3B3B3B"
                        $tagCountTxtBox.BorderBrush = "#FF171717"
                        $tagCountTxtBox.Foreground = "#FFDEDEDE"
                        $tagCountTxtBox.SelectionBrush = "#FF000000"
                        [Grid]::SetColumn($tagCountTxtBox, 0)
                        # $tagCountTxtBox.BorderBrush = $null
                [void]$tagCountTxtBoxGrid.Children.Add($tagCountTxtBox)
            [void]$upDownGrid.Children.Add($tagCountTxtBoxGrid)

                    $tagCountUpDownGrid = [Grid]::new()
                        $tagCountUpDownGrid.Name = $tagCountUpDownGridName
                        $Window.RegisterName($tagCountUpDownGrid.Name, $tagCountUpDownGrid) # <-- another item? register XDDD
                        $tagCountUpDownGrid.Width = 52
                        $tagCountUpDownGrid.Height = 20
                        Set-Binding -TargetElement $tagCountUpDownGrid -TargetProperty $([Grid]::MinHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                        Set-Binding -TargetElement $tagCountUpDownGrid -TargetProperty $([Grid]::MaxHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                        [Grid]::SetColumn($tagCountUpDownGrid, 1) 
                        $tagCountUpDownGrid.HorizontalAlignment = "Center"
                        $tagCountUpDownGrid.VerticalAlignment = "Center"

                        $tagCountUpBtn = [Button]::new()
                            $tagCountUpBtn.Name = $tagCountUpBtnName
                            $Window.RegisterName($tagCountUpBtn.Name, $tagCountUpBtn) # <-- register your items, it's good for you :DDDD
                            $tagCountUpBtn.Tag = $InputName
                            $tagCountUpBtn.Content = [char]::convertfromUtf32(0x23F6)
                            $tagCountUpBtn.HorizontalAlignment = "Left"
                            $tagCountUpBtn.VerticalAlignment = "Center"
                            $tagCountUpBtn.VerticalContentAlignment = "Center"
                            $tagCountUpBtn.HorizontalContentAlignment = "Center"
                            $tagCountUpBtn.Width = 25
                            $tagCountUpBtn.Height = 25
                            $tagCountUpBtn.FontSize = 12
                            $tagCountUpBtn.Padding = "0,0,0,0"
                            $tagCountUpBtn.BorderThickness = "1,1,1,1"
                    [void]$tagCountUpDownGrid.Children.Add($tagCountUpBtn)

                        $tagCountDownBtn = [Button]::new()
                            $tagCountDownBtn.Name = $tagCountDownBtnName
                            $Window.RegisterName($tagCountDownBtn.Name, $tagCountDownBtn) # <-- making a button? <-- believe it or not, straight to register :3333
                            $tagCountDownBtn.Tag = $InputName
                            $tagCountDownBtn.Content = [char]::convertfromUtf32(0x23F7)
                            $tagCountDownBtn.HorizontalAlignment = "Right"
                            $tagCountDownBtn.VerticalAlignment = "Center"
                            $tagCountDownBtn.Width = 25
                            $tagCountDownBtn.Height = 25
                            $tagCountDownBtn.VerticalContentAlignment = "Center"
                            $tagCountDownBtn.HorizontalContentAlignment = "Center"
                            $tagCountDownBtn.FontSize = 12
                            $tagCountDownBtn.Padding = "0,0,0,0"
                            $tagCountDownBtn.BorderThickness = "1,1,1,1"
                    [void]$tagCountUpDownGrid.Children.Add($tagCountDownBtn)
                [void]$upDownGrid.Children.Add($tagCountUpDownGrid)
        [void]$masterGrid.Children.Add($upDownGrid)

        Set-Variable -Name $masterGrid.Name -Value $masterGrid -Scope 1
        Set-Variable -Name $borderRectangle.Name -Value $borderRectangle -Scope 1
        Set-Variable -Name $tagLabelGrid.Name -Value $tagLabelGrid -Scope 1
        Set-Variable -Name $tagLabel.Name -Value $tagLabel -Scope 1
        Set-Variable -Name $upDownGrid.Name -Value $upDownGrid -Scope 1
        Set-Variable -Name $tagCountTxtBoxGrid.Name -Value $tagCountTxtBoxGrid -Scope 1
        Set-Variable -Name $tagCountTxtBox.Name -Value $tagCountTxtBox -Scope 1
        Set-Variable -Name $tagCountUpDownGrid.Name -Value $tagCountUpDownGrid -Scope 1
        Set-Variable -Name $tagCountUpBtn.Name -Value $tagCountUpBtn -Scope 1
        Set-Variable -Name $tagCountUpBtn.Name -Value $tagCountUpBtn -Scope 1

    return $masterGrid  
    }
    End{

    }
}



# $window = [System.Windows.Window]::new()
#     $window.Title = "Window"
#     $window.Height = 450
#     $window.Width = 804
#     $window.WindowStartupLocation = "CenterScreen"
#     $test = New-TagBox -InputName "test"
#     $window.Content = $test
#     $window.ShowDialog()