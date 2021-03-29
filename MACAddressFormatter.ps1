<#  
.SYNOPSIS  
    Reformats MAC Address  
.DESCRIPTION  
    This script converts any ipv4 MAC address into the format aabb.ccdd.eeff which is most suitable for CISCO switches.
    1. ($formattedMACA -replace '(....)','$1.').trim('.')
        This will replace every 4 characters with a . and then remove the last .
    2. ($formattedMACA -replace '(..)','$1:').trim(':')
        This will replace every 2 characters with a : and then remove the last :
      
.NOTES  
    File Name  : MACAddressFormatter.ps1  
    Author     : Mickey Somra  
    Requires   : Windows PowerShell ISE  
.LINK  
    https://en.wikipedia.org/wiki/MAC_address
#>


function FormatMacAddress
{
    $rawMACA = Read-Host -Prompt 'Enter Raw MAC Format'                    # will read raw mac address
    $formattedMACA = $rawMACA -replace '[^a-zA-Z0-9]'                      # remove non-alphanumeric characters
    $formattedMACA = $formattedMACA.ToLower()                              # convert all characters to lower case
    $formattedMACA = ($formattedMACA -replace '(....)','$1.').trim('.')    # see description format
    Write-Host 'CISCO  Formatted MAC:' $formattedMACA `n                   # write formatted output
}

$continue = 'y'

While($continue -match 'y')
{
    "`n"
    FormatMacAddress
    $continue = Read-Host 'Enter y or n to proceed'
}
