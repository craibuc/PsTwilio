function New-ErrorRecord
{
    param (
        [string]$statusCode,
        [string]$errorDetails
    )

    Write-Debug "New-ErrorRecord"

    $response = New-Object System.Net.Http.HttpResponseMessage $statusCode
    $exception = New-Object Microsoft.PowerShell.Commands.HttpResponseException "$statusCode ($($response.ReasonPhrase))", $response

    $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
    
    $errorID = 'WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWebRequestCommand'
    $targetObject = $null
    
    $errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
    $errorRecord.ErrorDetails = $errorDetails
    $errorRecord

}