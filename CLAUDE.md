# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Run Commands
- Build and start all services: `docker-compose up --build`
- Start frontend only: `cd frontend && npm start`
- Build TypeScript service: `cd services/conversion-service-typescript && npm run build`
- Run TypeScript service: `cd services/conversion-service-typescript && npm start`
- React tests: `cd frontend && npm test`
- Run a single React test: `cd frontend && npm test -- -t "test name"`

## Code Style Guidelines
- Each microservice uses its own language's conventions
- API endpoints use RESTful design: POST to `/operation` with JSON body
- Response format: `{"result": value}`
- Follow Docker best practices with proper base images
- Frontend: Follow React standard patterns for components
- TypeScript: Use strong typing, avoid 'any' type
- Error handling: Return appropriate HTTP status codes
- Variable naming: camelCase for JS/TS, language-specific for others
- Keep services independent and focused on single responsibility