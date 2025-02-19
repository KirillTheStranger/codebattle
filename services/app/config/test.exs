import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :codebattle, CodebattleWeb.Endpoint,
  http: [port: 4001],
  server: true

config :codebattle, CodebattleWeb.BotEndpoint,
  http: [port: 4002],
  server: true

config :phoenix_integration, endpoint: CodebattleWeb.Endpoint

# Print only warnings and errors during test
# if is_nil(System.get_env("DEBUG")) do
#   config :logger, level: :critical
# else
config :logger, :console, level: :error
# end

# Configure your database
config :codebattle, Codebattle.Repo,
  username: System.get_env("CODEBATTLE_DB_USERNAME", "postgres"),
  password: System.get_env("CODEBATTLE_DB_PASSWORD", "postgres"),
  database: "codebattle_test",
  hostname: System.get_env("CODEBATTLE_DB_HOSTNAME", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false,
  pool_size: 50,
  ownership_timeout: 99_999_999

config :codebattle, Codebattle.Bot,
  timeout: 60_000,
  min_bot_step_timeout: 0

checker_executor =
  case System.get_env("CODEBATTLE_EXECUTOR") do
    "local" -> Codebattle.CodeCheck.Executor.Local
    "remote" -> Codebattle.CodeCheck.Executor.RemoteDockerRun
    "rust" -> Codebattle.CodeCheck.Executor.RemoteRust
    _ -> Codebattle.CodeCheck.Executor.Fake
  end

asserts_executor =
  case System.get_env("CODEBATTLE_EXECUTOR") do
    "local" -> Codebattle.AssertsService.Executor.Local
    "remote" -> Codebattle.AssertsService.Executor.Remote
    _ -> Codebattle.AssertsService.Executor.Fake
  end

config :codebattle, checker_executor: checker_executor
config :codebattle, asserts_executor: asserts_executor
config :codebattle, code_check_timeout: 35_000
config :codebattle, tournament_match_timeout: 1
config :codebattle, max_alive_tournaments: 700

config :codebattle, github_oauth_client: Codebattle.Oauth.GithubMock
config :codebattle, discord_oauth_client: Codebattle.Oauth.DiscordMock

config :codebattle, Codebattle.Invite,
  timeout: :timer.seconds(1000),
  lifetime: :timer.seconds(0)

config :codebattle, tasks_provider: Codebattle.Game.FakeTasksQueuesServer

config :codebattle, :firebase,
  sender_id: "ASDF",
  api_key: "ASDF",
  firebase_autn_url: "http://localhost:4000"

config :codebattle, ws_port: 4001

config :codebattle, freeze_time: true
config :codebattle, tournament_rematch_timeout_ms: 1

config :codebattle, user_rank_server: false
config :codebattle, create_bot_games: false
config :codebattle, fake_html_to_image: true
config :codebattle, app_version: "fc426ea537962d8e5af5e31e515f7000deeedc68"

config :runner, fake_docker_run: true
