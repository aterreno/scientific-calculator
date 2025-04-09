FROM rust:slim AS build

WORKDIR /usr/src/app
COPY . .

# Build with MUSL to create a fully static binary
RUN cargo build --release

FROM gcr.io/distroless/cc-debian12
COPY --from=build /usr/src/app/target/release/addition-service /usr/local/bin/addition-service

EXPOSE 8001
CMD ["addition-service"]