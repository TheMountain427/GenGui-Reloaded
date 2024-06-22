[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()
function Clear-SelectedLines {
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
            
            $blocks = $MasterGen.Blocks
            $groups = $blocks.Keys

            foreach ($groupName in $groups) { 
                $blocks.$groupName.SelectedLines.Clear()
            }
        
        }
        End{ # Used for cleanup
        }
    }