###CONFIG###
$apiKey = "" #Octopus API Key
$OctopusURL = "" #Octopus URL
 
$Header =  @{ "X-Octopus-ApiKey" = $apiKey }
 
$ProjectName = "" #project name

$EnvironmentName = "" #environment name

###START###
 
#Getting Environment and Project By Name
$Project = Invoke-WebRequest -Uri "$OctopusURL/api/projects/$ProjectName" -Headers $Header| ConvertFrom-Json
 
$Environment = Invoke-WebRequest -Uri "$OctopusURL/api/Environments/all" -Headers $Header| ConvertFrom-Json
 
$Environment = $Environment | ?{$_.name -eq $EnvironmentName}

#Getting Deployment Template to get Next version 
$dt = Invoke-WebRequest -Uri "$OctopusURL/api/deploymentprocesses/deploymentprocess-$($Project.id)/template" -Headers $Header | ConvertFrom-Json 
 
#Creating Release
$ReleaseBody =  @{ 
    Projectid = $Project.Id
    version = $dt.nextversionincrement #modify this line if you want to set up the version number by yourself
} | ConvertTo-Json
 
$release = Invoke-WebRequest -Uri $OctopusURL/api/releases -Method Post -Headers $Header -Body $ReleaseBody | ConvertFrom-Json
 
#Creating deployment with the specific machine IDs
$DeploymentBody = @{ 
            ReleaseID = $release.Id #mandatory
            EnvironmentID = $Environment.id #mandatory
            specificmachineIDs =  $machineIDs
          } | ConvertTo-Json
          
$deployment = Invoke-WebRequest -Uri $OctopusURL/api/deployments -Method Post -Headers $Header -Body $DeploymentBody

$deployment