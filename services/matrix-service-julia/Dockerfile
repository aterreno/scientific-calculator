FROM julia:1.8-bullseye

WORKDIR /app

# Copy project files
COPY Project.toml .
COPY Manifest.toml* .

# Explicitly install required packages
RUN julia -e 'using Pkg; Pkg.add(["HTTP", "JSON", "LinearAlgebra"]); Pkg.precompile()'

# Copy the rest of the application
COPY . .

# Create necessary directories
RUN mkdir -p src

EXPOSE 8014

CMD ["julia", "app.jl"]