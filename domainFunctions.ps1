#Requires -Version 3.0 -Modules ActiveDirectory
#Domain functions (alpha*)

Function Connect-DomainDrive {
 Param (
  [Parameter(Mandatory=$true,Position=1)]
  [string]$Domain,
  [string]$Server = $Domain,
  [pscredential]$Credential = $(Get-Credential),
  [switch]$Force = $false
 )
 $DomainDrive = Get-PSDrive "$Domain" -ErrorAction SilentlyContinue
 if ($DomainDrive.Provider -eq "ActiveDirectory") {
  Write-Verbose "Domain already connected"
  if (-not $Force) {$CreateDomainDrive = $false; Write-Verbose "Force option used, reconecting"}
 } elseif ($DomainDrive) {
  Write-Warning
 }

 if ($CreateDomainDrive) {
  New-PSDrive -Name $Domain -PSProvider ActiveDirectory -Root "" -Server $Server -Credential $Credential -Scope Global
 }


}

Function Disconnect-Domain{}


