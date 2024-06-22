using namespace System.Collections.Generic

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()

function New-DataBlock {
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
        #[Parameter(Mandatory=$true,ValueFromPipeline)]
        #[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory=$true,ValueFromPipeline)]
        [string]$Path
    )

    Begin {
        # Pipeline values are not available yet 
        class Generator  {
            [hashtable]$Blocks = @{}
            [string]$DataPath = ''
            [PromptOutput]$PromptOutput = [PromptOutput]::new()
            [List[object]]$PromptHistory = [List[object]]::new()
            [int]$Seed = 0
            [object]$FlagCounts 

            # Return the PromptHistory. Loops in reverse order because prompts are added using Add
            # instead of Insert due to performance
            # At least I think "Add -> loop backwards to return" is faster than Insert(0, [object]) -> Return List
            [List[object]]GetPromptHistory() {
                $list =  [System.Collections.Generic.List[object]]::new()
                $cnt = $this.PromptHistory.Count - 1 
                while ($cnt -ge 0) {
                    $list.Add($this.PromptHistory[$cnt])
                    $cnt--
                }
                return $list
            }
        }

        class PromptOutput : Hashtable {
            [string]$Prompt = ''
            [int]$PromptSeed = 0
            
            PromptOutput() { $this.Init(@{
                'Prompt' = [string]$this.Prompt
                'PromptSeed' = [int]$this.Seed
            }) }

            PromptOutput([hashtable]$Properties) { $this.Init($Properties) }

            [void] Init([hashtable]$Properties) {
                foreach ($Property in $Properties.Keys) {
                    $this.$Property = $Properties.$Property
                }
            }
        }
    }
    
    Process {
        # Pipeline values are available here

        try {
            # test that path to collections exists
            if ((Test-Path -Path $Path) -eq $false) {
                throw
            }
        }catch{
            Write-Error "Path specified not found"
            return
        }

        # digusting :)
        $flgCounts = [ordered]@{
                "positive"            = 0       # prompt
                "negative"            = 0       # negative_prompt
                "width"               = 0 
                "height"              = 0 
                "steps"               = 0 
                "cfg_scale"           = 0 
                "batch_size"          = 0 
                "sd_model"            = 0 
                "sampler_name"        = 0 
                "seed"                = 0 
                "subseed"             = 0 
                "outpath_samples"     = 0 
                "outpath_grids"       = 0 
                "prompt_for_display"  = 0 
                "styles"              = 0 
                "subseed_strength"    = 0 
                "seed_resize_from_h"  = 0 
                "seed_resize_from_w"  = 0 
                "sampler_index"       = 0 
                "n_iter"              = 0 
                "restore_faces"       = 0 
                "tiling"              = 0 
                "do_not_save_samples" = 0 
                "do_not_save_grid"    = 0 
            }

        # Create or reset the blocks master variable
        $MasterGen = [Generator]::new()

        $MasterGen.FlagCounts = $flgCounts
        $MasterGen.DataPath = $Path
        $MasterGen.PromptHistory.Capacity = 50
        
        return $MasterGen

    }
    End {
        # Used for cleanup
    }
}