FROM clojure:latest AS build

WORKDIR /app

COPY deps.edn .
RUN clojure -A:deps -P

COPY . .
RUN clojure -T:build uber

FROM openjdk:17-slim

WORKDIR /app

COPY --from=build /app/target/complex-service-standalone.jar .

EXPOSE 8017

CMD ["java", "-jar", "complex-service-standalone.jar"]