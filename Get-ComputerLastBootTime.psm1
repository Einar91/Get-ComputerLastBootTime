<#
.SYNOPSIS
The template gives a good starting point for creating powershell functions and tools.
Start your design with writing out the examples as a functional spesification.
.DESCRIPTION
.PARAMETER
.EXAMPLE
#>

function Get-ComputerLastBootTime {
    [CmdletBinding()]
    #^ Optional ..Binding(SupportShouldProcess=$True,ConfirmImpact='Low')
    param (
    [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True)]
    [Alias('CN','MachineName','HostName','Name')]
    [string[]]$ComputerName
    )

BEGIN {
    $FailedConnections = @()
}

PROCESS {
    Get-CimInstance -ComputerName $ComputerName -ClassName win32_operatingsystem -ErrorAction SilentlyContinue -ErrorVariable ConnectionError | 
        Select-Object @{l='ComputerName';e={$_.CSName}},@{l='LastBootupTime';e={$_.LastBootUpTime}}`
    
    if($ConnectionError){
        $Failed = ($ConnectionError.origininfo.PSComputerName).ToUpper()
        foreach($fail in $failed){
            $FailedConnection = New-Object psobject
            $FailedConnection | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $fail
            $FailedConnection | Add-Member -MemberType NoteProperty -Name "LastBootupTime" -Value "Connection to remote computer failed."
            $FailedConnections += $FailedConnection
        } #Foreach

        $FailedConnections
    } # IF
}


END {
    # Intentionaly left empty.
    # This block is used to provide one-time post-processing for the function.
}

} #Function