﻿#Requires -Version 3.0 -Modules ActiveDirectory
#Domain functions (Beta*)

#Import modules needed
if (-not (get-module -Name ActiveDirectory)) {
 import-module -Name ActiveDirectory -ErrorAction Stop -Scope Global
 Write-Verbose "ActiveDirectory module loaded"
} else {
 Write-Verbose "ActiveDirectory module already loaded"
}

Function Connect-DomainDrive {
 Param (
  [Parameter(Mandatory=$true,Position=1)]
  [string]$Domain,
  [Parameter(Position=2)]
  [string]$Server = $Domain,
  [System.Management.Automation.CredentialAttribute()]$Credential,
  [switch]$Force = $false
 )
 $customParam = @{}
 if ($Credential) {$customParam["Credential"] = $Credential}
 $DomainDrive = Get-PSDrive $Domain -ErrorAction SilentlyContinue
 $CreateDomainDrive = $false
 if ($DomainDrive.Provider.Name -eq "ActiveDirectory") {
  Write-Verbose "Domain already connected"
  if ($Force) {
   $CreateDomainDrive = $false
   Write-Verbose "Force option used, reconecting"
   Disconnect-DomainDrive -Domain $Domain
  } else {
   Write-Verbose "Trying reconnect to existent Drive"
  }
 } elseif ($DomainDrive -and $DomainDrive.Provider -ne "ActiveDirectory") {
  Write-Verbose "Drive in use"
  Write-Warning "Drive in use"
  $CreateDomainDrive = $false
  break
 } else {
  $CreateDomainDrive = $true
 }
 if ($CreateDomainDrive) {
  New-PSDrive -Name $Domain -PSProvider ActiveDirectory -Root "" -Server $Server @customParam -Scope Global
 }
 Set-Location "$Domain`:"
}

Function Disconnect-DomainDrive {
 Param (
  [Parameter(Mandatory=$true,Position=1)]
  [string]$Domain,
  [switch]$Force = $false
 )
 $DomainDrive = Get-PSDrive $Domain -ErrorAction SilentlyContinue
 if (-not $DomainDrive){
  Write-Verbose "Drive not in use"
  Write-Warning "Drive not in use"
  break
 } elseif ($DomainDrive.Provider.Name -ne "ActiveDirectory") {
  Write-Verbose "Non a DomainDrive"
  Write-Warning "Non a DomainDrive"
  break
 }
 Set-Location $env:HOMEDRIVE
 Remove-PSDrive -Name $Domain -PSProvider ActiveDirectory -Scope Global -Force:$Force
 if (-not (Get-PSDrive $Domain -ErrorAction SilentlyContinue)){Write-Verbose "DomainDrive $domain disconnected"}
}


