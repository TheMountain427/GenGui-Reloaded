[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()
function Set-AllTagCounts {
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
            [Parameter(Mandatory=$false,ValueFromPipeline)]
                [hashtable]$InputTagCounts = @{},
            [Parameter(Mandatory=$false)]
                [int]$Seed
        )
    
        Begin{ # Pipeline values are not available yet   
        }
        # $inputTagCounts = @{
        #    groupName1 = Number
        #    groupName2 = Number
        #}
        Process{ # Pipeline values are available here
            
            $blocks = $MasterGen.Blocks
            $groups = $blocks.Keys
            
            # ensure that the supplied group names exist in the data. if not, write a warning and remove the key from inputs
            $inputNamesToRemove = [System.Collections.Generic.List[object]]::new()
            $inputNamesToRemove.Capacity = 50
            # must add names to remove to a seperate list then remove them seperately, else throws "Collection was modified; enumeration operation may not execute."
            foreach ($inputName in $InputTagCounts.Keys) {
                try {
                    if ($blocks.ContainsKey($inputName)) {
                        continue
                    }else{
                        throw
                    }
                }catch{
                    Write-Error "BlockName: $inputName, not found in list of BlockNames"
                    $inputNamesToRemove.Add($inputName) 
                }
            }
            foreach($toRemove in $inputNamesToRemove) {
                $InputTagCounts.Remove($toRemove)
            }

            # take input numbers and assign it to a key nested under the relevant block name
            foreach ($groupName in $groups) {

                # if a number was supplied, we use that, else set 0 so no tags are selected
                # also check if supplied number is a neg. if neg, set to 0
                if (($InputTagCounts.ContainsKey($groupName)) -and ($InputTagCounts.$groupName -ge 0)) {
                    $NumOfTagsToSelect = $InputTagCounts.$groupName
                }else{
                    $NumOfTagsToSelect = 0
                }

                # check if the NumOfTags key exists. If yes, set the value. If no, create it and its value.
                # should be obsolete, just set =
                if ($blocks.$groupName.ContainsKey("NumOfTagsToSelect")) {
                    $blocks.$groupName.NumOfTagsToSelect = $NumOfTagsToSelect
                }else{
                    $blocks.$groupName.Add("NumOfTagsToSelect", $NumOfTagsToSelect)
                }
            }
        }
        End{ # Used for cleanup
        }
    }