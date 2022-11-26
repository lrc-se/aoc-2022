FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build

WORKDIR /src
COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o /app --no-self-contained --no-restore

FROM mcr.microsoft.com/dotnet/runtime:7.0-alpine

WORKDIR /app
COPY --from=build /app .
COPY input*.txt ./

ENTRYPOINT ["./Aoc"]
