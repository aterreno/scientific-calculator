FROM elixir:1.13-alpine

WORKDIR /app

# Install Alpine build dependencies
RUN apk add --no-cache build-base git

# Install Elixir build dependencies
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV to prod for optimized build
ENV MIX_ENV=prod

# Copy mix files first for better caching
COPY mix.exs mix.lock* ./

# Get dependencies
RUN mix deps.get --only prod

# Copy the rest of the application code
COPY . .

# Compile the application
RUN mix compile

# Use a simpler approach - one-stage build with the same image
# The multi-stage approach was causing issues with Erlang/Elixir module loading

EXPOSE 8010

CMD ["mix", "run", "--no-halt"]