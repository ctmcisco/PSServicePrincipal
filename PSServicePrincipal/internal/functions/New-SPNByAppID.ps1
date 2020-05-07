﻿Function New-SPNByAppID
{
    <#
        .SYNOPSIS
            Cmdlet for creating single object Service Principal objects

        .DESCRIPTION
            This function will create a single object Service Principal object

        .PARAMETER RegisteredApp
            This parameter is a switch used to create an Azure Registered Application.

        .PARAMETER CreateSPNWithPassword
            This parameter is a switch used when a user supplied password is passed in.

        .PARAMETER ApplicationID
            This parameter is the id of the Azure tenant you are working in.

        .PARAMETER DisplayName
            This parameter is the display name of the object we are working on.

        .EXAMPLE
            PS c:\> Connect-SPNByAppID

            These objects will be used to make a connection to an Azure tenant or reconnect to another specified tenant
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [OutputType('System.Collections.ArrayList')]
    [CmdletBinding()]
    param(
        [switch]
        $RegisteredApp,

        [switch]
        $CreateSPNWithPassword,

        [string]
        $ApplicationID,

        [string]
        $DisplayName
    )

    try
    {
        if($RegisteredApp -and $ApplicationID)
        {
            # Registered Application needs ApplicationID
            $password = [guid]::NewGuid()
            $securePassword = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property @{ StartDate = Get-Date; EndDate = Get-Date -Year 2024; Password = $password}
            New-AzADServicePrincipal -ApplicationId $ApplicationID -PasswordCredential $securePassword -ErrorAction Stop -ErrorVariable ProcessError
            Write-PSFMessage -Level Host -Message "Created new SPN with ApplicationID: {0}" -Format $ApplicationID -FunctionName "Internal"
            $script:appCounter ++
            return
        }
        elseif($CreateSPNWithPassword -and $DisplayName)
        {
            $password = Read-Host "Enter Password" -AsSecureString
            $securePassword = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property @{ StartDate = Get-Date; EndDate = Get-Date -Year 2024; Password = $password}
            if($newSPN = New-AzADServicePrincipal -DisplayName $DisplayName -PasswordCredential $securePassword -ErrorAction Stop -ErrorVariable ProcessError)
            {
                Write-PSFMessage -Level Host -Message "SPN created: DisplayName: {0} - Secure Password present {1}" -Format $newSPN.DisplayName, $newSPN.securePassword -FunctionName "Internal"
                $script:roleListToProcess.Add($newSpn)
                $script:spnCounter ++
            }

            return
        }
        elseif($DisplayName)
        {
            # Enterprise Application (Service Principal) needs display name because it creates the pair
            if($newSpn = New-AzADServicePrincipal -DisplayName $DisplayName -ErrorAction Stop -ErrorVariable ProcessError)
            {
                Write-PSFMessage -Level Host -Message "Created new SPN with DisplayName: {0}" -Format $DisplayName -FunctionName "Internal"
                $script:roleListToProcess.Add($newSpn)
                $script:spnCounter ++
            }

            return
        }
    }
    catch
    {
        if($ProcessError)
        {
            Write-PSFMessage -Level Warning "{0}" -StringValues $ProcessError.ErrorRecord.Exception -FunctionName "Internal"
        }
        else
        {
            Stop-PSFFunction -Message "WARNING" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
        }

        return
    }
}