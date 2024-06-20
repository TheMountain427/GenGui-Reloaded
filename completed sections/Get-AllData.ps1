using namespace System.Collections.Generic

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
Param()

function Get-AllData {
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
            [object]$MasterGen,
        [Parameter(Mandatory=$false)]
            [int]$Seed
    )

    Begin{ # Pipeline values are not available yet 
        class Tag {
            [string]$Line
            [int]$OriginalLineNumber # Number from Select-String
            [int]$HashLineNumber # Original skips numbers when line is empty, don't think this is actually neccessary
        }

        class BlockData : System.Collections.Hashtable {
            [List[object]]$Tags = [List[object]]::new()
            [string]$BlockName = ''
            [string]$BlockFlag = ''
            [int]$SelectCount = 0
            [List[object]]$SelectedLines = [List[object]]::new()

            BlockData() { $this.Init(@{}) }

            BlockData([hashtable]$Properties) { $this.Init($Properties) }

            [void] Init([hashtable]$Properties) {
                foreach ($Property in $Properties.Keys) {
                    $this.$Property = $Properties.$Property
                }
            }
        }
    }
    
    Process{ # Pipeline values are available here
        
        $path = $MasterGen.DataPath

        try { # test that path to collections exists
            if((Test-Path -Path $path) -eq $false) {
                throw
            }
        }catch{
            Write-Error "Path specified not found"
            return
        }

        $blocks = $MasterGen.Blocks
        # prevents exception "Item has already been added" if MasterGen.Blocks already contains keys
        if ($blocks.Count -gt 0) {
            $blocks.Clear()  
        }

        $fileList = Get-ChildItem -Path $path

        foreach ($file in $fileList) { # Get data from all files in directory

            $path = $file.FullName

            # get the start and end of each block
            $startOfBlocks = Select-String -Path $path -Pattern '{' 
            $endOfBlocks = Select-String -Path $path -Pattern '}'

            # ensure that all blocks are closed with {}
            $checkClosedBlocks = { param($x, $y) $x.Count -eq $y.Count }
            try{
                if ( (&$checkClosedBlocks $startOfBlocks $endOfBlocks) -eq $false ) {
                    throw
                }
            }catch{
                Write-Error "Block not enclosed somewhere, Check here:"
                Write-Error "FilePath = $path"
                Write-Error $startOfBlocks.LineNumber
                Write-Error $endOfBlocks.LineNumber
                return
            }

            
            $data = Select-String -Path $path -Pattern '^\b|^.*\b' # grab the lines, ignoring empty lines

            # seperate data into logical blocks
            $totalBlockCount = $startOfBlocks.Count

            $i = 0; while ( $i -lt $totalBlockCount) {
       
                $selectedBlock = $data.Where( # grab data between {}, not including }
                    { ($_.LineNumber -ge ($startOfBlocks[$i].LineNumber)) -and ($_.LineNumber -lt ($endOfBlocks[$i].LineNumber)) }
                ) 

                $selectedBlock[0].Line -match "(\b.*):" | Out-Null # Fucks up the typing if not out nulled
                $blockName = $matches[1] # use regex and matches to extract block name

                $selectedBlock[0].Line -match ".*:\s*(\b.*)" | Out-Null
                $blockFlag = $($matches[1].Trim())

                $selectedBlock.RemoveAt(0) # remove BlockName line

                # select desired properties and add the lines to type list, for some reason...
                $selectedLines = [List[object]]::new() 
                $selectedLines.Capacity = 1000
                $ln = 1; foreach ($line in $selectedBlock) {
                    $z = [Tag]::new()

                    $z.Line = $($line.Line.Trim())
                    $z.OriginalLineNumber = $line.LineNumber
                    $z.HashLineNumber = $ln

                    $selectedLines.Add($z)

                    $ln++
                }

                $values = @{
                    'Tags'      = $selectedLines;
                    'BlockName' = $blockName;
                    'BlockFlag' = $blockFlag;
                    #'InputTagCounts' = 0;
                    #'SelectedLines' = $null;
                    # add other keys here, such as: 'AcceptAdj'
                }
                
                $blockValues = [BlockData]::new($values)
                $blocks.Add($blockName, $blockValues)
                $i++

            }
        }
    }
    End{ # Used for cleanup
    }
}