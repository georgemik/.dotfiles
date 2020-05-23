# type .$profile and get the path (C:\Users\<USER>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1)

function ssh-path {
 & "c:\Program Files\ps_openssh\ssh.exe"
}

Set-Alias ssha ssh-path