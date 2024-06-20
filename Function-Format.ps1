function cmdlet {
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
            [Parameter(Mandatory=$true)]
                [string]$Path,
            [Parameter(Mandatory=$false)]
                [int]$Seed
            #[Parameter(Position=0)]
                #[int]$var
            #[Parameter(Mandatory=$false)]
                #[switch]$Quiet
            #[Parameter(Mandatory,HelpMessage="")]
                #@[string[]]$ComputerName
            #[Parameter(Mandatory)]
                #[Alias("CN","MachineName")]
                #[string[]]$ComputerName
            #[Parameter()]
                #[System.Management.Automation.Credential()]
                #[PSCredential]$Credential
            #[Parameter(Position=1, ValueFromRemainingArguments)]
                #[string[]]$Remaining
            #[PSDefaultValue(Help='Current directory')]
                #[string]$Name = $PWD.Path
            #[Parameter(Mandatory)]
                #[SupportsWildcards()]
                #[string[]]$Path
            # just look the rest up
            # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#attributes-of-parameters
            #dynamicparam{}
        )
    
        Begin{ # Pipeline values are not available yet
             # This block is used to provide optional one-time preprocessing for the function. The PowerShell runtime uses the code in this block once for each instance of the function in the pipeline.      
        }
        
        Process{ # Pipeline values are available here
    
        }
        End{ # Used for cleanup
    
        }
    }