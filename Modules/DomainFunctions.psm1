#Requires -Version 3.0 -Modules ActiveDirectory
#Domain functions (beta)

Function Connect-DomainDrive {
 Param (
  [Parameter(Mandatory=$true,Position=1)]
  [string]$Domain,
  [string]$Server = $Domain,
  [pscredential]$Credential = $(Get-Credential),
  [switch]$Force = $false
 )
 $DomainDrive = Get-PSDrive $Domain -ErrorAction SilentlyContinue
 $CreateDomainDrive = $false
 if ($DomainDrive.Provider -eq "ActiveDirectory") {
  Write-Verbose "Domain already connected"
  if (-not $Force) {
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
  New-PSDrive -Name $Domain -PSProvider ActiveDirectory -Root "" -Server $Server -Credential $Credential -Scope Global
 }


}

Function Disconnect-Domain {
 Param (
  [Parameter(Mandatory=$true,Position=1)]
  [string]$Domain,
  [switch]$Force = $false
 )
 $DomainDrive = Get-PSDrive $Domain
 if (-not $DomainDrive){
  Write-Verbose "Drive not in use"
  break
 } elseif ($DomainDrive.Provider -ne "ActiveDirectory") {
  Write-Verbose "Non a DomainDrive"
  Write-Warning "Non a DomainDrive"
  break
 }
 Remove-PSDrive -Name $Domain -PSProvider ActiveDirectory -Scope Global -Force:$Force
}


