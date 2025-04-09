FROM elixir:1.14-alpine AS build

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs .
RUN mix deps.get
RUN mix deps.compile

COPY . .
RUN mix compile

CMD ["mix", "run", "--no-halt"]