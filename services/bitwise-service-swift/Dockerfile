FROM swift:5.7-jammy AS build

WORKDIR /app

COPY Package.swift .
COPY Sources ./Sources
COPY Tests ./Tests
COPY run.sh .

# Run tests first
RUN swift test

# Then build for release
RUN swift build -c release

FROM swift:5.7-jammy-slim

WORKDIR /app

COPY --from=build /app/.build/release/BitwiseService .

EXPOSE 8016

CMD ["./BitwiseService"]