#Requires -Version 3.0 -Modules ActiveDirectory
#Domain functions (alpha)
#Experimental


Function Connect-Domain {
 Param (
  [Parameter(Mandatory=$true,Position=1)]
  [string]$Domain,
  [string]$Server = $Domain,
  [pscredential]$Credential = $(Get-Credential),
  [switch]$Force = $false
 )
 echo "
 
 Dominio : $Domain
 Servidor : $Server
 Credencial : $($Credential.username)
 Force : $Force
 "
 

}

Function Disconnect-Domain{}


