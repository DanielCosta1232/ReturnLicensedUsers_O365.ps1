### ReturnLicensedUsers_O365.ps1
The script prompts 1 of 2 options (licensed or unlicensed) and exports a list to a .csv file at the path specificed.

#### NOTE: 
To disconnect just close the PowerShell window. Currently there is no disconnect cmdlet for Connect-MSolService.

#### Additional Notes:
Due to the usage of the MSOnline cmdlet, you will need the MSOnline module. It is automatically installed via the script.
If you return any errors, ensure that scripting is enabled on the machine.

- Get-ExecutionPolicy -Scope CurrentUser
- Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

Then rerun the script.
