﻿Function New-ServicePrincipalObject
{
    <#
    .SYNOPSIS
        Cmdlet for creating a new azure active directory Service Principal.

    .DESCRIPTION
        This function will create a new azure active directory Service Principal.
        All messages are logged by default to the following folder [[Environment]::GetFolderPath("MyDocuments") "\PowerShell Script Logs"].
        For more information please visit: https://psframework.org/
        PSFramework Logging: https://psframework.org/documentation/quickstart/psframework/logging.html
        PSFramework Configuration: https://psframework.org/documentation/quickstart/psframework/configuration.html
        PSGallery - PSFramework module - https://www.powershellgallery.com/packages/PSFramework/1.0.19

    .PARAMETER EnableException
        This parameter disables user-friendly warnings and enables the throwing of exceptions.
        This is less user friendly, but allows catching exceptions in calling scripts.

    .PARAMETER Reconnect
        This parameter switch is used when forcing a new connection to an Azure tenant subscription.

    .PARAMETER CreateSingleSPN
        This switch is used when creating a single default Service Principal.

    .PARAMETER CreateBatchSPNS
        This switch is used when creating a batch of Service Principals from a text file.

    .PARAMETER CreateSPNWithAppId
        This switch is used when creating a Service Principal and a registered Azure application.

    .PARAMETER CreateSPNWithPassword
        This switch is used when creating a Service Principal and a registered Azure application with a user supplied password.

    .PARAMETER CreateSPNsWithNameAndCert
        This switch is used when creating a Service Principal and a registered Azure application using a display name certificate.

    .PARAMETER GetSPNByName
        This switch is used to retrieve a Service Principal object from the Azure active directory via display name.
    
    .PARAMETER GetSPNByAppID
        This switch is used to retrieve a Service Principal object from the Azure active directory via application id.
    
    .PARAMETER GetSPNSByName
        This switch is used to retrieve a batch of Service Principal objects via wildcard search from the Azure active directory.
    
    .PARAMETER GetAppAndSPNPair
        This switch is used to retrieve an Application and Service Principal pair from the Azure active directory.

    .PARAMETER NameFile
        This parameter is the name of the file that contains the list of Service Principals being passed in for creation.

    .PARAMETER ApplicationID
        This parameter is the unique application id for a Service Principal in a tenant. Once created this property cannot be changed.

    .PARAMETER DisplayName
        This parameter is the friendly name of the Service Principal you want to create.

    .PARAMETER Certificate
        This parameter is the value of the "asymmetric" credential type. It represents the base 64 encoded certificate.

    .PARAMETER TenantId
        This parameter is the Azure tenant you are connecting to.

    .PARAMETER SubscriptionId
        This parameter is that Azure subscription you are connecting to.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -CreateSingleSPN

        This example connects to an Azure tenant and created a single Service Principal object with default values
    
    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -CreateSingleSPN -Name CompanySPN

        This example creates a new Service Principal with a display name of 'CompanySPN' and password (an autogenerated GUID) and creates the Service Principal based on the application just created. The start date and end date are added to password credential.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -CreateSingleSPN -CreateSPNWithPassword -Name CompanySPN

        This example creates a new Service Principal with a display name of 'Your SPNs Name' and password (user supplied password) and creates the Service Principal based on the application just created. The start date and end date are added to password credential.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -CreateBatchSPNS -NameFile c:\temp\Namefile.txt

        This example connects to an Azure tenant with an Azure account and creates a batch of Service Princpial objects from a file passed in.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -CreateSPNWithAppId -ApplicationID 34a23ad2-dac4-4a41-bc3b-d12ddf90230e

        This example creates a new Service Principal with the application id '34a23ad2-dac4-4a41-bc3b-d12ddf90230e'.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -CreateSPNsWithNameAndCert -Name CompanySPN -Certificate <public certificate as base64-encoded string>

        This example creates a new Service Principal with a display name of 'Your SPNs Name' and certifcate and creates the Service Principal based on the application just created. The end date is added to key credential.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -Reconnect -Tenant 679fa186-5871-43a8-aje5-b20c66a3a6b4 -SubscriptionId a706cb6e-8eb1-4341-8055-f34bz3b511f8

        This example will force a reconnect to a specific Azure tenant. Useful when switching between Azure tenants. This will also make an interactive connection.
    
    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -GetSpnByName -DisplayName CompanySPN

        This example will retrieve a Service Principal from the Azure active directory by display name.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -GetSpnByAppID -ApplicationId 34a23ad2-dac4-4a41-bc3b-d12ddf90230e

        This example will retrieve a Service Principal from the Azure active directory by application id.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -GetSPNSByName -DisplayName CompanySPN

        This example will retrieve a batch of Service Principal objects from the Azure active directory by display name.
        
    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -GetAppAndSPNPair -DisplayName CompanySPN

        This example will retrieve a Service Principal and Application pair from the Azure active directory.
    
    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -EnableException

        Creates example a new Service Principal in AAD, after prompting for user preferences.
        If this execution fails for whatever reason (connection, bad input, ...) it will throw a terminating exception, rather than writing the default warnings.

    .NOTES
        When passing in the application ID it is the Azure ApplicationID from your registered application.

        WARNING: If you do not connect to an Azure tenant when you run Import-Module Az.Resources you will be logged in interactively to your default Azure subscription.
        After signing in, you will see information indicating which of your Azure subscriptions is active.
        If you have multiple Azure subscriptions in your account and want to select a different one,
        get your available subscriptions with Get-AzSubscription and use the Set-AzContext cmdlet with your subscription ID.

        INFORMATION: The default parameter set uses default values for parameters if the user does not provide one for them.
        For more information on the default values used, please see the description for the given parameters below.
        This cmdlet has the ability to assign a role to the Service Principal with the Role and Scope parameters;
        if neither of these parameters are provided, no role will be assigned to the Service Principal.

        The default values for the Role and Scope parameters are "Contributor" and the current subscription. These roles are applid at the end
        of the Service Principal creation.

        Microsoft TechNet Documentation: https://docs.microsoft.com/en-us/powershell/module/az.resources/new-azadserviceprincipal?view=azps-3.8.0
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param(
        [switch]
        $EnableException,

        [switch]
        $Reconnect,

        [switch]
        $CreateSingleSPN,

        [switch]
        $CreateBatchSPNS,
 
        [switch]
        $CreateSPNWithAppId,

        [switch]
        $CreateSPNWithPassword,

        [switch]
        $CreateSPNsWithNameAndCert,

        [switch]
        $GetSPNByName,

        [switch]
        $GetSPNByAppID,

        [switch]
        $GetSPNSByName,

        [switch]
        $GetAppAndSPNPair,

        [string]
        $NameFile,

        [string]
        $ApplicationID,

        [string]
        $DisplayName,

        [string]
        $Certificate,

        [string]
        $TenantId,

        [string]
        $SubscriptionId
    )

    Process
    {
        $spnCounter = 0
        Write-PSFMessage -Level Host -Message "Starting Script Run"

        $parameters = $PSBoundParameters | ConvertTo-PSFHashtable -Include TenantId, SubscriptionId, Reconnect

        try
        {
            Connect-ToCloudTenant @parameters -EnableException
        }
        catch
        {
            Stop-PSFFunction -Message $_ -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
            return
        }
		
        # Try to obtain the list of names so we can batch create the SPNS
        if($NameFile -and $CreateBatchSPNS)
        {
            Write-PSFMessage -Level Host -Message "Testing access to {0}" -StringValues $NameFile

            if(-NOT (Test-Path -Path $NameFile))
            {
                Stop-PSFFunction -Message "ERROR: File problem. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
            else
            {
                Write-PSFMessage -Level Host -Message "{0} accessable. Reading in content" -StringValues $NameFile
                $listofSPNStoCreate = Get-Content $NameFile

                # Validate that we have data and if we dont we exit out
                if(0 -eq $listofSPNStoCreate.Length)
                {
                    Stop-PSFFunction -Message "Error with imported content. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                    return
                }
            }
        }
        else
        {
            #Stop-PSFFunction -Message "You must pass in a file name and use the -BatchJob parameter. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
            #return
        }

        if($CreateSingleSPN)
        {
            try
            {
                if($DisplayName -and $CreateSPNWithPassword)
                {
                    $password = Read-Host "Enter Password" -AsSecureString
                    $securePassword = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property @{ StartDate = Get-Date; EndDate = Get-Date -Year 2024; Password = $password}
                    $newSPN = New-AzADServicePrincipal -DisplayName $DisplayName -PasswordCredential $securePassword
                    Write-PSFMessage -Level Host -Message "SPN created: DisplayName: {0} - Secure Password present {1}" -Format $DisplayName, $securePassword
                    Add-RoleToSPN -spnToProcess $newSPN
                    $wantPassword = $true
                }
                elseif($DisplayName)
                {
                    $newSPN = New-AzADServicePrincipal -DisplayName $DisplayName
                    Write-PSFMessage -Level Host -Message "SPN created: DisplayName: {0} - ApplicationId: {1}" -StringValues $newSPN.DisplayName, $newSPN.ApplicationId
                }
                else
                {
                    $newSPN = New-AzADServicePrincipal
                    Write-PSFMessage -Level Host -Message "Creating a simple SPN with auto generated values"
                    $wantPassword = $true
                }

                if($wantPassword)
                {
                    # Retreive secret key for user
                    $getSecretKey = Get-PSFUserChoice -Options "Y", "N" -Caption "Would you like to retreive the secret key for this SPN? (Y or N)"

                    switch($getSecretKey)
                    {
                        0
                        {
                            $Marshal = [System.Runtime.InteropServices.Marshal]
                            $BSTR = $Marshal::SecureStringToBSTR($newSPN.Secret)
                            $secretKey = $Marshal::PtrToStringAuto($BSTR)
                            Write-PSFMessage -Level Host -Message "WARNING. This will not be written to logfile. Please write this key down and secure it: Secret Key: {0}" -StringValues $secretKey
                        }

                        1
                        {
                            return
                        }
                    }
                }
                
                $spnCounter ++
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Creating a simple SPN failed" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($CreateBatchSPNS)
        {
            try
            {
                # Check to make sure we have the list of objects to process
                if($listofSPNStoCreate)
                {
                    Write-PSFMessage -Level Host -Message "Object list DETECTED! Staring batch creation of SPN's"
                    $roleListToProcess = New-Object -TypeName "System.Collections.ArrayList"
                    foreach($spn in $listofSPNStoCreate)
                    {
                        $password = [guid]::NewGuid().Guid
                        $securityPassword = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property @{ StartDate = Get-Date; EndDate = Get-Date -Year 2024; Password = $password}
                        $newSPN = New-AzADServicePrincipal -DisplayName $spn -PasswordCredential $securityPassword -ErrorAction SilentlyContinue -ErrorVariable ProcessError

                        if($newSPN)
                        {
                            Write-PSFMessage -Level Host -Message "SPN created: DisplayName: {0} - Password: {1}" -StringValues $spn, $password
                            $roleListToProcess += $newSPN
                            $spnCounter ++
                        }
                        elseif($ProcessError)
                        {
                            Write-PSFMessage -Level Warning "$($ProcessError[0].Exception.Message) for SPN {0}" -StringValues $spn
                        }
                    }

                    if($roleListToProcess.Count -gt 0)
                    {
                        Add-RoleToSPN -spnToProcess $roleListToProcess
                    }
                }
                else
                {
                    Write-PSFMessage -Level Warning "ERROR: No list of objects found!"
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Generating PSADPasswordCredential Object with GUID. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($CreateSPNWithAppId)
        {
            try
            {
                if(-NOT $ApplicationID)
                {
                    Stop-PSFFunction -Message "ERROR: No ApplicationID specified. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet
                    return
                }
                else
                {
                    Write-PSFMessage -Level Host -Message "Creating new SPN with ApplicationID: {0}" -Format $ApplicationID
                    $newSPN = New-AzADServicePrincipal -ApplicationId $ApplicationID
                    Add-RoleToSPN -spnToProcess $newSPN
                    $spnCounter ++
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: No ApplicationID specified. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($CreateSPNsWithNameAndCert)
        {
            try
            {
                if((-NOT $Certificate) -or (-NOT $DisplayName))
                {
                    Stop-PSFFunction -Message "ERROR: No certificate or Service Principal DisplayName specified. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet
                    return
                }
                else
                {
                    Write-PSFMessage -Level Host -Message "Creating new SPN DisplayName and certificate key - DisplayName: {0}" -StringValues $newSPN.DisplayName
                    $newSPN = New-AzADServicePrincipal -DisplayName $DisplayName -CertValue $Certificate -EndDate "2024-12-31"
                    Add-RoleToSPN -spnToProcess $newSPN
                    $spnCounter ++
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: No certificate as base64-encoded string specified. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetSPNByName)
        {
            try
            {
                Get-SpnByName -DisplayName $DisplayName
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetSPNByAppID)
        {
            try
            {
                Get-SpnByAppID -ApplicationID $ApplicationID
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetSPNSByName)
        {
            try
            {
                Get-SpnsByName -DisplayName $DisplayName
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetAppAndSPNPair)
        {
            try
            {
                Get-AppAndSPNPair -DisplayName $DisplayName
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }
    }

    end
    {
        if($spnCounter)
        {
            if(0 -eq $spnCounter)
            {
                Write-PSFMessage -Level Host -Message "No SPN objects created!" -StringValues $spnCounter
            }
            elseif(1 -eq $spnCounter)
            {
                Write-PSFMessage -Level Host -Message "{0} SPN object created sucessfully!" -StringValues $spnCounter
            }
            elseif(1 -gt $spnCounter)
            {
                Write-PSFMessage -Level Host -Message "{0} SPN objects created sucessfully!" -StringValues $spnCounter
            }
        }

        Write-PSFMessage -Level Host -Message "Script run complete!"
        Write-PSFMessage -Level Host -Message 'Log saved to: "{0}". Run Get-LogFolder to retrieve the output or debug logs.' -StringValues $script:loggingFolder #-Once 'LoggingDestination'
    }
}