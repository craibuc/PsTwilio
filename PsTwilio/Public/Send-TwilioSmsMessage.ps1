<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER From
The telephone number associated with the Twilio account

.PARAMETER To
The SMS telephone number of the recipient

.PARAMETER Message
The message to be sent

.PARAMETER Credential
A PsCredential generated from the SID and token associated with the Twilio account

.EXAMPLE

PS> $sid = "AC________________________________"
PS> $token = "abcdefghijklmnopqrstuvwxyz"
PS> $secureString = $token | ConvertTo-SecureString -asPlainText -Force
PS> $credential = New-Object System.Management.Automation.PSCredential($sid, $secureString)

PS> Send-SmsMessage -From "+16125550000" -To '+16125550001' -Message 'Testing 123' -Credential $credential

.NOTES
https://www.twilio.com/docs/guides/how-to-make-http-basic-request-twilio-powershell

#>
function Send-TwilioSmsMessage
{

    [CmdletBinding()]
    param(
        [string]$From,
        [string]$To,
        [string]$Message,
        [PSCredential]$Credential
    )
    begin {

        $sid = $Credential.UserName
        $url = "https://api.twilio.com/2010-04-01/Accounts/$sid/Messages.json"

    }
    process {
        # foreach ($T in $Telephone) {

            $body = @{ From = $From; To = $To; Body = $Message}

            try {
                $response = Invoke-WebRequest -Uri $url -Method Post -Body $body -Credential $credential -UseBasicParsing
                $response    
            }
            catch {

                if ( $_.Exception.Response.StatusCode -eq [System.Net.HttpStatusCode]::BadRequest) {

                    # convert error details in Json to a PsCustomObject
                    $errorDetails = ($_.ErrorDetails.Message | ConvertFrom-Json)

                    switch ($errorDetails.code) {
                        20003 { 
                            # Throw "Invalid SID or token [20003]"
                            Write-Error "Invalid SID or token [20003]"
                            return
                        }
                        21211 { 
                            # Throw "Invalid 'To' number [21211]"
                            Write-Error "Invalid 'To' number [21211]"
                            return
                        }
                        21212 { 
                            # Throw "Invalid 'From' Number [21212]"
                            Write-Error "Invalid 'From' Number [21212]"
                            return
                        }
                        21602 { 
                            # Throw "Message body is required [21602]"
                            Write-Error "Message body is required [21602]"
                            return
                        }
                        Default {
                            # Throw "$errorDetails.message [$errorDetails.code]"
                            Write-Error "$message [$code]"
                            return 
                        }
                    }
                }
                else {
                    # Throw $_.ErrorDetails.Message
                    Write-Error $_.ErrorDetails.Message
                    return
                }
            }

        # }
    }
    end {}

}
