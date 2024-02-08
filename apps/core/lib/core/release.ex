defmodule Core.Release do
  def migrate do
    Application.load(:core)
    {:ok, _, _} = Ecto.Migrator.with_repo(Core.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def rollback(repo) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, all: true))
  end

  def reset do
    Application.load(:core)
    Application.ensure_all_started(:ash_postgres)

    Core.Repo.__adapter__().storage_down(Keyword.merge(Core.Repo.config(), force_drop: true))
    Core.Repo.__adapter__().storage_up(Core.Repo.config())
    Process.sleep(5000)

    migrate()

    unless Process.whereis(Core.Repo) do
      Supervisor.start_link([Core.Repo],
        strategy: :one_for_one,
        name: Core.Release.Supervisor
      )
    end

    Core.Account.Seed.run()
    Core.Review.Seed.run()
    Core.Classification.Seed.run()
  end
end
