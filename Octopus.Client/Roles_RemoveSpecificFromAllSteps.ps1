Add-Type -Path "Newtonsoft.Json.dll" 
Add-Type -Path "Octopus.Client.dll" 

$OctopusURL = ""#Your Octopus URL
$OctopusAPIKey = "" #Your Octopus API Key

$projectname = "" #Name of your project
$roleToRemove = "" #WARNING -> This is case sensitive. It has to match the role in Octopus 100%

$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURL,$OctopusAPIKey    
$repository = new-object Octopus.Client.OctopusRepository $endpoint     

$project = $repository.Projects.FindByName($projectname)

$deploymentProcess = $repository.DeploymentProcesses.Get($project.DeploymentProcessId)

foreach ($step in $deploymentProcess.Steps)
{
    [System.Collections.ArrayList]$Roles = $step.Properties.'Octopus.Action.TargetRoles'.Split(",")
    If($Roles -contains $roleToRemove){
        Write-Output "Step [$($step.name)] contains role $roleToRemove. Removing it"        
        $Roles.Remove($roleToRemove)
        $step.Properties.'Octopus.Action.TargetRoles' = $Roles -join ","
    }
    else{
        Write-Output "Step [$($step.name)] does not contain role $roleToRemove"
    }    
}

$repository.DeploymentProcesses.Modify($deploymentProcess)
