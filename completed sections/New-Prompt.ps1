using namespace System.Collections.Generic
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()
function New-Prompt {
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
        [Parameter(Mandatory = $false)]
            [string]$SingleFlag = '',
        [Parameter(Mandatory=$false)]
            [int]$Seed
    )
    
    Begin{ # Pipeline values are not available yet

        # this probably not the best idea, but generating the prompt segment is done by a method
        class PromptSegment {

            [string] $Flag = '' # Positve, Negative
            [List[object]] $SegmentTags = [List[object]]::new()
            [string] GetApiSegment() { # method that generates api prompt
                # --Positive "Tag1, Tag2"
                # if ($this.SegmentTags[0] -ne [string]) {
                #     $this.SegmentTags.RemoveAt(0)
                # }
                if ($this.SegmentTags.Count -le 0) { 
                    return $null # don't output anything if there are no tags
                }
                if ($this.SegmentTags.Count -eq 1) {
                    # bugs out if you try to join when count = 1
                    return [string]("--$($this.Flag) `"$((($this.SegmentTags)).Trim(','))`" ")
                }else{
                    return [string]("--$($this.Flag) `"$(([System.String]::Join(' ',$this.SegmentTags)).Trim(','))`" ")
                }
            }
            [string] GetSingleSegment() {
                if ($this.SegmentTags.Count -le 0) { 
                    return $null # don't output anything if there are no tags
                }
                if ($this.SegmentTags.Count -eq 1) {
                    # bugs out if you try to join when count = 1
                    return [string]("$((($this.SegmentTags)).Trim(',')) ")
                }else{
                    return [string]("$(([System.String]::Join(' ',$this.SegmentTags)).Trim(',')) ")
                }
            }
        }
    }

    Process{ # Pipeline values are available here
        $blocks = $MasterGen.Blocks
        $flagCounts = $MasterGen.FlagCounts
        $groups = $blocks.Keys

        $allSegments = [List[object]]::new()
        $allSegments.Capacity = $flagCounts.Count

        if ($SingleFlag -eq '') {

            foreach ($flag in $flagCounts.Keys) {

                if ($flagCounts.$flag -le 0) {
            
                    continue

                }else{
                            
                    $tagList = [List[object]]::new() # <-- this gave me a bruh moment, couldn't clear it lol
                    $tagList.Capacity = 50
                    $segment = [PromptSegment]::new()
                    $segment.SegmentTags.Capacity = 50

                    foreach ($groupName in $groups) {

                        if ($blocks.$groupName.BlockFlag -match "(?i)$($flag)") {

                            $tagList.Add($blocks.$groupName.SelectedLines)
                    
                        }
                    }

                    $segment.Flag = $flag
                    $segment.SegmentTags = ($tagList | foreach  {
                        [System.String]::Join(' ', $_)
                    })
                }

                $allSegments.Add($segment.GetApiSegment())

            }

            $output = [System.String]::Join(' ', $allSegments)
            $masterGen.PromptOutput = $output

            }else{

                $flag = $SingleFlag

                if ($flagCounts.$flag -le 0) {
                    Write-Error "No selected blocks are set to match $flag"
                    continue

                }else{
                            
                    $tagList = [List[object]]::new() # <-- this gave me a bruh moment, couldn't clear it lol
                    $tagList.Capacity = 50
                    $segment = [PromptSegment]::new()
                    $segment.SegmentTags.Capacity = 50

                    foreach ($groupName in $groups) {

                        if ($blocks.$groupName.BlockFlag -match "(?i)$($flag)") {

                            $tagList.Add($blocks.$groupName.SelectedLines)
                    
                        }
                    }

                    $segment.Flag = $flag
                    #$taglist.RemoveAt(0) # first item is an [int]0
                    $segment.SegmentTags = ($tagList | foreach {
                            [System.String]::Join(' ', $_)
                        })
                }
                
                $allSegments.Add($segment.GetSingleSegment())

                $output = [System.String]::Join(' ', $allSegments)
                $MasterGen.PromptOutput = $output
                
            }
        }
    End{ # Used for cleanup
    }
}