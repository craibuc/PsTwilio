@(
    "$PSScriptRoot\Public\*.ps1"
    # ",$PSScriptRoot\Private\*.ps1"
) | Get-ChildItem |
    ForEach-Object {

        Try {
            Write-Debug "Dot sourcing $($_.FullName)"
            . $_
        }
        Catch {
            Write-Error -Message "Failed to import function $($_.FullName): $_"
        }

    }
