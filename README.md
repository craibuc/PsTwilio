# PsTwilio
PowerShell module to interact with Twilio's REST API

## Usage
### Send-SmsMessage

```powershell
$sid = "AC________________________________"
$token = "abcdefghijklmnopqrstuvwxyz"
$secureString = $token | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($sid, $secureString)

Send-SmsMessage -From "+16125550000" -To '+16125550001' -Message 'Testing 123' -Credential $credential
```

## Contributors

* Craig Buchanan
* [Oliver Lipkau](http://github.com/lipkau)
