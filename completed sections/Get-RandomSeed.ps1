[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()

function Get-RandomSeed {
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
            [Parameter(Mandatory=$true,ValueFromPipeline)]
            [object]$MasterGen
        )
        Begin{ # Pipeline values are not available yet     
        }
        
        Process{ # Pipeline values are available here
            # returns a random 8 digit seed. hopefully more random than doing just get-random
            $numbers = [System.Collections.Generic.List[int]]::new()
            (1..8) | foreach {
                $numbers.Add((Get-Random -Maximum 10))
            }
            $str = ""
            foreach ($num in $numbers) { 
                $str = $str + $num.ToString()
            }
            $RandomSeed = [int]$str
            $MasterGen.Seed = $RandomSeed

        }
        End{ # Used for cleanup
        }
    
    }