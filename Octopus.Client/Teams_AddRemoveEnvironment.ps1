#You can these 2 dlls from your Octopus Server/Tentacle install dir or from
#https://www.nuget.org/packages/Octopus.Client/3.1.0-beta0002
#https://www.nuget.org/packages/Newtonsoft.Json/

Add-Type -Path "Newtonsoft.Json.dll" 
Add-Type -Path "Octopus.Client.dll" 

$OctopusURL = ""#Your Octopus URL
$OctopusAPIKey = "" #Your Octopus API Key

$TeamName = ""#Name of the team to which you want to add/remove the environments
$EnvironmentName = ""#Environment you want to add/remove

$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURL,$OctopusAPIKey    
$repository = new-object Octopus.Client.OctopusRepository $endpoint                     

$team = $repository.Teams.FindByName($TeamName)
$Environment = $repository.Environments.FindByName($EnvironmentName)

$team.EnvironmentIds.Add($Environment.id) #<-- To add environment
#$team.EnvironmentIds.Remove($Environment.id) #<-- To remove environment

$repository.Teams.Modify($team) #<-- Save changes on the database
