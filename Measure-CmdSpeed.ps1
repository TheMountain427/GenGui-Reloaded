[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()

# $measurement = (1..20 | foreach { Measure-Command {
            
# } } | Measure-Object -Property TotalMilliseconds -Average).Average; $output = "`nCommand:`n`t$cmdString`n`nAverage Speed:`n`t$measurement ms`n"; Write-host $output


# prefer verbatim strings = '' and @''@
# over expandable strings = "" and @""@
function Measure-CmdSpeed {
    param (
        [Parameter(Mandatory = $true)]
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