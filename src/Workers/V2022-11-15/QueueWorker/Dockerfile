FROM mcr.microsoft.com/dotnet/core/runtime:7.0 AS base
# set the working directory for container for all the subsequent Dockerfile instructions.
# if the WORKDIR is not manually created, it gets created automatically during the processing of the instructions.
# If you use relative paths as Working Directory, it will be relative to the previous Working Directory.
WORKDIR /app

# we need to do build inside container and publish build artificats.
# the build artificats are then used on the runtime image to create a container image
# in order to build QueueWorker.csproj, we need to have its dependecies Contracts.csproj as well.
FROM mcr.microsoft.com/dotnet/core/sdk:7.0 AS build
WORKDIR /src   
# above will create a folder in container /app/src

# copies [localSrc1, localSrc2, containerDestination]
# paths of files and directories will be interpreted as relative to the source of the context of the build.
COPY ["src/Workers/V2022-11-15/QueueWorker/QueueWorker.csproj", "Workers/V2022-11-15/QueueWorker/"]
COPY ["src/Contracts/Contracts.csproj", "Contracts/"]

# execute dotnet command to get all nuget dependencies.
RUN dotnet restore "src/Workers/V2022-11-15/QueueWorker/QueueWorker.csproj"
COPY . .

# Go to QueueWorker folder inside container and do a dotnet build
WORKDIR "/src/Workers/V2022-11-15/QueueWorker"
RUN dotnet build "QueueWorker.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "QueueWorker.csproj" -c Release -o /app

# Build runtime image that will be deployed
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "QueueWorker.dll"]