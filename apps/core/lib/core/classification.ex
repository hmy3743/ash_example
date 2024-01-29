defmodule Core.Classification do
  use Ash.Api

  resources do
    registry Core.Classification.Registry
  end
end
