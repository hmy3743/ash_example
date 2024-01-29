defmodule Mix.Tasks.Reset do
  use Mix.Task

  def run(_) do
    IO.puts("Seeding database...")
    IO.puts("Connecting to database...")
    {:ok, _} = Application.ensure_all_started(:core) |> IO.inspect()
    Mix.Tasks.SeedUser.seed()
  end
end
