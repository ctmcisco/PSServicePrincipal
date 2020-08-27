﻿# Changelog

## 1.0.13 (2020-08-27)

- Upd: Updated build number to 1.0.13
- Upd: Updated help file in module and Github
- New: Added check for running as administrator. Need due to security changes in Windows version 2004 for New-SelfSignedCertificate
- New: Added process blocks to all functions
- New: Removed cert logging from main function - not needed
- New: Added tag for 'CertBasedAuth'

## 1.0.12 (2020-07-15)

- Upd: Updated help file in module and Github

## 1.0.11 (2020-05-19)

- Upd: in PSServicePrincipal.provider.ps1 - Added PSConfig variable for setting certstore location in configuration as a fall back
- Upd: in New-ServicePrincipal.ps1 - Corrected -Format to -StringValues for PSFWriteMessage variable output
- Upd: in New-ServicePrincipalObject.ps1 - Added new CBA switch, parameter and remove unneeded extra line spaces
- Upd: to New-SelfSignedCert.ps1 - Added new CBA switch and EnableExceptions switch, updated code for exchange cert exports and code to create CBA object
- Upd: documentation in Get-EnterpriseApp.ps1, Get-RegisteredApp.ps1, New-ServicePrincipalObject.ps1,
- Upd: in configuration.ps1- Added configuration code for Self-Signed Certificate save location
- Upd: in Get-EnterpriseApp, Get-RegisteredApp, Get-SpnByname, Get-SpnsByName, Get-SpnByAppID, Get-AppAndSPNPair - Added PSF-WriteLog to indicate an item was obtained for log purposes
- Upd: Changed search logic for Get-EnterpriseApp and Get-RegisteredApp to show everything based on DisplayName = *
- New: New code and functions for creating registered application with matching service principal, create self-signed cert and upload to the azure application and apply  manmage.AsApp role to application for CBA ExchV2 cmdlets
- New Removed Get-SpnByAppID.ps1, Get-SpnsByName.ps1, Remove-EnterpriseAppAndSPNPair.ps1
- New Rewrote Get-RegisteredApplication.ps1, Get-ServicePrincipalObject.ps1, Remove-ServicePrincipalObject.ps1
- New Created default custom XML table for outputting objects. Table is overridden when a user selects Format-Table (FT)
- New: Added code for stamping Exchange permissions for CBA Authentication for EXOv2 cmdlets
- Fix in Connect-ToCloudTenant.ps1 - Added code for manual Reconnect
- Fix in Get-LogFolder.ps1 - Removed $scriptlogging folder and get value from PSFConfig. We pull from PSFConfig local repository now

## 1.0.10 (2020-05-12)

- New: Added MIT license
- Upd: Updated manifest file - increment build number
- Upd: Updated manifest file - Changed RequireLicenseAcceptance = $false - Breaking PowerShellGet - reverted change
- Upd: Updated manifest file - Removed 'Get-AppByName' and added 'Get-EnterpriseApp' and 'Get-RegisteredApp'
- Upd: Updated manifest file - Added tags to manifest file: 'Application', 'Automation' 'Module' 'O365'
- Upd: Updated documentation - Added links for Azure RBAC documentation
- Upd: Updated changelog.md
- Upd: Documnetation in New-ServicePrincipalObject.ps1
- Upd: Removed internal function Get-AppByName.ps1
- Upd: Added external function Get-EnterpriseAppByName.ps1
- Upd: Added external function  Get-RegisteredAppByName.ps1
- Upd: Added counter for self-signed cert creation output
- Upd: Counter display in end of script run in New-ServicePrincipalObject.ps1
- Upd: Added new parameters GetEnterpriseApp and GetRegisteredApp in New-ServicePrincipalObject.ps1
- Upd: Changed function names from GetAppByName to GetEnterpriseApp
- Upd: Added new function for GetRegisteredApp
- Fix: Added KeyExchange for certificates. Needed for Azure CBA authentication to work
- Fix logging in New-SelfSignedCert to surpress IO.Directory output and now usign custom output from Write-PSFMessage

## 1.0.9 (2020-05-12)
 - New: Ability to create Enterprise and or tenant owned applications with service principals
 - New: New-SelfSignedCert.ps1 - Ability to create self-signed certificates to be used for (CBA) Certificate Based Authentication
 - Upd: Documentation, incremented module version. Added checks for PowerShell core as AzureAD will not work on PowerShell core.
 - Upd: Changed New-SelfSigndCert cert store from LocalMachine to CurrentUser
 - Upd: Updated parameters with regards to CBA login with AzureAD and AzureAZ
 - Upd: Added switches for CBA login
 - Fix: File save for New-SelfSignedCert