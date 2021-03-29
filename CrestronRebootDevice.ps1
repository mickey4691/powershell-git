<#  
.SYNOPSIS  
    Reboots Crestron Scheduling Panels  
.DESCRIPTION  
    This script will read through an array of IPs and invoke the console command for reboot 
      
.NOTES  
    File Name  : CrestronRebootSchedulingPanels.ps1 
    Author     : Mickey Somra  
    Requires   : Windows PowerShell ISE, Crestron EDK  
.LINK  
    https://support.crestron.com/app/answers/detail/a_id/5719/
#>

#Array of Devices
$IPs = @('172.30.20.53', '172.30.20.57', '172.30.20.58', '172.30.20.54', '172.30.20.55', '172.30.22.44')

#region File Creation
$DateTime = Get-Date -UFormat "%m/%d/%Y %R:"
$DateTime = $DateTime.Replace('/','-')
$DateTime = $DateTime.Replace(':','-')
$global:FileName = "SchedulingPanelStatus " + $DateTime

Out-File -FilePath $PSScriptRoot\$FileName.txt
#endregion File Creation

// create an IpV4 Regex match format
$IpV4RegEx = '^(([0-9]|[0-9][0-9]|1[0-9][0-9]|[0-2][0-9][0-5]).([0-9]|[0-9][0-9]|1[0-9][0-9]|[0-2][0-9][0-5]).([0-9]|[0-9][0-9]|1[0-9][0-9]|[0-2][0-9][0-5]).([0-9]|[0-9][0-9]|1[0-9][0-9]|[0-2][0-9][0-5]))$'

foreach ($deviceIp in $IPs)
{
    // validate user info data matches regex formatting.
    if ($deviceIp -match $ipV4RegEx)
    {
        Try
        {
            $RebootStatus = Invoke-CrestronCommand -Device $deviceIp -Command reboot | Out-String

            if ($RebootStatus = "Rebooting system.  Please wait")
            {
                $InfoLine = $deviceIp + "`t`t" + "rebooting" 
                #Write-Output $InfoLine
                Add-Content $PSScriptRoot\$FileName.txt $InfoLine 
            }
            else
            {
                $InfoLine = $deviceIp + "`t`t" + "has no response" 
                #Write-Output $InfoLine
                Add-Content $PSScriptRoot\$FileName.txt $InfoLine 
            }
              
        }
        Catch
        {
            $InfoLine = $deviceIp + "`t`t" + "has no communication" 
            #Write-Output $InfoLine
            Add-Content $PSScriptRoot\$FileName.txt $InfoLine            
        }
    }
    else
    {
        $InfoLine = $deviceIp + "`t`t" + "is not in the right format." 
        #Write-Output $InfoLine
        Add-Content $PSScriptRoot\$FileName.txt $InfoLine
    }
}