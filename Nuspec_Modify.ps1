$Nuspec = "C:\Test\MyApp.nuspec"
[xml]$xml = Get-Content $Nuspec

#Changing Release notes
$xml.package.metadata.releaseNotes = "Some new release notes"

#Changing version
$xml.package.metadata.version = "1.0.0"

#Changing description
$xml.package.metadata.description = "New description"

#saving nuspec changes
$xml.Save($Nuspec)