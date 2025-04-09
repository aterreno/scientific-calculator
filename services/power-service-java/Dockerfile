FROM maven:3.9.9-eclipse-temurin-23 AS build

WORKDIR /app

COPY pom.xml .
# Download dependencies first for better caching
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package

FROM eclipse-temurin:23-jdk

WORKDIR /app

COPY --from=build /app/target/power-service-0.0.1-SNAPSHOT.jar ./power-service.jar

EXPOSE 8005

CMD ["java", "-jar", "power-service.jar"]