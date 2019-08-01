# Set-ExecutionPolicy -Scope CurrentUser Unrestricted -Force
Import-Module Webadministration

$PACKAGE_NAME=$args[0]
$PACKAGE=$args[1]

$serviceName = "netcoreapi"
$DOCDIR = "C:\netcore-api"
$FolderPath = "$DOCDIR\Publish"

# $message = "Found {0} zip files: `r`n`r`n{1}" -f $file.Count, ("{0} - {1}" -f $file.FullName, $file.LastWriteTime)
# echo $message

if(!(Test-Path -Path $DOCDIR )){
  New-Item -ItemType directory -Path $DOCDIR
  New-Item -ItemType directory -Path $DOCDIR\Sites
  New-Item -ItemType directory -Path $DOCDIR\Publish
}

echo "Copying zip file"


$BaseFileName = @(gci $PACKAGE | % {$_.BaseName})
echo "$PACKAGE"
echo "$PACKAGE_NAME"
echo "Renaming DONE"

$extractDestination = "$DOCDIR\Sites"

echo "Extracting the zip folder... ...."
Expand-Archive -Path "$PACKAGE_NAME" -DestinationPath $extractDestination\$BaseFileName -Force
echo "Extraction DONE"

if (!(Test-Path IIS:\Sites\$serviceName -pathType container))
{
    New-Item IIS:\Sites\$serviceName -bindings @{protocol="http";bindingInformation=":80:" + $serviceName} -physicalPath $extractDestination\$BaseFileName
}

Set-ItemProperty IIS:\Sites\$serviceName -name  physicalPath -value $extractDestination\$BaseFileName
echo "Changed $serviceName SourePath in IIS..."

echo "Restarting WebAppPool"
Restart-WebAppPool $serviceName
echo "WebAppPool Restarted"
echo "DONE!!"
