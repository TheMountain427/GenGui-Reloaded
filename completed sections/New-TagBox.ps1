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
        [string]$InputName
    )

    # not even gunna comment this one, its just straight disgusting
    # it makes the boxes for the tag count list, all you really need to know
    Begin{  

        Add-Type -AssemblyName PresentationCore, PresentationFramework

        Function Set-Binding {
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
        $tagCountDownBtnName = $InputName + "TagCounDownBtn" 

        $masterGrid = [Grid]::new()
            $masterGrid.Name = $masterGridName
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
                $tagLabelGrid.Name = $tagLabelGridName

                $tagLabel = [Label]::new()
                    $tagLabel.Name = $tagLabelName
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
            [void]$tagLabelGrid.Children.Add($tagLabel)
        [void]$masterGrid.Children.Add($tagLabelGrid)

            $upDownGrid = [Grid]::new()
                $upDownGrid.Name = $upDownGridName
                [Grid]::SetColumn($upDownGrid, 1)
                $upDownGrid.Height = 18
                $upDownGrid.MinHeight = 18
                $upDownGrid.MinWidth = 80
                $upDownGrid.MaxHeight = 18
                $upDownGrid.MaxWidth = 80
                $upDownGrid.HorizontalAlignment = "Left"
                $upDownGrid.VerticalAlignment = "Center"
                $upDownGrid.ColumnDefinitions.Add([ColumnDefinition]::new())
                $upDownGrid.ColumnDefinitions[0].Width = "50*"
                $upDownGrid.ColumnDefinitions.Add([ColumnDefinition]::new())
                $upDownGrid.ColumnDefinitions[1].Width = "26*"

                $tagCountTxtBoxGrid = [Grid]::new()
                    $tagCountTxtBoxGrid.Name = $tagCountTxtBoxGridName
                    $tagCountTxtBoxGrid.MaxWidth = 50
                    Set-Binding -TargetElement $tagCountTxtBoxGrid -TargetProperty $([Grid]::MaxHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                    $tagCountTxtBoxGrid.MinWidth = 50
                    Set-Binding -TargetElement $tagCountTxtBoxGrid -TargetProperty $([Grid]::MinHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                    $tagCountTxtBoxGrid.HorizontalAlignment = "Center"
                    $tagCountTxtBoxGrid.VerticalAlignment = "Center"

                    $tagCountTxtBox = [TextBox]::new()
                        $tagCountTxtBox.Name = $tagCountTxtBoxName
                        $tagCountTxtBox.Text = 0
                        $tagCountTxtBox.Height = 17
                        $tagCountTxtBox.MinHeight = 17
                        $tagCountTxtBox.MinWidth = 50
                        $tagCountTxtBox.MaxHeight = 17
                        $tagCountTxtBox.MaxWidth = 50
                        $tagCountTxtBox.HorizontalAlignment = "Left"
                        $tagCountTxtBox.TextWrapping = "Wrap"
                        [Grid]::SetColumn($tagCountTxtBox, 1)
                        $tagCountTxtBox.HorizontalAlignment = "Left"
                        $tagCountTxtBox.VerticalAlignment = "Center"
                        # $tagCountTxtBox.BorderBrush = $null
                [void]$tagCountTxtBoxGrid.Children.Add($tagCountTxtBox)
            [void]$upDownGrid.Children.Add($tagCountTxtBoxGrid)

                    $tagCountUpDownGrid = [Grid]::new()
                        $tagCountUpDownGrid.Name = $tagCountUpDownGridName
                        $tagCountUpDownGrid.Width = 25
                        $tagCountUpDownGrid.Height = 20
                        $tagCountUpDownGrid.MinWidth = 25
                        $tagCountUpDownGrid.MaxWidth = 25
                        Set-Binding -TargetElement $tagCountUpDownGrid -TargetProperty $([Grid]::MinHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                        Set-Binding -TargetElement $tagCountUpDownGrid -TargetProperty $([Grid]::MaxHeightProperty) -Source $upDownGrid -SourceProperty "ActualHeight" -Mode "OneWay"
                        [Grid]::SetColumn($tagCountUpDownGrid, 1) 
                        $tagCountUpDownGrid.HorizontalAlignment = "Left"
                        $tagCountUpDownGrid.VerticalAlignment = "Center"

                        $tagCountUpBtn = [Button]::new()
                            $tagCountUpBtn.Name = $tagCountUpBtnName
                            $tagCountUpBtn.Content = [char]::convertfromUtf32(0x23F7)
                            $tagCountUpBtn.HorizontalAlignment = "Center"
                            $tagCountUpBtn.VerticalAlignment = "Bottom"
                            $tagCountUpBtn.Width = 25
                            $tagCountUpBtn.MinWidth = 25
                            $tagCountUpBtn.MinHeight = 8.5
                            $tagCountUpBtn.MaxHeight = 8.5
                            $tagCountUpBtn.MaxWidth = 25
                            $tagCountUpBtn.VerticalContentAlignment = "Center"
                            $tagCountUpBtn.HorizontalContentAlignment = "Center"
                            $tagCountUpBtn.Height = 8.5
                            $tagCountUpBtn.FontSize = 8
                            $tagCountUpBtn.Padding = "0,-2.5,0,0"
                            $tagCountUpBtn.BorderThickness = "1,1,1,1"
                    [void]$tagCountUpDownGrid.Children.Add($tagCountUpBtn)

                        $tagCountDownBtn = [Button]::new()
                            $tagCountDownBtn.Name = $tagCountDownBtnName
                            $tagCountDownBtn.Content = [char]::convertfromUtf32(0x23F6)
                            $tagCountDownBtn.HorizontalAlignment = "Center"
                            $tagCountDownBtn.VerticalAlignment = "Top"
                            $tagCountDownBtn.VerticalContentAlignment = "Center"
                            $tagCountDownBtn.HorizontalContentAlignment = "Center"
                            $tagCountDownBtn.Width = 25
                            $tagCountDownBtn.Height = 8.5
                            $tagCountDownBtn.MinWidth = 25
                            $tagCountDownBtn.MinHeight = 8.5
                            $tagCountDownBtn.MaxHeight = 8.5
                            $tagCountDownBtn.MaxWidth = 25
                            $tagCountDownBtn.FontSize = 8
                            $tagCountDownBtn.Padding = "0,-2.5,0,0"
                            $tagCountDownBtn.BorderThickness = "1,1,1,1"
                    [void]$tagCountUpDownGrid.Children.Add($tagCountDownBtn)
                [void]$upDownGrid.Children.Add($tagCountUpDownGrid)
        [void]$masterGrid.Children.Add($upDownGrid)

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