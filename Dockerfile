# Use an official Elixir image as the base image
ARG ELIXIR_VERSION=1.16.1
ARG OTP_VERSION=26.2.1
ARG DEBIAN_VERSION=bullseye-20231009

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}-slim"

FROM ${BUILDER_IMAGE} as builder

ENV MIX_ENV="prod"
# Set the working directory inside the container
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force

# Install rebar (required by some Elixir packages)
RUN mix local.rebar --force

# Install Node.js and NPM (required for Phoenix assets)
RUN apt-get update -y && apt-get install -y nodejs build-essential

COPY mix.exs mix.lock ./
COPY apps/core/mix.exs ./apps/core/mix.exs
COPY apps/graphql_web/mix.exs ./apps/graphql_web/mix.exs
RUN mix deps.get --only prod
RUN mix deps.compile
RUN mix compile

# Copy the entire umbrella project to the container
COPY apps apps

# Install dependencies for the umbrella project
RUN mix deps.get --only prod

# Set the environment variables for the Phoenix app
ENV MIX_ENV=prod
ENV PORT=4000

# Compile the umbrella project and assets
COPY config config
RUN mix compile
RUN mix assets.deploy

ARG RELEASE

RUN mix release ${RELEASE}

FROM ${RUNNER_IMAGE} as runner

WORKDIR /app
ARG RELEASE
ENV LC_ALL=C.UTF-8
ENV MIX_ENV="prod"
ENV RELEASE=${RELEASE}
ENV PHX_SERVER="true"

COPY --from=builder /app/_build/${MIX_ENV}/rel/${RELEASE} .

# Expose the Phoenix port (change this to the actual port you use in the Phoenix app)
EXPOSE 4000

# Start the Phoenix app (adjust the command based on your actual entrypoint)
CMD fallocate -l 512M /swapfile \
  ;chmod 0600 /swapfile \
  ;mkswap /swapfile \
  ;echo 10 > /proc/sys/vm/swappiness \
  ;swapon /swapfile \
  ;echo 1 > /proc/sys/vm/overcommit_memory \
  ;./bin/$RELEASE start
