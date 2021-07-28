<#
.SYNOPSIS

.PARAMETER Credential

.EXAMPLE
PS> Get-TwilioSmsMessage -Credential (Get-Credential)

.NOTE
A credential can be created without prompting

$Credential = [pscredential]::new(ACCOUNT_SID, ( AUTH_TOKEN | ConvertTo-SecureString -AsPlainText) )

#>
function Get-TwilioSmsMessage 
{
    [CmdletBinding()]
    param(
        [PSCredential]$Credential
    )

    $BaseUri = 'https://api.twilio.com'
    # $BaseUri = $MyInvocation.MyCommand.Module.PrivateData.BaseUri
    $AccountSid = $Credential.UserName

    $Uri = "$BaseUri/2010-04-01/Accounts/$AccountSid/Messages.json"
    Write-Debug "Uri: $Uri"

    try 
    {
        do
        {

            $Content = (Invoke-WebRequest -Uri $Uri -Method Get -Credential $credential).Content | ConvertFrom-Json

            # get Uri for the next set of records
            # /2010-04-01/Accounts/[SID]/Messages.json?PageSize=50&Page=1&PageToken=TOKEN
            $Uri = "{0}{1}" -f $BaseUri, $Content.next_page_uri
            Write-Debug "Uri: $Uri"
        
            # returns PsCustomObject representation of object
            if ( $Content.messages ) { $Content.messages }

            # otherwise raise an exception
            elseif ($Content.error) { Write-Error -Message $Content.error.message }

        } while ( $null -ne $Uri )
    }
    catch
    {

    }

}