FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

WORKDIR /app
COPY ./output/* /app
EXPOSE 5402
ENTRYPOINT ["dotnet", "webapi.dll"]
