$OctopusURL = "" #Octopus URL
$OctopusAPIKey = "" #Octopus API Key
$header = @{ "X-Octopus-ApiKey" = $OctopusAPIKey }

#Project to add the step
$ProjectName = ""

#File with the JSON of the new step/s
$StepFile = "$PSScriptRoot\step.json"

function Get-OctopusResource([string]$uri) {    
    return Invoke-RestMethod -Method Get -Uri "$OctopusURL/$uri" -Headers $header
}
function Put-OctopusResource([string]$uri, [object]$resource) {
    Invoke-RestMethod -Method Put -Uri "$OctopusURL/$uri" -Body $($resource | ConvertTo-Json -Depth 10) -Headers $header    
}

#Getting Project
$Project = Get-OctopusResource /api/projects/$ProjectName

#Getting Project's deployment process
$DeploymentProcess = Get-OctopusResource $Project.Links.DeploymentProcess

#Converting Json step into a PS Object. 
#If you'd rather get the step from someplace else than a file, just make sure to set the JSON as the value of $Step
$step = Get-Content $StepFile | ConvertFrom-Json

#Changing colletion to ArrayList to be able to add steps
[System.Collections.ArrayList]$Steps = $DeploymentProcess.Steps

#Adding step to ArrayList collection. The step will be added to the bottom.
$Steps.Add($Step)

#If you want to re-order the steps, you should do it here on $steps

#Adding new steps array to Deployment process
$DeploymentProcess.Steps = $Steps

#Saving Deployment process to database
Put-OctopusResource -uri $DeploymentProcess.Links.Self -resource $DeploymentProcess
