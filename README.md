## dotnet commands
https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet

dotnet new ca-sln # for clean architecture solution
dotnet new worker
dotnet new nugetconfig
dotnet add package Microsoft.Extensions.Logging --version 7.0.0
dotnet new classlib


dotnet build clean-architecture.sln

dotnet run

Ctrl + C to cancel running process 

## Errors
error NU1301: Failed to retrieve information about 'Microsoft.Identity.Client.Extensions.Msal' from remote source 'https://msazure.pkgs.visualstudio.com/_packagingd387a8da-063b-4a96-afb8-093924314a98@58be842d-c798-4641-9b49-96a8b9379fb0/nuget/v3/flat2/microsoft.identity.client.extensions.msal/index.json'

dotnet new nugetconfig