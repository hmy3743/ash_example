defmodule Core.Repo do
  use AshPostgres.Repo, otp_app: :core

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
