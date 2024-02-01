defmodule Core.Account.Seed do
  @moduledoc """
  Seeds the database with some initial account data.
  """
  import Core.Account.User, only: [sign_up!: 1]

  def run do
    sign_up!(%{email: "link@cona.com", password: "cona2024!"})
    sign_up!(%{email: "zelda@cona.com", password: "cona2024!"})
  end
end
