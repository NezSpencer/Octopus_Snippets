Add-Type -Path "Newtonsoft.Json.dll" 
Add-Type -Path "Octopus.Client.dll" 

$OctopusURL = ""#Your Octopus URL
$OctopusAPIKey = "" #Your Octopus API Key
$Role = "" #All the machines with this role will be removed from all the environments

$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURL,$OctopusAPIKey    
$repository = new-object Octopus.Client.OctopusRepository $endpoint     

$AllMachines = $repository.repository.Machines.FindAll()

$MachinesWithRole = $AllMachines | ?{$role -in $_.roles}

foreach ($machine in $MachinesWithRole){
    $repository.repository.Machines.Delete($machine)
}