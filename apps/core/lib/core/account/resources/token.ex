defmodule Core.Account.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api Core.Account
  end

  postgres do
    table "token"
    repo Core.Repo
  end
end
