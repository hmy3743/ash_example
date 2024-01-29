defmodule Core.Classification.Registry do
  use Ash.Registry

  entries do
    entry Core.Classification.Tag
  end
end
