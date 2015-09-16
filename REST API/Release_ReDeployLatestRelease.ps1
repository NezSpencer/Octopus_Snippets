#This code snippet will re-deploy the latest release that was deployed to an environent.
#If you choose "Production" and the latest release deployed to that environment was 1.0.0, then it will redeploy 1.0.0 to "Production".

###CONFIG###

$apiKey = "" #Octopus API Key
$OctopusURL = "" #Octopus URL 
$ProjectName = "" #project name
$EnvironmentName = "" #environment name

$Header =  @{ "X-Octopus-ApiKey" = $apiKey }

###START###
 
#Getting Environment and Project By Name
$Project = Invoke-WebRequest -Uri "$OctopusURL/api/projects/$ProjectName" -Headers $Header| ConvertFrom-Json 
$Environment = Invoke-WebRequest -Uri "$OctopusURL/api/Environments/all" -Headers $Header| ConvertFrom-Json 
$Environment = $Environment | ?{$_.name -eq $EnvironmentName}

#Getting latest release Id
$Dashboard = Invoke-WebRequest -Uri "$OctopusURL/api/dashboard" -Headers $Header | ConvertFrom-Json
$LatestReleaseId = $Dashboard.Items | ?{($_.projectid -eq $Project.Id) -and ($_.EnvironmentId -eq $Environment.Id)} | select -ExpandProperty ReleaseId

#Creating deployment body using latest release ID
$DeploymentBody = @{ 
            ReleaseID = $LatestReleaseId #<- Latest Release ID
            EnvironmentID = $Environment.id           
          } | ConvertTo-Json

#Creating deployment
$deployment = Invoke-WebRequest -Uri $OctopusURL/api/deployments -Method Post -Headers $Header -Body $DeploymentBody

$deployment
