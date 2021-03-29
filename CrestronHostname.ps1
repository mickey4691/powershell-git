<#  
.SYNOPSIS  
    Updates Hostname for Crestron Devices  
.DESCRIPTION  
    This scripts looks for an Excel File with the name "DevicesIP.xlsx" that is in the current directory as the PowerShell Script/
    The Excel Document must have a sheet with name Sheet1 and must have the format with example of second row
    IP Address   Hostname   username   password
    10.0.0.1     NEW-NAME   <username> <passowrd>

    Note: The script will reboot a device. If a device has no username/password, a blank field is applicable.
    
    The Crestron PowerShell Module can be found in the link provided
      
.NOTES  
    File Name  : CrestronHostname.ps1 
    Author     : Mickey Somra  
    Requires   : Windows PowerShell ISE  
.LINK  
    https://support.crestron.com/app/answers/detail/a_id/5719/
#>

try
{
    $ExcelFile = $PSScriptRoot + "\DevicesIP.xlsx"
    $SheetName = "Sheet1"
    $objExcel = New-Object -ComObject Excel.Application
    $objExcel.Visible = $False
    $Workbook = $objExcel.Workbooks.open($ExcelFile)
    $Worksheet = $Workbook.sheets.item($SheetName)

    $IpColumn = 1
    $HostnameColumn = 2
    $UsernameColumn = 3
    $PasswordColum = 4

    #First entry prior to loop
    $CurrentRow = 2
    $ip = $Worksheet.Cells.Item($currentRow,$IpColumn).Value()
    $ip = $ip -replace '\s',''


    try
    {

        while($ip.Length -ge 7)
        {
            try
            {
                $Hostname = $Worksheet.Cells.Item($currentRow,$HostnameColumn).Value()
                $Hostname = $Hostname -replace '\s',''

                $Username = $Worksheet.Cells.Item($currentRow,$UsernameColumn).Value()
                $Username = $Username -replace '\s',''

                $Password = $Worksheet.Cells.Item($currentRow,$PasswordColum).Value()
                $Password = $Password -replace '\s',''

                try
                {
                    #  $HostnameCommand = "hostname " + $Hostname

                    Invoke-CrestronCommand -Device $ip -Command ("hostname " + $Hostname) -Password $Password -Secure -Username $Username

                    Invoke-CrestronCommand -Device $ip -Command ("reboot") -Password $Password -Secure -Username $Username
                }
                catch
                {
                    Write-Host -NoNewline $ip "has no connection"
                    Write-Output ""
                }
            }
            catch
            {
                $ErrorMessage = $_.Exception.Message
            
                Write-Output "Issue accessing or acquiring hostname, username or password" 
                Write-Output $ErrorMessage   
            }

            #Collecting Value for the next row
            $CurrentRow++
            $ip = $Worksheet.Cells.Item($currentRow,$IpColumn).Value()
            $ip = $ip -replace '\s',''
        }
    }
    catch
    {
        Write-Output "Something went wrong with iteration"
        $Workbook.Close($false)
        $objExcel.Quit()
        Break
    }
}
catch
{
    Write-Output "Issue Opening File or Sheet"
    Break
}

$Workbook.Close($false)
$objExcel.Quit()
