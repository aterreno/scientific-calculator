FROM julia:1.8-bullseye

WORKDIR /app

COPY Project.toml .
COPY Manifest.toml .

RUN julia -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

COPY . .

EXPOSE 8014

CMD ["julia", "app.jl"]