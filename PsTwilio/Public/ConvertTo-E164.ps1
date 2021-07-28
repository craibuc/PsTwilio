<#
.SYNOPSIS
Convert a telephone number into E.164 format.

.PARAMETER CountryCode
Numeric, country code.  Default: 1 (US)

.PARAMETER Telephone
Subscriber number and area code

.EXAMPLE
PS> ConvertTo-E164 -Telephone "612-555-1212"
+16125551212

Default country code

.EXAMPLE
PS> ConvertTo-E164 -CountryCode 1 -Telephone "(612) 555-1212"
+16125551212

Explicit arguments

.EXAMPLE
PS> ConvertTo-E164 1 "(612) 555-1212"
+16125551212

Positional arguments

.EXAMPLE
PS> "+1612-999-2222", "612-555-1212", "(800) 555-1212" | ConvertTo-E164
+16129992222
+16125551212
+18005551212

Via the pipeline

.LINK
https://en.wikipedia.org/wiki/List_of_country_calling_codes

#>
function ConvertTo-E164
{
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [int]$CountryCode = 1,

        [Parameter(Position=1,ValueFromPipeline,Mandatory)]
        [string]$Telephone
    )

    Begin {}
    Process
    {
        # remove space, (, ), -
        $Telephone = $Telephone -replace '\s|\(|\)|-',''
        Write-Debug "Telephone: $Telephone"

        $Telephone.IndexOf('+') -gt -1 ? $Telephone : "+$CountryCode$Telephone"
    }
    End {}

}
