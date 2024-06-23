[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()
function Set-FlagCounts {
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
            [object]$MasterGen,
        [Parameter(Mandatory=$false)]
            [int]$Seed = 0
    )

    Begin{ # Pipeline values are not available yet   
    }
    Process{ # Pipeline values are available here
        # set a FlagCounts variable so that later we can skip logic if the data contains
        # no blocks with that flag type

        $blocks = $MasterGen.Blocks
        $groups = $blocks.Keys

        $flagCounts = $MasterGen.FlagCounts

        $flagKeys = [array]$flagCounts.Keys

        foreach ($groupName in $groups) {
            
            $blockFlag = $blocks.$groupName.BlockFlag

            if ($flagKeys.Contains($blockFlag)) {
                $flagCounts.$blockFlag++
            }else{
                continue
            }
        }
    }
    End{ # Used for cleanup
    }
}