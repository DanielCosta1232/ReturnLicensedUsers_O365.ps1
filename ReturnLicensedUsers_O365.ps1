<# 
NOTE: To disconnect just close the PowerShell window. Currently there is no disconnect cmdlet for Connect-MSolService.

Due to the usage of the MSOnline cmdlet, you will need the MSOnline module. It is automatically installed via the script.
If you return any errors, ensure that scripting is enabled on the machine. Then rerun the script
Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#>

function CheckModuleMSOL {
  Write-Host "Checking for MSOnline Module..."
  if (Get-Module -ListAvailable | ? {$_.name -eq "MSonline"}) {
    Write-Host "MSOnline Module is already installed. Importing..." 
    Import-Module MSOnline
    Write-Host "Done!"
  }
  else {
    Write-Host "MSOnline Module is not installed. Installing..."
    Install-Module MSOnline
    Import-Module MSOnline
    Write-Host "Done!"
  }
}

# Script starts here
$WindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($WindowsID)
$AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if ($WindowsPrincipal.IsInRole($AdminRole)) {
    CheckModuleMSOL
    Write-Host "Please enter your credentials when prompted."
    Sleep -s 5
    Connect-MsolService
    $path = Read-Host "Please enter a path and name for the output .csv file. Use quotes for spaces. (example syntax: C:\Users\temp\userlogs.csv)"
    $i = Read-Host "`nPlease enter a number from the following 2 options.`n1.Return licensed users.`n2.Return unlicensed users.`n"
    if ($i -eq 1){
      $licensed = Get-MsolUser -All | where {$_.isLicensed -eq $true}
      $licensed | Select UserPrincipalName,DisplayName,isLicensed | Export-CSV -Path $path
    }
    elseif ($i -eq 2){
      $unlicensed = Get-MsolUser -All | where {$_.isLicensed -eq $false}
      $unlicensed | Select UserPrincipalName,DisplayName,isLicensed | Export-CSV -Path $path
    }
    #### modify the 'Select' elements to return relevant info for easier parsing
    Write-Host "`nDone! Please check $path for your .csv file.`nNote: Due to Connect-MSOLService not having a disconnect cmdlet, you will need to close this PowerShell window to disconnect.`n"
}
else {
    Write-Host "`nPlease run this script in an elevated PowerShell window."
}