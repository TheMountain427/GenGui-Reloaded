[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()
function Set-SingleTagCount {
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
            [Parameter(Mandatory=$true,ValueFromPipeline)]
                [string]$BlockName,
            #[Parameter(Mandatory=$true)]
                #[ValidateCount(1,1)]
                #[hashtable]$inputTagCount,
            [Parameter(Mandatory=$false)]
                [int]$Seed
        )
    
        Begin{ # Pipeline values are not available yet   
        }
        Process{ # Pipeline values are available here

            $blocks = $MasterGen.Blocks
            # ensure the supplied group name exists in the data. if not, stop the function.
            try {
                if ($blocks.ContainsKey($BlockName)) {
                    continue
                }else{
                    throw
                }
            }catch{
                Write-Error "BlockName: $BlockName, not found in list of BlockNames"
                return
            }
        

            # do some checks then set the NumOfTags key
            # if supplied number is a neg, set NumOfTags to 0
            if ($blocks.$BlockName -lt 0) {
                $numOfTagsToSelect = 0
            }else{    
                $numOfTagsToSelect = $blocks.$BlockName
            }

            # check if the NumOfTags key exists. If yes, set the value. If no, create it and its value.
            # should be obsolete, just set =
            if ($blocks.$BlockName.ContainsKey("SelectCount")) {
                $blocks.$BlockName.NumOfTagsToSelect = $numOfTagsToSelect
            }else{
                $blocks.$BlockName.Add("SelectCount", $numOfTagsToSelect)
            }
        
        }
        End{ # Used for cleanup
        }
    }