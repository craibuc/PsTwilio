# PsTwilio
PowerShell module to interact with Twilio's REST API

## Usage
### Get-TwilioSmsMessage

```powershell
$sid = "AC________________________________"
$token = "abcdefghijklmnopqrstuvwxyz"
$secureString = $token | ConvertTo-SecureString -AsPlainText
$Credential = [PSCredential]::new($sid, $secureString)

Get-SmsMessage -Credential $Credential
```

### Send-TwilioSmsMessage

```powershell
$sid = "AC________________________________"
$token = "abcdefghijklmnopqrstuvwxyz"
$secureString = $token | ConvertTo-SecureString -AsPlainText
$Credential = [PSCredential]::new($sid, $secureString)

Send-SmsMessage -From "+16125550000" -To '+16125550001' -Message 'Testing 123' -Credential $Credential
```

## Contributors

* Craig Buchanan
* [Oliver Lipkau](http://github.com/lipkau)
