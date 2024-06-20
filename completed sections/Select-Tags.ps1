using namespace System.Collections.Generic
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()
function Select-Tags {
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

            $blocks = $MasterGen.Blocks
            $groups = $blocks.Keys

            # instantiate random seed so get-random is repeatable if seed is given. Or truly random if not
            if ($Seed -ne 0) {
                Get-Random -SetSeed $Seed | Out-Null
            }elseif ($MasterGen.Seed -ne 0) {
                Get-Random -SetSeed $MasterGen.Seed
            }else{
                $newSeed = Get-Random -SetSeed ([Environment]::TickCount) 
                $MasterGen.Seed = $newSeed
            }

            foreach ($groupName in $groups) {

                if (($blocks.$groupName.ContainsKey("SelectCount")) -ne $true) {

                    Write-Warning "$groupName does not contain a SelectCount property"
                    continue # shouldn't happen unless pipeline is done incorrectly

                }

                if ($blocks.$groupName.SelectCount -le 0) {
                    continue # go next, no need to do anything if nothing will be selected
                }

                # shorten some variables for readabillity
                $numOfTagsToSelect = $blocks.$groupName.SelectCount
                $totalTagsInBlock = $blocks.$groupName.Tags.Count
                $tags = $blocks.$groupName.Tags

                # select the lines by position and add to a list
                $selectedLines = [List[object]]::new()
                $selectedLines.Capacity = 10

                if ($totalTagsInBlock -eq 1) {
                    # if total lines = 1, powershell returns a string instead of a string[]. this makes the line return as 0 in the final output
                    $selectedLines.Add($tags.Line)

                }else{

                    # should be no repeats since getting random elements from an array instead of just random numbers
                    $selectedLineNumbers = [array]((0..($totalTagsInBlock-1)) | Get-Random -Count $numOfTagsToSelect)

                }

                foreach ($int in $selectedLineNumbers) { 
                    $selectedLines.Add($tags.Line[$int])
                }

                # if key exists, set selectedLines equal to it, else create it
                # check should be obsolete, just set =
                if ($blocks.$groupName.ContainsKey("SelectedLines")) {
                    $blocks.$groupName.SelectedLines = $selectedLines
                }else {
                    $blocks.$groupName.Add("SelectedLines", $selectedLines)
                }
            
            }
        }
    End{ # Used for cleanup
    }
}