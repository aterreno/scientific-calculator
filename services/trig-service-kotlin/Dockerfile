FROM gradle:8.7-jdk21 AS build

WORKDIR /app

COPY build.gradle.kts settings.gradle.kts ./
COPY src ./src

RUN gradle build --no-daemon

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=build /app/build/libs/trig-service-0.0.1-SNAPSHOT.jar ./trig-service.jar

EXPOSE 8008

CMD ["java", "-jar", "trig-service.jar"]