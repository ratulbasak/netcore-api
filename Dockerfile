FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build

WORKDIR /app

ENV PATH="${PATH}:/root/.dotnet/tools"
RUN dotnet tool install -g dotnet-reportgenerator-globaltool

# copy csproj and restore as distinct layers
COPY . .
RUN dotnet restore netcore-api.sln

# copy everything else and build app
RUN ls -al
RUN dotnet build ./api/netcore-api.csproj --configuration Release -o Publish
RUN dotnet build Api.Test/Api.Test.csproj --configuration Debug

RUN dotnet test --logger 'trx;LogFileName=NetCore.API.UnitTests.trx' \
    --results-directory /app/testsResults \
    /p:CollectCoverage=true \
    /p:CoverletOutput=/app/testsResults/Coverage/ \
    /p:CoverletOutputFormat=cobertura \
    /p:Exclude='[nunit.*]*' \
    ./netcore-api.sln

RUN ls -al /app/testsResults
#RUN reportgenerator \
#    "-reports:/app/testsResults/Coverage/coverage.cobertura.xml" \
#    "-targetdir:/app/testsResults/Coverage" \
#    -reporttypes:HTML

#WORKDIR /app/src/
RUN dotnet publish ./api/netcore-api.csproj -c Release -o /app/out

FROM mcr.microsoft.com/dotnet/core/aspnet:2.1
WORKDIR /app
COPY --from=build /app/out .
COPY --from=build /app/testsResults ./testsResults
RUN ls
RUN ls Publish
ENTRYPOINT ["dotnet", "netcore-api.dll"]
#ENTRYPOINT ["/bin/bash"]
