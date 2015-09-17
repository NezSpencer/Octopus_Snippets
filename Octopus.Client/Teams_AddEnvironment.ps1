Add-Type -Path "Newtonsoft.Json.dll"
Add-Type -Path "Octopus.Client.dll"

$OctopusURL = ""#Your Octopus URL
$OctopusAPIKey = "" #Your Octopus API Key

$TeamName = ""#Name of the team to which you want to add the environments
$EnvironmentName = ""#Environment you want to add

$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURL,$OctopusAPIKey    
$repository = new-object Octopus.Client.OctopusRepository $endpoint                     

$team = $repository.Teams.FindByName($TeamName)
$team.EnvironmentIds.Add($EnvironmentName)

$repository.Teams.Modify($team)
