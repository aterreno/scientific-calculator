FROM mcr.microsoft.com/dotnet/nightly/sdk:9.0-preview AS build-env
WORKDIR /app

# Copy fsproj and restore as distinct layers
COPY *.fsproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/nightly/aspnet:9.0-preview
WORKDIR /app
COPY --from=build-env /app/out .

EXPOSE 8006
ENTRYPOINT ["dotnet", "SquareRootService.dll"]