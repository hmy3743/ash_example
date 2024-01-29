import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_web, GraphqlWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "xpOSyrEZd+bNkqiZ+ENAPSASCFAUNdwBa47uvs+CUeVAoeYBRXY8dh9kjOn5oZSQ",
  server: false

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "cona_test#{System.get_env("TEST_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :bcrypt_elixir, log_rounds: 1
