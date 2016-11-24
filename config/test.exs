use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ping, Ping.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ping, Ping.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "22143521",
  database: "ping_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
