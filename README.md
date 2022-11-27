## dotnet commands
https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet

dotnet new ca-sln # for clean architecture solution
dotnet new worker
dotnet new nugetconfig
dotnet add package Microsoft.Extensions.Logging --version 7.0.0
dotnet new classlib
dotnet new webapi
dotnet build clean-architecture.sln
dotnet add reference ..\..\..\Contracts\Contracts.csproj
dotnet sln add .\src\Workers\V2022-11-15\OrderProcessor\OrderProcessor.csproj

dotnet run

Ctrl + C to cancel running process 

## Setup development environment
https://blog.danielpadua.dev/posts/vscode-aspnet-core-setup-development-environment/#:~:text=Put%20a%20breakpoint%20in%20any%20line%20of%20Startup.cs,ready%2C%20select%20%E2%80%9C.NET%20Core%E2%80%9D%20in%20the%20main%20bar.

## Errors
error NU1301: Failed to retrieve information about 'Microsoft.Identity.Client.Extensions.Msal' from remote source 'https://msazure.pkgs.visualstudio.com/_packagingd387a8da-063b-4a96-afb8-093924314a98@58be842d-c798-4641-9b49-96a8b9379fb0/nuget/v3/flat2/microsoft.identity.client.extensions.msal/index.json'

Failed to determine the https port for redirect.
set env variable HTTPS_PORT