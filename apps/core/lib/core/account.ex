defmodule Core.Account do
  use Ash.Api,
    extensions: [AshGraphql.Api]

  resources do
    registry Core.Account.Registry
  end
end
