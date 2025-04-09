FROM gradle:7.6-jdk17 AS build

WORKDIR /app

COPY build.gradle.kts settings.gradle.kts ./
COPY src ./src

RUN gradle build --no-daemon

FROM openjdk:17-slim

WORKDIR /app

COPY --from=build /app/build/libs/trig-service-0.0.1-SNAPSHOT.jar ./trig-service.jar

EXPOSE 8008

CMD ["java", "-jar", "trig-service.jar"]