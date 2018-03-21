$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $here

Import-Module "$projectRoot/PsTwilio.psm1" -Force -ErrorAction Stop

Describe "Send-SmsMessage" -Tag 'integration' {

    $from = $env:TWILIO_NUMBER
    $to = Read-Host 'Telephone?'
    $message = 'Lorem ipsum'

    $sid = $env:TWILIO_ACCOUNT_SID
    $token = $env:TWILIO_AUTH_TOKEN

    # Create a credential object for HTTP basic auth
    $p = $token | ConvertTo-SecureString -asPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($sid, $p)

    Context "Valid credentials and parameter values are supplied" {

        $actual = Send-SmsMessage -From $from -To $to -Message $message -Credential $credential

        It "returns Created [201]" {
            $actual.StatusCode | Should -Be 201
        }

    }


}
