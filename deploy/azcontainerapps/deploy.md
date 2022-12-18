main=prod

### Integrate Pipeline with Azure bicep
https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/add-template-to-azure-pipelines?tabs=CLI

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-secrets

### creates azure ARM json deployment template
az bicep build --file .\main.bicep

### deploy from vscode
az deployment group create --resource-group caRG --template-file main.bicep --mode Incremental --verbose

### SPN
https://learn.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli

https://github.com/MicrosoftDocs/azure-docs/issues/16906

### Azure Scope

Management Groups
Subscriptions
Resource Groups
Resources (AppService, StorageAccount, etc)

Wrapping the command with $() assigns the command's return value to variable

KeyVaultParameterReferenceSecretRetrieveFailed
https://stackoverflow.com/questions/52740298/getting-error-keyvaultparameterreferenceauthorizationfailed-while-deploying-log

The key vault must have enabledForTemplateDeployment set to true. 
The user deploying the Bicep file must have access to the secret.