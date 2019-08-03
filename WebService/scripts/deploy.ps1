# Set-ExecutionPolicy -Scope CurrentUser Unrestricted -Force
Import-Module Webadministration

$PACKAGE_NAME = "$args"

$serviceName = "netcoreapi"
$DOCDIR = "C:\netcore-api"
$FolderPath = "$DOCDIR\Publish"

echo "Getting architechture..."
if([IntPtr]::size -eq 8) { Write-Host 'x64' } else { Write-Host 'x86' }

if(!(Test-Path -Path $DOCDIR )){
  New-Item -ItemType directory -Path $DOCDIR
  New-Item -ItemType directory -Path $DOCDIR\Sites
  New-Item -ItemType directory -Path $DOCDIR\Publish
}

echo "Copying zip file"


$BaseFileName = @(gci $PACKAGE_NAME | % {$_.BaseName})

echo "$PACKAGE_NAME, $BaseFileName"
echo "Renaming DONE"

$extractDestination = "$DOCDIR\Sites"
echo "$extractDestination\$BaseFileName"

GET-IISSite

echo "Extracting the zip folder... ...."
Expand-Archive -Path "$PACKAGE_NAME" -DestinationPath $extractDestination\$BaseFileName -Force
echo "Extraction DONE"

# if (!(Test-Path IIS:\Sites\$serviceName -pathType container))
# {
#     New-Item IIS:\Sites\$serviceName -bindings @{protocol="http";bindingInformation=":80:" + $serviceName} -physicalPath $extractDestination\$BaseFileName
# }

Set-ItemProperty IIS:\Sites\netcoreapi -name  physicalPath -value "$extractDestination\$BaseFileName"
echo "Changed $serviceName SourePath in IIS..."

echo "Restarting WebAppPool"
Restart-WebAppPool netcoreapi
echo "WebAppPool Restarted"
echo "DONE!!"
