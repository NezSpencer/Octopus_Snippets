#all offline machines of the instance
$OfflineMachines = Get-OctopusMachine | ?{$_.status -eq "offline"}

#Offline machines by environment. See the rest of the filters of this cmdlet on https://github.com/Dalmirog/OctoPosh/wiki/Get-OctopusMachine
#$OfflineMachines = Get-OctopusMachine -EnvironmentName "Development" | ?{$_.status -eq "offline"}

Remove-OctopusResource -Resource $OfflineMachines.resource -Wait #add -force to avoid prompt.