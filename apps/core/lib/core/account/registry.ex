defmodule Core.Account.Registry do
  use Ash.Registry

  entries do
    entry Core.Account.User
    entry Core.Account.Token
  end
end
