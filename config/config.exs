# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :graphql_web,
  ecto_repos: [GraphqlWeb.Repo],
  generators: [context_app: false]

# Configures the endpoint
config :graphql_web, GraphqlWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: GraphqlWeb.ErrorHTML, json: GraphqlWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GraphqlWeb.PubSub,
  live_view: [signing_salt: "1yM69zkK"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/graphql_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/graphql_web/assets", __DIR__)
  ]

config :core, :ash_apis, [Core.Account, Core.Review, Core.Classification]

config :core, ecto_repos: [Core.Repo]

config :ash_graphql, :default_managed_relationship_type_name_template, :action_name

import_config "#{config_env()}.exs"
