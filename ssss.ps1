function Show-StringSelection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title, # Title of the window

        [string]$Label = 'Please select one or more:', # Label for the ListBox

        [ValidateSet('Single', 'Extended')]
        [string]$SelectionMode = 'Extended', # Selection mode for ListBox: Single, Extended

        [Parameter(Mandatory = $true)]
        [string[]]$StringArray, # Array of strings to populate the ListBox

        [int]$Height = 300, #Window height
        [int]$Width = 500 # Window width
    )

    # Load the necessary .NET Framework assembly for WPF
    Add-Type -AssemblyName presentationframework

    # Define the XAML structure for the window
    [xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="$Title"
        WindowStartupLocation="CenterScreen"
        Topmost="true"
        MinHeight="300"
        Height="$Height"
        MinWidth="300"
        Width="$Width">
    <Grid Margin="5">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="*" />
            <RowDefinition Height="Auto" />
        </Grid.RowDefinitions>
        <TextBlock Grid.Row="0" Margin="5" FontWeight="Bold" Text="$Label" />
        <ListBox Grid.Row="1" Margin="5" Name="ListBox" SelectionMode="$SelectionMode" />
        <UniformGrid Rows="1" Columns="2" Grid.Row="2">
            <Button Margin="5" Name="ButtonOk" Content="OK" />
            <Button Margin="5" Name="ButtonCancel" Content="Abbrechen" />
        </UniformGrid>
    </Grid>
</Window>
"@
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)

    # Populate the ListBox with items from the provided array
    $ListBox = $window.FindName('ListBox')
    foreach ($String in $StringArray) {
        [void]$ListBox.Items.Add($String)
    }

    # Event handler for OK button click
    $ButtonOk = $window.FindName('ButtonOk')
    $ButtonOk.Add_Click({
            $script:Selection = $ListBox.SelectedItems | Sort-Object
            $window.Close()
        })

    # Event handler for Cancel button click
    $ButtonCancel = $window.FindName('ButtonCancel')
    $ButtonCancel.Add_Click({
            $script:Selection = $null
            $window.Close()
        })

    # Show the window as a dialog
    [void]$window.ShowDialog()

    # Return the selected items (if any)
    return $script:Selection
}
Show-StringSelection -Title "windowTitle" -Label "Labelll" -SelectionMode Extended -StringArray "ABC" -Height 600 -Width 800