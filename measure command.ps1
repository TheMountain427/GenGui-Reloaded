[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()

$measurement = (1..20 | foreach { Measure-Command {
            Get-AllData $masterGen
} } | Measure-Object -Property TotalMilliseconds -Average).Average
Write-Host "`n $measurement"