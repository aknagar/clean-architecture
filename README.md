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

## dotnet 6+
Unifies Startup.cs and Program.cs into a single Program.cs file.

## C# 10+
https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10


## Logging
https://blog.datalust.co/using-serilog-in-net-6/

### Difference b/w WebHost and Host in Program.cs
https://stackoverflow.com/questions/59745401/what-is-the-difference-between-host-and-webhost-class-in-asp-net-core

## Errors
error NU1301: Failed to retrieve information about 'Microsoft.Identity.Client.Extensions.Msal' from remote source 'https://msazure.pkgs.visualstudio.com/_packagingd387a8da-063b-4a96-afb8-093924314a98@58be842d-c798-4641-9b49-96a8b9379fb0/nuget/v3/flat2/microsoft.identity.client.extensions.msal/index.json'

Failed to determine the https port for redirect.
set env variable HTTPS_PORT

## Azure CLI
az account show

## Dotnet secret management
https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets?view=aspnetcore-7.0&tabs=windows

https://dev.to/gutsav/using-dotnet-secrets-43bg#:~:text=The%20dotnet%20user-secrets%20init%20command%20enables%20storage%20of,to%20identify%20which%20secrets%20belong%20to%20which%20project.

%APPDATA%\Microsoft\UserSecrets\

dotnet user-secrets init
type ..\..\..\secrets.json | dotnet user-secrets set
dotnet user-secrets clear

## Logging

High performance
https://learn.microsoft.com/en-us/aspnet/core/fundamentals/logging/loggermessage?view=aspnetcore-7.0

## Docker Containers

https://devblogs.microsoft.com/dotnet/announcing-builtin-container-support-for-the-dotnet-sdk/

dotnet add package Microsoft.NET.Build.Containers

--create container image using dotnet sdk.
dotnet publish --os linux --arch x64 -c Release -p:PublishProfile=DefaultContainer

# run your app using the new container
docker run -it --rm -p 5010:80 v2022-11-15:1.0.0

https://learn.microsoft.com/en-us/dotnet/core/docker/publish-as-container

https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md

Press F1 to open the Command Palette.
Type add dev container

