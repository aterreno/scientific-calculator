FROM swift:5.7-jammy as build

WORKDIR /app

COPY Package.swift .
COPY Sources ./Sources

RUN swift build -c release

FROM swift:5.7-jammy-slim

WORKDIR /app

COPY --from=build /app/.build/release/BitwiseService .

EXPOSE 8016

CMD ["./BitwiseService"]