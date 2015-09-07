#Connection Info
$OctopusAPIKey = "" #Your API KEy
$OctopusURL = "" #Your Octopus Server URL

$header = @{ "X-Octopus-ApiKey" = $OctopusAPIKey }

#Module Name and Powershell Script
$ModuleName = "MyNewTemplateName"
$ModuleScript = "write-host 'hello world!'"


#Getting if module already exists, and if it doesnt, create it
$Modules = Invoke-WebRequest $OctopusURL/api/LibraryVariableSets -Method GET -Headers $header | select -ExpandProperty content | ConvertFrom-Json
$ScriptModule = $Modules.Items | ?{$_.name -eq $ModuleName}

If($ScriptModule -eq $null){
    
    $SMBody = [PSCustomObject]@{
        ContentType = "ScriptModule"
        Name = $ModuleName
    } | ConvertTo-Json

    $Scriptmodule = Invoke-WebRequest $OctopusURL/api/LibraryVariableSets -Method POST -Body $SMBody -Headers $header | select -ExpandProperty content | ConvertFrom-Json    
}

#Getting the library variable set asociated with the module
$Variables = Invoke-WebRequest $OctopusURL/$($Scriptmodule.Links.Variables) -Headers $header | select -ExpandProperty content | ConvertFrom-Json

#Creating/updating the variable that holds the Powershell script
If($Variables.Variables.Count -eq 0)
{
    $Variable = [PSCustomObject]@{   
        Name = "Octopus.Script.Module[$Modulename]"    
        Value = $ModuleScript #Powershell script goes here
    }

    $Variables.Variables += $Variable

    $VSBody = $Variables | ConvertTo-Json -Depth 3
}
else{    
    $Variables.Variables[0].value = $ModuleScript #Updating powershell script
    $VSBody = $Variables | ConvertTo-Json -Depth 3    
}

#Updating the library variable set
Invoke-WebRequest $OctopusURL/$($Scriptmodule.Links.Variables) -Headers $header -Body $VSBody -Method PUT | select -ExpandProperty content | ConvertFrom-Json
