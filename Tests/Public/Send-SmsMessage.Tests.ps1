# $here = Split-Path -Parent $MyInvocation.MyCommand.Path

Import-Module PsTwilio -Force -ErrorAction Stop

InModuleScope PsTwilio {

    $here = Resolve-Path "./Tests"
    Write-Debug "here: $here"
    . "$here/Helpers.ps1"

    Describe "Send-SmsMessage" -Tag 'unit' {

        $from = '+16125550000'
        $to = '+16125551212'
        $message = 'lorem ipsum'

        $p = "abcdefghijklmnopqrstuvwxyz" | ConvertTo-SecureString -asPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential("AC______________________", $p)
    
        Context "Valid credentials and parameter values are supplied" {
    
            Mock Invoke-WebRequest { return [PsCustomObject]@{StatusCode = 201} }

            $actual = Send-SmsMessage -From $from -To $to -Message $message -Credential $credential
    
            It "returns Created [201]" {
                $actual.StatusCode | Should -Be 201
    
                Assert-MockCalled "Invoke-WebRequest" -Exactly 1
            }
    
        } # /Context

        Context "Invalid From number supplied" {
    
            Mock Invoke-WebRequest { 
                $message =  '{"code": 21212, "message": "The ''From'' number is not a valid phone number, shortcode, or alphanumeric sender ID.", "more_info": "https://www.twilio.com/docs/errors/21212", "status": 400}'
                $errorRecord = New-ErrorRecord 400 $message
                Throw $errorRecord
            }
    
            It "throws 'Invalid 'From' Number [21212]'" {
                { Send-SmsMessage -From 'FROM' -To $to -Message $message -Credential $credential -ErrorAction Stop } | Should -Throw "Invalid 'From' number [21212]"
    
                Assert-MockCalled "Invoke-WebRequest" -Exactly 1
            }
            
        } # /Context

        Context "Invalid To number supplied" {
    
            Mock Invoke-WebRequest { 
                $message = '{"code": 21211, "message": "The ''To'' number is not a valid phone number.", "more_info": "https://www.twilio.com/docs/errors/21211", "status": 400}'
                $errorRecord = New-ErrorRecord 400 $message
                Throw $errorRecord
            }
    
            It "throws 'Invalid 'To' number [21211]'" {
                { Send-SmsMessage -From $from -To 'TO' -Message $message -Credential $credential -ErrorAction Stop } | Should -Throw "Invalid 'To' number [21211]"
    
                Assert-MockCalled "Invoke-WebRequest" -Exactly 1
            }
        
        } # /Context

        Context "Message parameter not supplied" {
    
            Mock Invoke-WebRequest { 
                $message = '{"code": 21602, "message": "Message body is required.", "more_info": "https://www.twilio.com/docs/errors/21602", "status": 400}'
                $errorRecord = New-ErrorRecord 400 $message
                Throw $errorRecord
            }
    
            It "throws 'Message body is required [21602]'" {
                { Send-SmsMessage -From  $from -To $to -Message $null -Credential $credential -ErrorAction Stop } | Should -Throw "Message body is required [21602]"
    
                Assert-MockCalled "Invoke-WebRequest" -Exactly 1
            }
        } # /Context
    
        Context "Invalid credentials are suppled" {
    
            Mock Invoke-WebRequest { 
                $message = '{"code": 20003, "message": "Your AccountSid or AuthToken was incorrect.", "more_info": "https://www.twilio.com/docs/errors/20003", "status": 400}'
                $errorRecord = New-ErrorRecord 400 $message
                Throw $errorRecord
            }
    
            It "throws 'Invalid SID or token [20003]'" {
                { Send-SmsMessage -From $from -To $to -Message $message -Credential $null -ErrorAction Stop } | Should -Throw "Invalid SID or token [20003]"
    
                Assert-MockCalled "Invoke-WebRequest" -Exactly 1
            }
        } # /Context

    } # /Describe

} # /InModuleScope
