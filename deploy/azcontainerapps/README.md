main=prod

### creates azure ARM json deployment template
az bicep build --file .\main.bicep

### deploy from vscode
az deployment group create --resource-group caRG --template-file main.bicep --mode Incremental --verbose